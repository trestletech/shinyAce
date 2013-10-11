#' Update Ace Editor
#' 
#' Update the styling or mode of an aceEditor component.
#' @param session The Shiny session to whom the editor belongs
#' @param editorId The ID associated with this element
#' @param theme The Ace theme
#' @param mode The Ace mode
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
updateAceEditor <- function(session, editorId, theme, mode){
  session$sendCustomMessage("shinyAce", list(id=editorId, theme=theme, mode=mode))
}