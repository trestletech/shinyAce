#' Render Ace
#' 
#' Render an Ace editor on an application page.
#' @param outputId The ID associated with this element
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
aceEditor <- function(outputId, mode="plain_text", theme="textmate", height="400px"){
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
    tags$script(type="text/javascript", 
                paste("var editor = ace.edit('",outputId,"');",
                      "editor.setTheme('ace/theme/",theme,"');",
                      "editor.getSession().setMode('ace/mode/",mode,"');",
                      "$('#", outputId, "').data('aceEditor',editor);",
                      sep=""))
  )
}

