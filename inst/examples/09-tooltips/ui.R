library(shiny)
library(shinyAce)

shinyUI(fluidPage(
  titlePanel("shinyAce auto completion demo"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("enableAutocomplete", "Enable AutoComplete", TRUE),
      conditionalPanel(
        "input.enableAutocomplete", 
        wellPanel(
          checkboxInput("enableLiveCompletion", "Live auto completion", TRUE),
          checkboxInput("enableNameCompletion", list("Dataset column names completion in", tags$i("mutate")), FALSE),
          checkboxInput("enableRCompletion", "R code completion", TRUE),
          checkboxInput("enableLocalCompletion", "Local text completion", FALSE)
        )
      ),
      textOutput("error")
    ),
    mainPanel(
      aceEditor("ace_editor", mode = "r", value = "")
    )
  )
))
