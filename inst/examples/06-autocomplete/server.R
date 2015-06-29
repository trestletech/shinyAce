library(shiny)
library(shinyAce)
library(dplyr)

shinyServer(function(input, output, session) {
  
  ### Dataset Selection ####
  dataset <- reactive({
    eval(parse(text = input$dataset))
  })
  
  output$table <- renderDataTable({
    dataset()
  })
  
  ### Auto Compeltion ####
  observe({
    autoComplete <- if(input$enableAutocomplete) {
      if(input$enableLiveCompletion) "live" else "enabled"
    } else {
      "disabled"
    }
    
    updateAceEditor(session, "mutate", autoComplete = autoComplete)
    updateAceEditor(session, "plot", autoComplete = autoComplete)
  })
  
  #Update static autocomplete list according to dataset
  observe({
    comps <- if(input$enableNameCompletion) structure(list(colnames(dataset())), names = input$dataset)
    updateAceEditor(session, "mutate", autoCompleteList = comps)
  })
  
  #Enable/Disable R code completion
  mutateOb <- aceAutocomplete("mutate")
  plotOb <- aceAutocomplete("plot")
  observe({
    if(input$enableRCompletion) {
      mutateOb$resume()
      plotOb$resume()
    } else {
      mutateOb$suspend()
      plotOb$suspend()
    }
  })
  
  output$plot <- renderPlot({ 
    input$eval
    
    tryCatch({
      #clear error
      output$error <- renderPrint(invisible())
      
      code1 <- gsub("\\s+$", "", isolate(input$mutate))
      code2 <- gsub("\\s+$", "", isolate(input$plot))
      
      eval(parse(text = isolate(paste(input$dataset, "%>%", code1, "%>% function(data) {", code2, "}"))))
    }, error = function(ex) {
      output$error <- renderPrint(ex)
      
      NULL
    })
  })
})
