library(shiny)
library(shinyAce)
library(dplyr)

shinyServer(function(input, output, session) {
  
  # Dataset Selection
  dataset <- reactive({
    get(input$dataset)
  })
  
  # Update static auto complete list according to dataset
  observe({
    comps <- list()
    comps[[input$dataset]] <- colnames(dataset())
    updateAceEditor(session, 
      "editor", 
      autoCompleters = c("snippet", "text", "keyword", "static", "rlang"),
      autoCompleteList = comps
    )
  })
})
