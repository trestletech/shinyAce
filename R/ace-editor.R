#' Render Ace
#' 
#' Render an Ace editor on an application page.
#' @param outputId The ID associated with this element
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
#' @param height A number (which will be interpreted as a number of pixels) or 
#'   any valid CSS dimension (such as "\code{50\%}", "\code{200px}", or 
#'   "\code{auto}").
#' @param fontSize Defines the font size (in px) used in the editor and should 
#'   be an integer. The default is 12.
#' @param debounce The number of milliseconds to debounce the input. This will
#'   cause the client to withhold update notifications until the user has
#'   stopped typing for this amount of time. If 0, the server will be notified
#'   of every keystroke as it happens.
#' @param wordWrap If set to \code{TRUE}, Ace will enable word wrapping.
#'   Default value is \code{FALSE}.
#' @import shiny
#' @examples \dontrun{
#'  aceEditor("myEditor", "Initial text for editor here", mode="r", 
#'    theme="ambiance")
#' } 
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
aceEditor <- function(outputId, value, mode, theme, vimKeyBinding = FALSE, 
                      readOnly=FALSE, height="400px",
                      fontSize=12, debounce=1000, wordWrap=FALSE, selectionId=NULL){
  js <- paste("var editor = ace.edit('",outputId,"');",sep="")
  if (!missing(theme)){
    js <- paste(js, "editor.setTheme('ace/theme/",theme,"');",sep="")
  }
  if (vimKeyBinding){
    js <- paste(js, "editor.setKeyboardHandler('ace/keyboard/vim');",sep="")
  }
  if (!missing(mode)){
    js <- paste(js, "editor.getSession().setMode('ace/mode/",mode,"');", sep="")
  }
  if (!missing(value)){
    js <- paste(js, "editor.setValue(", jsQuote(value), ", -1);", sep="")
  }  
  if (readOnly){
    js <- paste(js, "editor.setReadOnly(", jsQuote(readOnly), ");", sep="")
  }
  if (!is.null(fontSize) && !is.na(as.numeric(fontSize))){
    js <- paste(js, "document.getElementById('",outputId,"').style.fontSize='",
                as.numeric(fontSize), "px'; ", sep="")
  }

  if (!is.null(debounce) && !is.na(as.numeric(debounce))){
    # I certainly hope there's a more reasonable way to compare versions with an
    # extra field in them...
    re <- regexpr("^\\d+\\.\\d+\\.\\d+", packageVersion("shiny"))
    shinyVer <- substr(packageVersion("shiny"), 0, attr(re, "match.length"))
    
    minorVer <- as.integer(substr(packageVersion("shiny"), 
                                  attr(re, "match.length")+2,
                                  nchar(packageVersion("shiny"))))
    comp <- compareVersion(shinyVer, "0.9.1")
    if (comp < 0 || (comp == 0 && minorVer < 9004)){
      warning(
       "Shiny version 0.9.1.9004 required to use input debouncing in shinyAce.")
    }
    js <- paste(js, "$('#",outputId,"').data('debounce',",debounce,");", sep="")
  }
  
  if (wordWrap){
    js <- paste(js, "editor.getSession().setUseWrapMode(true);", sep="")
  }
  
  js <- paste(js, "$('#", outputId, "').data('aceEditor',editor);", sep="")
  if (!is.null(selectionId)){
    selectJS <- paste("editor.getSelection().on(\"changeSelection\", function(){
      Shiny.onInputChange(\"",selectionId,
      "\",editor.getCopyText());})", 
      sep="")
    js <- paste(js, selectJS, sep="")
  }
  
  tagList(
    singleton(tags$head(
      initResourcePaths(),
      tags$script(src = 'shinyAce/shinyAce.js'),
      tags$link(rel = 'stylesheet',
                type = 'text/css',
                href = 'shinyAce/shinyAce.css'),
      tags$script(src = 'shinyAce/ace/ace.js')
    )),
    pre(id=outputId, class="shiny-ace", 
        style=paste("height:", 
              validateCssUnit(height)
        )
    ),
    tags$script(type="text/javascript", HTML(js))
  )
}

