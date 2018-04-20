library(shiny)
# library(shinyAce)
library(dplyr)

shinyServer(function(input, output, session) {
  
  ## Dataset Selection
  dataset <- reactive({
    get(input$dataset)
  })
  
  ## doesn't work as expected
  output$ace_editor <- renderUI({
    shinyAce::aceEditor(
      "editor",
      mode = "r",
      value = "select(wt, mpg)\n",
      height = "500px",
      autoComplete = "live"
    )
  })
 
  ## Update static auto complete list according to dataset
  observe({
    comps <- list()
    comps[[input$dataset]] <- colnames(dataset())
    comps <- c(comps, list(dplyr = getNamespaceExports("dplyr")))
    shinyAce::updateAceEditor(session,
      "editor",
      autoCompleters = "static",
      autoCompleteList = comps
    )
  })
})
