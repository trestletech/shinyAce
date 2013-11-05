#' Update Ace Editor
#' 
#' Update the styling or mode of an aceEditor component.
#' @param session The Shiny session to whom the editor belongs
#' @param editorId The ID associated with this element
#' @param value The initial text to be contained in the editor.
#' @param mode The Ace \code{mode} to be used by the editor. The \code{mode}
#'   in Ace is often the programming or markup language that you're using and 
#'   determines things like syntax highlighting and code folding. Use the
#'   \code{\link{getAceModes}} function to enumerate all the modes available.
#' @param theme The Ace \code{theme} to be used by the editor. The \code{theme}
#'   in Ace determines the styling and coloring of the editor. Use 
#'   \code{\link{getAceThemes}} to enumerate all the themes available.
#' @param readOnly If set to \code{TRUE}, Ace will disable client-side editing.
#'   If \code{FALSE} (the default), it will enable editing.
#' @param fontSize If set, will update the font size (in px) used in the editor.
#'   Should be an integer.
#' @examples \dontrun{
#'  shinyServer(function(input, output, session) {
#'    observe({
#'      updateAceEditor(session, "myEditor", "Updated text for editor here", 
#'        mode="r", theme="ambiance")
#'    })
#'  }
#' } 
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
updateAceEditor <- function(session, editorId, value, theme, readOnly, mode,
                            fontSize){
  if (missing(session) || missing(editorId)){
    stop("Must provide both a session and an editorId to update Ace.")
  }
  
  theList <- list(id=editorId)
  
  if (!missing(value)){
    theList["value"] <- value
  }
  if (!missing(theme)){
    theList["theme"] <- theme
  }
  if (!missing(mode)){
    theList["mode"] <- mode
  }
  if (!missing(readOnly)){
    theList["readOnly"] <- readOnly
  }
  if (!missing(fontSize)){
    theList["fontSize"] <- fontSize
  }
  
  session$sendCustomMessage("shinyAce", theList)
}