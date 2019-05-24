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
aceAnnotate <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  shiny::observeEvent(session$input[[paste0(inputId, "_shinyAce_annotationTrigger")]], {
    value <- session$input[[inputId]]
    
    annotations <- list()

    parse_out <- tryCatch({
      parse(text = value);
      NULL
    }, error = function(e) e)

    if (is.expression(parse_out)) {
      
    } else if ("error" %in% class(parse_out)) {
      annotation <- as.list(re_capture(
        parse_out$message,
        "(?s).*:(?<row>\\d+):(?<column>\\d+):(?<text>.*)",
        perl = TRUE))

      num_cols <- c("row", "column")
      annotation[num_cols] <- as.numeric(annotation[num_cols])
      annotation$row <- annotation$row - 2
      annotation$type <- "error"
      
      return(session$sendCustomMessage('shinyAce', list(
        id = session$ns(inputId),
        annotations = jsonlite::toJSON(list(annotation), auto_unbox = TRUE))))
    }
    
    return(session$sendCustomMessage('shinyAce', list(
      id = session$ns(inputId),
      annotations = jsonlite::toJSON(list(), auto_unbox = TRUE))))
  })
}
