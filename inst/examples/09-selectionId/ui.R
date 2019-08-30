library(shinyAce)

shinyUI(
  pageWithSidebar(
    headerPanel("ShinyAce with cursor position and selection"),

    sidebarPanel(
      helpText(HTML("<p>AceEditor with `cursorId`, and `selectionId`: observe the events being reported as you either move the cursor in the editor or select text.</p>")),
      tags$hr(),
      verbatimTextOutput("log"),
      width = 6
    ),
    mainPanel(
      aceEditor(
        outputId = "ace",
        value = "Move the cursor inside the editor and\nselect one or more words ...",
        cursorId = "cursor", selectionId = "selection",
        height = "200px"
      ),
      width = 6
    )
  )
)
