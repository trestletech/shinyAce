#' Update Ace Editor
#' 
#' Update the styling or mode of an aceEditor component.
#' @param session The Shiny session to whom the editor belongs
#' @param editorId The ID associated with this element
#' @param theme The Ace theme
#' @param mode The Ace mode
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
updateAceEditor <- function(session, editorId, value, theme, mode){
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
  
  session$sendCustomMessage("shinyAce", theList)
}