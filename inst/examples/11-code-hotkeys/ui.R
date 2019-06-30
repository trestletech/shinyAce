library(shinyAce)

init <- "# use SHIFT-ENTER to step through your code
df <- data.frame(
  num=1:4,
  let=LETTERS[2:5],
  rand=rnorm(4)
)
df
"

shinyUI(
  fluidPage(
    h1("Shiny Ace Evaluate Code"),
    fluidRow(
      column(
        6,
        h2("Source Code"),
        aceEditor(
          "code",
          mode = "r",
          selectionId = "selection",
          code_hotkeys = list(
            "r",
            list(
              run_key = list(
                win = "CTRL-ENTER|SHIFT-ENTER",
                mac = "CMD-ENTER|SHIFT-ENTER"
              )
            )
          ),
          value = init
        ),
        actionButton("eval", "Evaluate")
      ),
      column(
        6,
        h2("Output"),
        htmlOutput("output")
      )
    )
  )
)
