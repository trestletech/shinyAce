#' Render Ace
#' 
#' Render an Ace editor on an application page.
#' @param outputId The ID associated with this element
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
aceEditor <- function(outputId, value, mode, theme, height="400px"){
  js <- paste("var editor = ace.edit('",outputId,"');",sep="")
  if (!missing(theme)){
    js <- paste(js, "editor.setTheme('ace/theme/",theme,"');",sep="")
  }
  if (!missing(mode)){
    js <- paste(js, "editor.getSession().setMode('ace/mode/",mode,"');", sep="")
  }
  if (!missing(value)){
    js <- paste(js, "editor.setValue(", jsQuote(value), ", -1);", sep="")
  }  
  js <- paste(js, "$('#", outputId, "').data('aceEditor',editor);", sep="")
  
  tagList(
    singleton(tags$head(
      initResourcePaths(),
      tags$script(src = 'shinyAce/shinyAce.js'),
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

