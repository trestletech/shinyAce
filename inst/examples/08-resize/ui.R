library(shinyAce)

init <- "createData <- function(rows) {
  data.frame(col1 = 1:rows, col2 = rnorm(rows))
}

# add or remove lines to change the size of the editor


"

# define UI for application that demonstrates a resizable Ace editor
shinyUI(
  fluidPage(
    h1("Resizable Shiny Ace"),
    aceEditor(
      outputId = "ace",
      mode = "r",
      autoScrollEditorIntoView = TRUE,
      minLines = 2,
      maxLines = 30,
      value = init
    ),
    actionButton("clear", "Clear text")
  )
)