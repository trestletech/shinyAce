#' Enable Completion Tooltips for an Ace Code Input
#'
#' This function uses the completion item object to retrieve tooltip information
#' by parsing R \code{\link{help}} documentation and rendering to html.
#'
#' @details
#' You can implement your own tooltips by observing modification events to
#' \code{input$<editorId>_shinyAce_tooltipItem} where <editorId> is the
#' \code{aceEditor} id. This input contains the object passed to codeCompletion
#' for this item. See the help for \code{\link{aceAutocomplete}} for details on
#' the fields of the completion item object.
#' 
#' @param inputId The id of the input object
#' @param session The \code{session} object passed to function given to
#'   shinyServer
#' 
#' @return An observer reference class object that is responsible for offering
#'   completion tooltips. See \code{\link[shiny]{observe}} for more details. You
#'   can use \code{suspend} or \code{destroy} to pause to stop dynamic code
#'   completion.
#'   
#'   The observer reference object will send a custom shiny message using
#'   \code{session$sendCustomMessage} to the docTooltip endpoint containing a
#'   json list of completion item metadata objects. The json list should have a
#'   structure akin to one of:
#'   
#'   A text object
#'   \preformatted{
#'   <str: text to display for tooltip>
#'   }
#'   
#'   An object containing a \code{docHTML} property
#'   \preformatted{
#'   {
#'      docHTML: <str: html to display for tooltip div, used if available>, 
#'   }
#'   }
#'   
#'   An object containing a \code{docText} property
#'   \preformatted{
#'   {
#'      docText: <str: text to display for tooltip div>
#'   }
#'   }
#' 
#' @importFrom shiny observe getDefaultReactiveDomain
#' @importFrom jsonlite toJSON
#' 
#' @export
aceTooltip <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  shiny::observe({
    value <- session$input[[paste0(inputId, "_shinyAce_tooltipItem")]]
    if (is.null(value)) return()

    name   <- value$name
    symbol <- if (is.null(value$symbol)) value$name else value$symbol
    envir  <- value$meta
     
    tooltip_caption <- if (grepl("\\s*=.*$", value$caption)) {
      paste0(
        "<b style=\"font-size:larger\">", name, "</b>", 
        tryCatch({
          if (!length(envir) || envir == "R") {
            get_arg_help(symbol, args = name)
          } else {
            get_arg_help(symbol, package = envir, args = name)
          }
        }, error = function(e) { print(e$message); ""}))
    } else {
      paste0(
        "<b>", symbol, "</b>", 
        tryCatch({
          if (!length(envir) || envir == "R") {
            get_desc_help(symbol)
          } else {
            get_desc_help(symbol, package = envir)
          }
        }, error = function(e) { print(e$message); ""}))
    } 
    
    return(session$sendCustomMessage('shinyAce', list(
      id = session$ns(inputId),
      docTooltip = jsonlite::toJSON(list(
        docHTML = paste0("<div>", tooltip_caption, "</div>")
      ), auto_unbox = TRUE))))
  })
}
