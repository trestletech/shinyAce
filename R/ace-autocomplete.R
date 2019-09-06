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
#'        value:        <str: value to be inserted upon completion (e.g. "print()")>,
#'        caption:      <str: value to be displayed (e.g. "print() # prints text")>,
#'        score:        <num: score to pass to ace editor for sorting>,
#'        meta:         <str: meta text on right of completion>
#'        r_symbol:     <str: symbol name of completion item>,
#'        r_envir_name: <str: name of the environment from which the symbol is referenced>,
#'        r_help_type:  <str: a datatype for dispatching help documentation function>,
#'        completer:    <str: used for dispatching default insertMatch functions>,
#'     }
#'   ]
#'   }
#'
#' @export
aceAutocomplete <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  shiny::observeEvent(session$input[[paste0(inputId, "_shinyAce_hint")]], {
    # largely inspired by rstudio/learnr
    # https://github.com/rstudio/learnr/blob/master/R/http-handlers.R
    # 779ac571db5e5915875c845dd10d9b90cc399218 #L157-L232

    # read params
    value <- session$input[[paste0(inputId, "_shinyAce_hint")]]
    if (is.empty(value)) {
      return(NULL)
    }

    line <- substring(value$linebuffer, 1, value$cursorPosition$col)
    completions <- r_completions_metadata(line)

    return(session$sendCustomMessage("shinyAce", list(
      id = session$ns(inputId),
      codeCompletions = jsonlite::toJSON(completions, auto_unbox = TRUE)
    )))
  })
}



#' Return completions for a given line of text
#'
#' @param line the text up until the cursor in the line for autocompletion
#'
r_completions_metadata <- function(line) {
  # set completion settings
  options <- utils::rc.options()
  utils::rc.options(
    package.suffix = "::",
    funarg.suffix = "",
    function.suffix = "()"
  )
  on.exit(do.call(utils::rc.options, as.list(options)), add = TRUE)

  settings <- utils::rc.settings()
  utils::rc.settings(
    ops = TRUE, ns = TRUE, args = TRUE, func = FALSE, ipck = TRUE, S3 = FALSE,
    data = TRUE, help = TRUE, argdb = TRUE, fuzzy = FALSE, files = TRUE,
    quotes = TRUE
  )
  on.exit(do.call(utils::rc.settings, as.list(settings)), add = TRUE)

  completions <- character()
  try(silent = TRUE, {
    .utils$.assignLinebuffer(line)
    .utils$.assignEnd(nchar(line))
    .utils$.guessTokenFromLine()
    .utils$.completeToken()
    completions <- as.character(.utils$.retrieveCompletions())
  })

  is_func <- grepl(.fname_regex, line)
  fname <- gsub(.fname_regex, "\\1", line)

  if (!length(completions)) {
    list()
  } else if (is_func) {
    r_completions_function_call_metadata(fname, completions)
  } else {
    r_completions_general_metadata(completions)
  }
}



#' R completions when cursor is within a function call
#'
#' @param fname the function name for which the function call specific
#'   completion metadata should be constructed
#' @inheritParams r_completions_general_metadata
#'
r_completions_function_call_metadata <- function(fname, completions) {
  splat <- strsplit(fname, ":{2,3}")[[1]]
  n <- length(splat)

  symbol <- if (n == 2) splat[[2]] else splat[[1]]
  envir <- if (n == 2) asNamespace(splat[[1]]) else .GlobalEnv

  # get call object
  obj <- tryCatch(get(symbol, envir = envir), error = function(e) NULL)

  # deduce environment name
  envir_name <- if (isNamespace(envir)) {
    getNamespaceName(envir)
  } else if (!is.null(environment(obj))) {
    environmentName(environment(obj))
  } else {
    ""
  }

  # get formal arguments to populate with default values
  frmls <- tryCatch(formals(obj),
    warning = function(e) "",
    error = function(e) ""
  )

  # quote singular character formal values
  chr_len1_frmls <- vapply(frmls, length, numeric(1L)) == 1L &
    vapply(frmls, is.character, logical(1L))
  frmls[chr_len1_frmls] <- paste0('"', frmls[chr_len1_frmls], '"')

  # ensure formal arg default values follow same order as completions
  frmls_i <- completions %in% names(frmls)
  completions <- c(completions[frmls_i], completions[!frmls_i])
  frmls_i <- completions %in% names(frmls)

  # determine help type for completions
  r_help_type <- rep("", length(completions))
  r_help_type[frmls_i] <- "parameter"
  r_help_type[!frmls_i] <- ifelse(
    completions[!frmls_i] %in% installed.packages()[, "Package"],
    "package",
    r_help_type[!frmls_i]
  )

  # map help type to meta text display
  meta <- ifelse(r_help_type == "package", meta_pkg(), "")

  # truncate really long captions
  captions <- completions
  values <- completions
  values[frmls_i] <- paste0(completions[frmls_i], " = ")
  captions[frmls_i] <- paste0(completions[frmls_i], " = ", frmls[completions[frmls_i]])
  captions[!frmls_i] <- ifelse(nchar(captions[!frmls_i]) >= 28,
    paste0(substr(captions[!frmls_i], 1, 28), "\u2026"), # (ellipses)
    captions[!frmls_i]
  )

  # build completions metadata
  unname(Map(function(value, caption, meta, r_help_type, score) {
    list(
      value = value,
      caption = caption,
      score = score,
      meta = meta,
      r_envir = envir_name,
      r_symbol = symbol,
      r_help_type = r_help_type,
      completer = "rlang"
    )
  }, values, captions, meta, r_help_type, rev(seq_along(completions))))
}



#' R completions for general case
#'
#' @param completions a character vector of completions. These will serve as the
#'   foundation for building added R-specific metadata
#'
r_completions_general_metadata <- function(completions) {
  completions <- sort(completions[nzchar(completions)])
  splat <- strsplit(completions, ":{2,3}")

  unname(Map(function(completion, el, score) {
    n <- length(el)
    symbol <- if (n == 2) el[[2]] else el[[1]]
    envir <- if (n == 2) asNamespace(el[[1]]) else .GlobalEnv

    # try to get object, attempting object or namespace
    obj <- tryCatch({
      get(symbol, envir = envir)
    }, error = function(e) tryCatch({
        asNamespace(symbol)
      }, error = function(e) {
        NULL
      }))

    # deduce environment name
    envir_name <- if (isNamespace(envir)) {
      getNamespaceName(envir)
    } else if (!is.null(environment(obj))) {
      environmentName(environment(obj))
    } else {
      ""
    }

    # determine tooltip type
    r_help_type <- if (isNamespace(obj)) {
      "package"
    } else if (is.function(obj)) {
      "function"
    } else {
      "object"
    }

    meta <- switch(r_help_type,
      "object" = meta_obj(),
      "package" = meta_pkg(),
      envir_name
    )

    # add () suffix to functions (excluding user-defined infix operators)
    name <- if (is.function(obj) && !grepl("^%", as.character(symbol))) {
      paste0(completion, "()")
    } else {
      completion
    }


    # Some example tooltip metadata:
    #
    #               pri_       mtc_       dply_    dplyr::case_whe_
    #               print      mtcars     dplyr           case_when
    #
    #       value:  print()    mtcars     dplyr::  dplyr::case_when()
    #     caption:  print()    mtcars     dplyr::  case_when()
    #        meta:  base       {obj}      {pkg}    dplyr
    #    r_symbol:  print      mtcars     dplyr    case_when
    #     r_envir:  base       datasets   NULL     dplyr
    # r_help_type:  function   object     package  function

    list(
      # Ace standard autocomplete display fields
      value = gsub("::$", "", name),
      caption = gsub("(.*::(.+)|(.*)::$)", "\\2\\3", name),
      score = score,
      meta = meta,
      # shinyAce-specific autocomplete metadata fields for interfacing with R
      r_symbol = symbol,
      r_envir = envir_name,
      r_help_type = r_help_type,
      completer = "rlang"
    )
  }, completions, splat, rev(seq_along(completions))))
}
