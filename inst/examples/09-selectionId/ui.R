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
      aceEditor("ace", value = "Some text ...", cursorId = "cursor", selectionId = "selection"),
      width = 6
    )
  )
)
