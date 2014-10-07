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
#' @param cursorId The ID associated with a cursor change.
#' @param selectionId  The ID associated with a change of selected text
#' @param keyId A list whose names are ID names and whose elements are the shortcuts of keys. Shortcuts can either be a simple string or a list with elements 'win' and 'mac' that that specifies different shortcuts for win and mac (see example). 
#' @import shiny
#' @examples \dontrun{
#'  aceEditor("myEditor", "Initial text for editor here", mode="r", 
#'    theme="ambiance")
#'    
#'  aceEditor("myCodeEditor", "# Enter code", mode="r",
#'    keyId = list(helpKey="F1",
#'                 runKey=list(win="Ctrl-R|Ctrl-Shift-Enter",
#'                             mac="CMD-ENTER|CMD-SHIFT-ENTER")
#'                 ),
#'    wordWrap=TRUE, debounce=10) 
#' } 
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
aceEditor <- function(outputId, value, mode, theme, vimKeyBinding = FALSE, 
                      readOnly=FALSE, height="400px",
                      fontSize=12, debounce=1000, wordWrap=FALSE,showLineNumbers = TRUE,highlightActiveLine=TRUE, selectionId=NULL, cursorId=NULL, keyId=NULL){
  editorVar = paste0("editor__",outputId)
  #restore.point("aceEditor")
  #editorVar = "editor"
  #editorIdVar = paste0("$('#", outputId, "')")
  js <- paste("var ", editorVar," = ace.edit('",outputId,"');",sep="")
  if (!missing(theme)){
    js <- paste(js, "", editorVar,".setTheme('ace/theme/",theme,"');",sep="")
  }
  if (vimKeyBinding){
    js <- paste(js, "", editorVar,".setKeyboardHandler('ace/keyboard/vim');",sep="")
  }
  if (!missing(mode)){
    js <- paste(js, "", editorVar,".getSession().setMode('ace/mode/",mode,"');", sep="")
  }
  if (!missing(value)){
    js <- paste(js, "", editorVar,".setValue(", jsQuote(value), ", -1);", sep="")
  }  
  if (!showLineNumbers) {
    js <- paste(js, "", editorVar,".renderer.setShowGutter(false);", sep="")
  }
  if (!highlightActiveLine) {
    js <- paste(js, "", editorVar,".setHighlightActiveLine(false);", sep="")
  }
  
  if (readOnly){
    js <- paste(js, "", editorVar,".setReadOnly(", jsQuote(readOnly), ");", sep="")
  }
  if (!is.null(fontSize) && !is.na(as.numeric(fontSize))){
    js <- paste(js, "document.getElementById('",outputId,"').style.fontSize='",
                as.numeric(fontSize), "px'; ", sep="")
  }

  if (!is.null(debounce) && !is.na(as.numeric(debounce))){
    js <- paste(js, "$('#",outputId,"').data('debounce',",debounce,");", sep="")
  }
  
  if (wordWrap){
    js <- paste(js, "", editorVar,".getSession().setUseWrapMode(true);", sep="")
  }
  js <- paste(js, "$('#", outputId, "').data('aceEditor',", editorVar,");", sep="")

  if (!is.null(selectionId)){
    selectJS <- paste("", editorVar,".getSelection().on(\"changeSelection\", function(){
      Shiny.onInputChange(\"",selectionId,
      "\",", editorVar,".getCopyText());})", 
      sep="")
    js <- paste(js, selectJS, sep="")
  }
  
  if (!is.null(cursorId)){    
    curJS <- paste("\n", editorVar,".getSelection().on(\"changeCursor\", function(){
      Shiny.onInputChange(\"",cursorId,
      "\",", editorVar,".selection.getCursor() );}\n);", 
    sep="")
    js <- paste(js, curJS, sep="")
  }
  
  for (i in seq_along(keyId)) {
    shortcut = keyId[[i]]
    if (is.list(shortcut)) {
      shortcut = paste0(names(shortcut),": '", shortcut,"'", collapse=", ")
    } else {
      shortcut = paste0("win: '",shortcut,"',  mac: '",shortcut,"'")
    }
    
    id = names(keyId)[i]
    code = paste0("
    ",editorVar,".commands.addCommand({
        name: '",id,"',
        bindKey: {", shortcut,"},
        exec: function(",editorVar,") {
          Shiny.onInputChange(\"",id,
          "\",{
            editorId : '",outputId,"',
            selection: ", editorVar,".session.getTextRange(",editorVar,".getSelectionRange()), 
            cursor : ", editorVar,".selection.getCursor(),
            randNum : Math.random()
          });            
        },
        readOnly: true // false if this command should not apply in readOnly mode
    });    
    ")
    js = paste0(js, code)
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
