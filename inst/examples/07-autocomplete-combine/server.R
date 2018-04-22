library(shiny)
library(shinyAce)
library(dplyr)

shinyServer(function(input, output, session) {
  
  ## Dataset Selection
  dataset <- reactive({
    get(input$dataset)
  })
  
  comps <- reactive({
    comps <- list()
    comps[[input$dataset]] <- colnames(dataset())
    comps <- c(comps, list(dplyr = getNamespaceExports("dplyr")))
  })
  
  output$ace_editor <- renderUI({
    shinyAce::aceEditor(
      "editor",
      mode = "r",
      value = "select(wt, mpg)\n",
      height = "500px",
      autoComplete = "live",
      autoCompleteList = comps()
    )
  })
  
  ## Update static auto complete list according to dataset
  observe({
    shinyAce::updateAceEditor(session,
      "editor",
      autoCompleters = "static",
      autoCompleteList = comps()
    )
  })
})
