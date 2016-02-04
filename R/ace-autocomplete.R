#' Enable Code Completion for an Ace Code Input
#' 
#' This function dynamically auto complete R code pieces using built-in function
#' \code{utils:::.win32consoleCompletion}. Please see \code{\link[utils]{rcompgen}} for details.
#' 
#' @details
#' You can implement your own code completer by listening to \code{input$shinyAce_<editorId>_hint}
#' where <editorId> is the \code{aceEditor} id. The input contains
#' \itemize{
#'  \item \code{linebuffer}: Code/Text at current editing line
#'  \item \code{cursorPosition}: Current cursor position at this line
#' }
#' 
#' @param inputId The id of the input object
#' @param session The \code{session} object passed to function given to shinyServer
#' @return An observer reference class object that is responsible for offering code completion.
#' See \code{\link[shiny]{observe}} for more details. You can use \code{suspend} or \code{destroy}
#' to pause to stop dynamic code completion.
#' @export 
aceAutocomplete <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  shiny::observe({
    value <- session$input[[paste0("shinyAce_", inputId, "_hint")]]
    if(is.null(value)) return(NULL)
    
    utilEnv <- environment(utils::alarm)
    w32 <- get(".win32consoleCompletion", utilEnv)
    
    comps <- list(id = inputId,
                  codeCompletions = w32(value$linebuffer, value$cursorPosition)$comps)
    
    session$sendCustomMessage('shinyAce', comps)
  })
}