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
    v <- session$input[[paste0(inputId, "_shinyAce_tooltipItem")]]
    if (is.null(v)) return()
    
    tooltip <- tryCatch({ 
      if (v$r_help_type == "parameter") {
        arg <- gsub(" = $", "", v$value)
        tooltip_html(arg, 
          if (!nchar(v$r_envir)) get_arg_help(v$r_symbol, args = arg)
          else get_arg_help(v$r_symbol, package = v$r_envir, args = arg))
        
      } else if (v$r_help_type == "package") {
        pkg_desc <- utils::packageDescription(v$value, fields = c("Title", "Description"))
        pkg_help <- get_desc_help(paste0(v$value, "-package"))
        tooltip_html(pkg_desc$Title, 
          if (is.null(pkg_help)) paste0("<p>", pkg_desc$Description, "</p>")
          else pkg_help)
        
      } else {
        tooltip_html(v$r_symbol, get_desc_help(v$r_symbol, package = v$r_envir))
        
      }
    }, error = function(e) { print(e$message); "" })
    
    return(session$sendCustomMessage('shinyAce', list(
      id = session$ns(inputId),
      docTooltip = jsonlite::toJSON(list(docHTML = tooltip), auto_unbox = TRUE))))
  })
}


tooltip_html <- function(title, description) {
  paste0(
    "<div><b style=\"font-size:larger\">",
    title,
    "</b>",
    description,
    "</div>")
}
