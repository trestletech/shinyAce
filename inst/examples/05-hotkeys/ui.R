library(shinyAce)

shinyUI(
  pageWithSidebar(
    headerPanel("ShinyAce with Hotkeys"),

    sidebarPanel(
      helpText(HTML("<p>AceEditor with hotkeys. The two defined hotkeys in this demo are <code>F1</code> which is bound to the <code>ace_help_key</code> input, and <code>CMD(CTRL)+SHIFT+Enter</code> which is bound to the <code>ace_run_key</code> input. Select the text editor and try out either of the hotkeys.</p>
                     <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>.")),
      tags$hr(),
      verbatimTextOutput("log")
    ),
    mainPanel(
      aceEditor(
        outputId = "ace",
        value = "Some text ...",
        hotkeys = list(
          help_key = "F1",
          run_key = list(
            win = "Ctrl-R|Ctrl-Shift-Enter",
            mac = "CMD-ENTER|CMD-SHIFT-ENTER"
          )
        )
      )
    )
  )
)
