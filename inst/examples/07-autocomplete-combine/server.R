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
    ## initially, only show completions in 'comps' (i.e., dplyr and selected dataset)
    shinyAce::aceEditor(
      "editor",
      mode = "r",
      value = "select(wt, mpg)\n",
      height = "200px",
      autoComplete = "live",
      autoCompleters = "static",
      autoCompleteList = isolate(comps())
    )
  })
  
  ## Update static auto complete list according to dataset and add local completions
  observe({
    shinyAce::updateAceEditor(session,
      "editor",
      autoCompleters = c("static", "text", "rlang"),
      autoCompleteList = comps()
    )
  })
  
  ## adding an observer for R-language code completion
  ## will become active after the first switch to another
  ## dataset
  rlang <- aceAutocomplete("editor")
})
