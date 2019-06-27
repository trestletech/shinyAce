#' Enable Code Completion for an Ace Code Input
#'
#' This function dynamically auto complete R code pieces using built-in function
#' \code{utils:::.win32consoleCompletion}. Please see \code{\link[utils]{rcompgen}} for details.
#'
#' @details
#' You can implement your own code completer by listening to \code{input$<editorId>_shinyAce_hint}
#' where <editorId> is the \code{aceEditor} id. The input contains
#' \itemize{
#'  \item \code{linebuffer}: Code/Text at current editing line
#'  \item \code{cursorPosition}: Current cursor position at this line
#' }
#'
#' @param inputId The id of the input object
#' @param session The \code{session} object passed to function given to shinyServer
#' 
#' @return An observer reference class object that is responsible for offering code completion.
#' See \code{\link[shiny]{observe}} for more details. You can use \code{suspend} or \code{destroy}
#' to pause to stop dynamic code completion.
#' 
#' @export
aceAutocomplete <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  shiny::observe({
    value <- session$input[[paste0(inputId, "_shinyAce_hint")]]
    if (is.empty(value)) return(NULL)

    utilEnv <- environment(utils::alarm)
    w32 <- get(".win32consoleCompletion", utilEnv)
    codeCompletions <- w32(value$linebuffer, value$cursorPosition$col)$comps
    codeCompletions <- strsplit(codeCompletions, " ", fixed = TRUE)[[1]]
    codeCompletions <- lapply(codeCompletions, function(completion) {
      list(name = completion, value = completion, meta = "R")
    })

    comps <- list(
      id = session$ns(inputId),
      codeCompletions = jsonlite::toJSON(codeCompletions, auto_unbox = TRUE)
    )
    session$sendCustomMessage('shinyAce', comps)
  })
}
