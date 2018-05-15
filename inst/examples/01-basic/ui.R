library(shiny)
library(shinyAce)

modes <- getAceModes()
themes <- getAceThemes()

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyUI(
  pageWithSidebar(
  headerPanel("Simple Shiny Ace!"),
  sidebarPanel(
    selectInput("mode", "Mode: ", choices = modes, selected = "plain_text"),
    selectInput("theme", "Theme: ", choices = themes, selected = "textmate"),
    numericInput("size", "Tab size:", 4),
    radioButtons("soft", NULL, c("Soft tabs" = TRUE, "Hard tabs" = FALSE), inline = TRUE),
    radioButtons("invisible", NULL, c("Hide invisibles" = FALSE, "Show invisibles" = TRUE), inline = TRUE),
    actionButton("reset", "Reset text"),
    actionButton("clear", "Clear text"),
    HTML("<hr />"),
    helpText(HTML("A simple Shiny Ace editor.
                  <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>."))
  ),
  mainPanel(
    aceEditor(
      "ace", 
      value = "createData <- function(rows) {
  data.frame(col1 = 1:rows, col2 = rnorm(rows))
}")
  )
))