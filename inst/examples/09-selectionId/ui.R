library(shiny)
library(shinyAce)

modes <- getAceModes()

themes <- getAceThemes()

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyUI(
  pageWithSidebar(
  # Application title
  headerPanel("ShinyAce with Hotkeys"),

  sidebarPanel(
    helpText(HTML("<p>AceEditor with `cursorId`, and `selectionId`: observe the events being reported as you either move the cursor in the box or make a text selection.</p>
                  <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>.")),
      tags$hr(),
      verbatimTextOutput("log")
    , width=6),

  mainPanel(
    aceEditor("ace", value="Here's some text in the editor.", cursorId = "cursor", selectionId = "selection")
  , width=6)
))
