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
    helpText(HTML("<p>AceEditor with hotkeys. The two defined hotkeys in this demo are <code>F1</code> which is bound to the <code>helpKey</code> input, and <code>CMD(/CTRL)+SHIFT+Enter</code> which is bound to the <code>runKey</code> input. Select the text editor and try out either of the hotkeys.</p>
                  <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>.")),
      tags$hr(),
      verbatimTextOutput("log")
    , width=6),
  
  mainPanel(
    aceEditor("ace", value="Here's some text in the editor.", cursorId = "cursor", hotkeys=list(helpKey="F1",
                                      runKey=list(win="Ctrl-R|Ctrl-Shift-Enter",
                                                  mac="CMD-ENTER|CMD-SHIFT-ENTER")
))
  , width=6)
))