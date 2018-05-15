library(shiny)

shinyUI(fluidPage(
  titlePanel("shinyAce auto completion - combine completion lists"),
  radioButtons("dataset", "Dataset: ", c("mtcars", "airquality"), inline = TRUE),
  uiOutput("ace_editor")
))
