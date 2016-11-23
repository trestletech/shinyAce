library(shiny)
library(shinyAce)

modes <- getAceModes()

themes <- getAceThemes()

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyUI(
  
  pageWithSidebar(
     
    # Application title
    headerPanel("Cursor Positioning and Line Highlighting"),
    
    sidebarPanel(
      selectInput("mode", "Mode: ", choices=modes, selected="plain_text"),
      selectInput("theme", "Theme: ", choices=themes, selected="textmate"),
      selectInput("chosenline", "pick line number: ", choices=as.list(1:20), selected=1),
      actionButton("highlight", "Highlight Line"),
      actionButton("unhighlight", "Remove All Highlights"),
      actionButton("setCursorPos", "Set cursor to Line"),
      
      HTML("<hr />"),
      helpText(HTML("A simple Shiny Ace editor.
                  <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>."))
    ),
  mainPanel(
    aceEditor("ace", value= as.list(paste("# line",1:20, collapse="\n")) )
  )

))