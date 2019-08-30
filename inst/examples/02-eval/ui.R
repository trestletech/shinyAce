library(shinyAce)

init <- "df <- data.frame(
  num=1:4,
  let=LETTERS[2:5],
  rand=rnorm(4)
)
df"

shinyUI(
  fluidPage(
    h1("Shiny Ace Evaluate Code"),
    fluidRow(
      column(
        6,
        h2("Source Code"),
        aceEditor("code", mode = "r", height = "200px", value = init),
        actionButton("eval", "Evaluate")
      ),
      column(
        6,
        h2("Output"),
        verbatimTextOutput("output")
      )
    )
  )
)
