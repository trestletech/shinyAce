library(shiny)
library(shinyAce)

modes <- dir(system.file('www/ace', package='shinyAce'), "^mode-.*.js$")
modes <- sub("^mode-(.*).js$", "\\1", modes)

themes <- dir(system.file('www/ace', package='shinyAce'), "^theme-.*.js$")
themes <- sub("^theme-(.*).js$", "\\1", themes)

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyUI(
  pageWithSidebar(
  # Application title
  headerPanel("Simple Shiny Ace!"),
  
  sidebarPanel(
    selectInput("mode", "Mode: ", choices=modes, selected="plain_text"),
    selectInput("theme", "Theme: ", choices=themes, selected="textmate"),
    HTML("<hr />"),
    helpText(HTML("A simple Shiny Ace editor.
                  <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>."))
  ),
  
  # Show the simple table
  mainPanel(
    aceEditor("ace")
  )
))