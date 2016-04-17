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
#' @param wordWrap If set to \code{TRUE}, Ace will enable word wrapping.
#'   Default value is \code{FALSE}.
#' @param highlight \code{NULL} or an integer vector denoting a range >0. 
#' If set and NULL, will clear all highlighted markers.
#' If set and a single integer >0, will highlight the correspond row.
#' If set and a non-decreasing pair of integers >0, will highlight the corresponding range of rows 
#' determined by the pair.
#' @param border Set the \code{border} 'normal', 'alert', or 'flash'.
#' @param autoComplete Enable/Disable code completion. See \code{\link{aceEditor}} for details.
#' @param autoCompleteList If set to \code{NULL}, exisitng static completions list will be unset. See \code{\link{aceEditor}} for details.
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
                            fontSize, wordWrap, cursorPos,  highlight,
                            border=c("normal", "alert", "flash"),
                            autoComplete=c("disabled", "enabled", "live"), 
                            autoCompleteList=NULL
                            ){
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
  if (!missing(wordWrap)){
    theList["wordWrap"] <- wordWrap
  }
  if (!missing(border)){
    border <- match.arg(border)
    theList["border"] <- paste0("ace", border)
  }
  if (!missing(autoComplete)){
    autoComplete <- match.arg(autoComplete)
    theList["autoComplete"] <- autoComplete
  }
  if (!missing(autoCompleteList)){
    #NULL can only be inserted via c()
    theList <- c(theList, list(autoCompleteList = autoCompleteList))
  }
  if (!missing(cursorPos)){
    if(length(cursorPos)==2 && is.numeric(cursorPos)){
      cursorPos<-cursorPos-1
      cursorPos<-paste0(cursorPos,collapse=",")
      theList <- c(theList, list(cursorPos = cursorPos)) 
    } 
  } 
  if(!missing(highlight)){
    if(length( highlight)==0){
      theList <- c(theList, list(highlight = highlight)) 
    } else if( is.numeric(highlight)){
      stopifnot(highlight[1]>0)
      if(length(highlight)==1){
        highlight<-c(highlight,highlight)
      }
      highlight<-highlight-1
      stopifnot(highlight[2]>=highlight[1] )
      highlight<-paste0(highlight[1:2],collapse=",")
      theList <- c(theList, list(highlight = highlight)) 
    } 
  }
  
  

  session$sendCustomMessage("shinyAce", theList)
}