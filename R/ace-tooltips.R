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
    if (is.null(value)) {
      return()
    }

    tooltip_fields <- tryCatch({
      build_tooltip_fields(value)
    }, error = function(e) {
      shinyAce_debug("Error building tooltip body: \n", e$message)
      NULL
    })

    return(session$sendCustomMessage("shinyAce", list(
      id = session$ns(inputId),
      docTooltip = jsonlite::toJSON(list(
        docHTML = do.call(tooltip_html, tooltip_fields)
      ), auto_unbox = TRUE)
    )))
  })
}



#' Build the fields used to make an html tooltip
#'
#' @param v Autocomplete metadata values used for building tooltip info
#' @return a list with html-formatted character values "title" and "body
#'
build_tooltip_fields <- function(v) {
  tooltip <- list(title = NULL, body = NULL)

  if ("parameter" %in% v$r_help_type) {
    arg <- gsub(" = $", "", v$value)
    tooltip$title <- arg
    tooltip$body <- if (!nchar(v$r_envir)) {
      get_arg_help(v$r_symbol, args = arg)
    } else {
      get_arg_help(v$r_symbol, package = v$r_envir, args = arg)
    }
  } else if ("package" %in% v$r_help_type) {
    pkg_desc <- utils::packageDescription(v$value, fields = c("Title", "Description"))
    pkg_help <- get_desc_help(paste0(v$value, "-package"))
    tooltip$title <- pkg_desc$Title
    tooltip$body <- if (is.null(pkg_help)) {
      paste0("<p>", pkg_desc$Description, "</p>")
    } else {
      pkg_help
    }
  } else {
    tooltip$title <- v$r_symbol
    tooltip$body <- get_desc_help(v$r_symbol, package = v$r_envir)
  }

  tooltip
}



#' A helper for formatting a tooltip entry
#'
#' @param title a character value to use as the title
#' @param body an html block to embed as the body of the tooltip
#'
tooltip_html <- function(title = "", body = "") {
  paste0(
    "<div><b style=\"font-size:larger\">",
    title,
    "</b>",
    body,
    "</div>"
  )
}
