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
      selectInput("line2highlight", "pick line: ", choices=as.list(1:20), selected=1),
      actionButton("highlight", "Highlight Line"),
      actionButton("unhighlight", "Remove All Highlights"),
      actionButton("setCursorPos", "Set cursor to Line"),
      
      HTML("<hr />"),
      helpText(HTML("A simple Shiny Ace editor.
                  <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>."))
    ),
    
    # Show the simple table
    # Show the simple table
  mainPanel(
    aceEditor("ace", value= as.list(paste("# line",1:20, collapse="\n")))
  )
# "createData <- function(rows){
#   data.frame(col1=1:rows, col2=rnorm(rows))
#     }
# # line 4
# # line 5
# # line 6
# # line 7
# # line 8
# # line 9
# # line 10
# # line 11
# # line 12
# # line 13
#     ")
#  )
))