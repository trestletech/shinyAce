library(shinyAce)

init <- '# wrap UI code in a `tagList`
# then enumerate comma-separated elements
tagList(
  # create a header
  h3("Dynamic UI!"),

  # some arbitrary form elements
  selectInput("dynamicSelect", "Select", paste("Choice", 1:9)),
  actionButton("dynamicButton", "A Button!")
)'

shinyUI(
  fluidPage(
    h1("Shiny Ace Reactive UI Demo"),
    fluidRow(
      column(
        8,
        h2("UI Code"),
        aceEditor("code", mode = "r", value = init),
        actionButton("eval", "Update UI")
      ),
      column(
        4,
        h2("Generated UI"),
        wellPanel(
          htmlOutput("shinyUI")
        )
      )
    )
  )
)
