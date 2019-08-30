library(shiny)
library(shinyAce)
library(dplyr)

shinyServer(function(input, output, session) {

  # dataset Selection
  dataset <- reactive({
    eval(parse(text = input$dataset))
  })

  output$table <- renderDataTable({
    dataset()
  })

  # auto completion
  observe({
    autoComplete <- if (input$enableAutocomplete) {
      if (input$enableLiveCompletion) "live" else "enabled"
    } else {
      "disabled"
    }

    updateAceEditor(session, "mutate", autoComplete = autoComplete)
    updateAceEditor(session, "plot", autoComplete = autoComplete)
  })

  # update static auto complete list according to dataset
  observe({
    req(input$enableNameCompletion)
    comps <- list()
    comps[[input$dataset]] <- colnames(dataset())
    updateAceEditor(session, "mutate", autoCompleteList = comps)
    updateAceEditor(session, "plot", autoCompleteList = list(one = "one"))
  })

  # enable/disable R code completion
  mutateOb <- aceAutocomplete("mutate")
  plotOb <- aceAutocomplete("plot")
  observe({
    if (input$enableRCompletion) {
      mutateOb$resume()
      plotOb$resume()
    } else {
      mutateOb$suspend()
      plotOb$suspend()
    }
  })

  # enable/disable completers
  observe({
    completers <- c()
    if (input$enableLocalCompletion) {
      completers <- c(completers, "text")
    }
    if (input$enableNameCompletion) {
      completers <- c(completers, "static")
    }
    if (input$enableRCompletion) {
      completers <- c(completers, "rlang")
    }
    updateAceEditor(session, "mutate", autoCompleters = completers)
    updateAceEditor(session, "plot", autoCompleters = completers)
  })

  output$plot <- renderPlot({ 
    input$eval
    tryCatch({
      # clear error
      output$error <- renderPrint(invisible())
      code1 <- gsub("\\s+$", "", isolate(input$mutate))
      code2 <- gsub("\\s+$", "", isolate(input$plot))
      eval(parse(text = isolate(paste(input$dataset, "%>%", code1, "%>% {", code2, "}"))))
    }, error = function(ex) {
      output$error <- renderPrint(ex)
      NULL
    })
  })
})
