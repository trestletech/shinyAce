library(shiny)
library(shinyAce)

shinyServer(function(input, output, session) {
  # Auto completion
  observe({
    autoComplete <- "disabled"
    if (input$enableAutocomplete) {
      if (input$enableLiveCompletion) { 
        autoComplete <- "live"
      } else {
        autoComplete <- "enabled"
      }
    }
    
    updateAceEditor(session, "ace_editor", autoComplete = autoComplete)
  })
  
  # Enable/Disable R code completion / annotation
  ace_completer <- aceAutocomplete("ace_editor")
  ace_annotater <- aceAnnotate("ace_editor")
  ace_tooltip   <- aceTooltip("ace_editor")
  
  observe({
    if (input$enableRCompletion) ace_completer$resume()
    else ace_completer$suspend()
  })
  
  # Enable/disable completers
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
    updateAceEditor(session, "ace_editor", autoCompleters = completers)
  })
})