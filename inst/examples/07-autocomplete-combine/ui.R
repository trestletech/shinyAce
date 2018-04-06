library(shiny)
library(shinyAce)
library(dplyr)

shinyUI(fluidPage(
  titlePanel("shinyAce auto completion - combine completion lists"),
  radioButtons("dataset", "Dataset: ", c("mtcars", "airquality"), inline = TRUE),
  aceEditor(
    "editor", 
    mode = "r", 
    value = "select(wt, mpg)\n", 
    height = "500px",
    autoComplete = "live",
    autoCompleteList = list(dplyr = getNamespaceExports("dplyr"))
  )
))
