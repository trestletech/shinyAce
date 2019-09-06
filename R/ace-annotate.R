#' Enable Error Annotations for an Ace Code Input
#'
#' This function dynamically evaluate R for syntax errors using the
#' \code{\link{parse}} function.
#'
#' @details
#' You can implement your own code completer by observing modification events to
#' \code{input$<editorId>_shinyAce_annotationTrigger} where <editorId> is the
#' \code{aceEditor} id. This input is only used for triggering completion and
#' will contain a random number. However, you can access
#' \code{session$input[[inputId]]} to get the input text for parsing.
#'
#' @param inputId The id of the input object
#' @param session The \code{session} object passed to function given to
#'   shinyServer
#'
#' @return An observer reference class object that is responsible for offering
#'   code annotations. See \code{\link[shiny]{observeEvent}} for more details.
#'   You can use \code{suspend} or \code{destroy} to pause to stop dynamic code
#'   completion.
#'
#'   The observer reference object will send a custom shiny message using
#'   \code{session$sendCustomMessage} to the annotations endpoint containing
#'   a json list of annotation metadata objects. The json list should have
#'   a structure akin to:
#'
#'   \preformatted{
#'   [
#'     {
#'        row:  <int: row of annotation reference>,
#'        col:  <int: column of annotation reference>,
#'        type: <str: "error", "alert" or "flash">,
#'        html: <str: html of annotation hover div, used by default over text>,
#'        text: <num: text of annotation hover div>,
#'     }
#'   ]
#'   }
#'
#' @importFrom shiny observeEvent getDefaultReactiveDomain tags
#' @importFrom jsonlite toJSON
#'
#' @export
aceAnnotate <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  shiny::observeEvent(session$input[[paste0(inputId, "_shinyAce_annotationTrigger")]], {
    value <- session$input[[inputId]]

    annotations <- list()

    parse_out <- tryCatch({
      parse(text = value)
      NULL
    }, error = function(e) e)

    if (is.expression(parse_out)) {

    } else if ("error" %in% class(parse_out)) {
      annotation <- as.list(re_capture(
        parse_out$message,
        "(?s).*:(?<row>\\d+):(?<column>\\d+):(?<html>.*)",
        perl = TRUE
      ))

      num_cols <- c("row", "column")
      annotation[num_cols] <- as.numeric(annotation[num_cols])
      annotation$row <- annotation$row - 1
      annotation$type <- "error"
      annotation$html <- as.character(shiny::tags$pre(
        annotation$html,
        class = "shinyAce_annotation"
      ))

      return(session$sendCustomMessage("shinyAce", list(
        id = session$ns(inputId),
        annotations = jsonlite::toJSON(list(annotation), auto_unbox = TRUE)
      )))
    }

    return(session$sendCustomMessage("shinyAce", list(
      id = session$ns(inputId),
      annotations = jsonlite::toJSON(list(), auto_unbox = TRUE)
    )))
  })
}
