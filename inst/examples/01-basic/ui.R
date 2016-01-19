library(shiny)
library(shinyAce)

modes <- getAceModes()

themes <- getAceThemes()

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyUI(
  pageWithSidebar(
  # Application title
  headerPanel("Simple Shiny Ace!"),
  
  sidebarPanel(
    selectInput("mode", "Mode: ", choices=modes, selected="plain_text"),
    selectInput("theme", "Theme: ", choices=themes, selected="textmate"),
    actionButton("reset", "Reset Text"),
    HTML("<hr />"),
    helpText(HTML("A simple Shiny Ace editor.
                  <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>."))
  ),
  
  # Show the simple table
  mainPanel(
    aceEditor("ace", value="createData <- function(rows){
  data.frame(col1=1:rows, col2=rnorm(rows))
}")
  )
))