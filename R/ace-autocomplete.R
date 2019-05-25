#' Enable Code Completion for an Ace Code Input
#'
#' This function dynamically auto complete R code pieces using built-in
#' functions \code{utils:::.assignLinebuffer}, \code{utils:::.assignEnd},
#' \code{utils:::.guessTokenFromLine} and \code{utils:::.completeToken}.
#'
#' @details
#' You can implement your own code completer by listening to \code{input$<editorId>_shinyAce_hint}
#' where <editorId> is the \code{aceEditor} id. The input contains
#' \itemize{
#'   \item \code{linebuffer}: Code/Text at current editing line
#'   \item \code{cursorPosition}: Current cursor position at this line
#' }
#'
#' @param inputId The id of the input object
#' @param session The \code{session} object passed to function given to shinyServer
#'
#' @return An observer reference class object that is responsible for offering
#'   code completion. See \code{\link[shiny]{observe}} for more details. You can
#'   use \code{suspend} or \code{destroy} to pause to stop dynamic code
#'   completion.
#'   
#'   The observer reference object will send a custom shiny message using
#'   \code{session$sendCustomMessage} to the codeCompletions endpoint containing
#'   a json list of completion item metadata objects. The json list should have
#'   a structure akin to:
#'   
#'   \preformatted{
#'   [
#'     {
#'        inputId: <str: inputId, expected for tooltips>, 
#'        symbol:  <str: symbol name of completion item>,
#'        name:    <str: value to be inserted upon completion (e.g. "print()")>, 
#'        value:   <str: value to be inserted upon completion (e.g. "print()")>,
#'        score:   <num: score to pass to ace editor for sorting>,
#'        meta:    <str: meta text on right of completion>
#'     }
#'   ]
#'   }
#'
#' @export
aceAutocomplete <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  shiny::observe({
    # read params
    value <- session$input[[paste0(inputId, "_shinyAce_hint")]]
    if (is.null(value)) return(NULL)

    # build code completion input
    line <- substring(value$linebuffer, 1, value$cursorPosition$col)
    
    # set completion settings
    options <- utils::rc.options()
    utils::rc.options(
      package.suffix = "::",
      funarg.suffix = "",
      function.suffix = "()")
    on.exit(do.call(utils::rc.options, as.list(options)), add = TRUE)
    
    settings <- utils::rc.settings()
    utils::rc.settings(
      ops = TRUE, ns = TRUE, args = TRUE, func = FALSE, ipck = TRUE, S3 = FALSE, 
      data = TRUE, help = TRUE, argdb = TRUE, fuzzy = FALSE, files = TRUE, 
      quotes = TRUE)
    on.exit(do.call(utils::rc.settings, as.list(settings)), add = TRUE)
    
    completions <- character()
    meta <- character()
    
    try(silent = TRUE, {
      utils <- asNamespace("utils")
      utils$.assignLinebuffer(line)
      utils$.assignEnd(nchar(line))
      utils$.guessTokenFromLine()
      utils$.completeToken()
      completions <- as.character(utils$.retrieveCompletions())
    })

    # handle within paren of function call separately
    if (grepl("[a-zA-Z0-9._]\\([^)]*$", line)) {
      fname <- gsub("(?:^|.*[^a-zA-Z0-9._:])([a-zA-Z0-9._:]+)\\([^)]*$", "\\1", line)
      splat <- strsplit(fname, ":{2,3}")[[1]]
      n <- length(splat)
      
      symbol <- if (n == 2) splat[[2]] else splat[[1]]
      envir <- if (n == 2) asNamespace(splat[[1]]) else .GlobalEnv
      
      # get call object
      obj <- tryCatch(get(symbol, envir = envir), error = function(e) NULL)
      
      # get formal arguments to populate with default values
      frmls <- tryCatch(formals(obj), 
        warning = function(e) "", 
        error = function(e) "")
      
      # ensure formal arg default values follow same order as completions
      comp_frmls <- vector("character", length(completions))
      frmls_i <- completions %in% names(frmls)
      comp_frmls[frmls_i] <- as.character(frmls[completions[frmls_i]])
      
      # get environment name if possible
      meta <- if (!is.null(obj)) environmentName(environment(obj)) else "R"
      
      # truncate really long captions
      captions <- paste0(completions, " = ", comp_frmls)
      captions <- ifelse(nchar(captions) >= 28, 
        paste0(substr(captions, 1, 28), "\u2026"),
        captions)
      
      completions <- unname(Map(function(completion, frml, caption, meta, score) {
        list(
          inputId = inputId,
          symbol = symbol,
          name = completion,
          value = paste0(completion, " = "),
          caption = caption,
          score = score,
          meta = meta)
      }, completions, comp_frmls, captions, meta, rev(seq_along(completions))))
      
    } else {
      completions <- sort(completions[nzchar(completions)])
      
      splat <- strsplit(completions, ":{2,3}")
      completions <- unname(Map(function(completion, el, score) {
        n <- length(el)
        symbol <- if (n == 2) el[[2]] else el[[1]]
        envir <- if (n == 2) asNamespace(el[[1]]) else .GlobalEnv
        
        # get call object
        obj <- tryCatch(get(symbol, envir = envir), error = function(e) NULL)
        
        # detect functions
        if (!is.null(obj)) {
          fn <- is.function(obj) 
          meta <- environmentName(environment(obj))
        } else {
          fn <- NULL
          meta <- "R"
        }
        
        name <- if (isTRUE(fn)) paste0(completion, "()") else completion
        
        list(
          inputId = inputId, 
          symbol = symbol,
          name = name, 
          value = name,
          caption = gsub(".*::", "", name),
          score = score,
          meta = meta)
      }, completions, splat, rev(seq_along(completions))))
    }
    
    session$sendCustomMessage('shinyAce', list(
      id = session$ns(inputId),
      codeCompletions = jsonlite::toJSON(completions, auto_unbox = TRUE)
    ))
  })
}
