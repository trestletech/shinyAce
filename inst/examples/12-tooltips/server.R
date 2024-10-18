library(shiny)
library(shinyAce)

shinyServer(function(input, output, session) {
  # Enable/Disable R code completion / annotation
  ace_completer <- aceAutocomplete("ace_editor")
  ace_annotator <- aceAnnotate("ace_editor")
  ace_tooltip   <- aceTooltip("ace_editor")
# Enabling and Disabling Autocompletion Observer
  observe({
    if (input$enableAutocomplete) ace_completer$resume()
    else ace_completer$suspend()
  })
# Enabling and Disabling Tooltips Observer
  observe({
    if (input$enableTooltips) ace_tooltip$resume()
    else ace_tooltip$suspend()
  })
# Enabling and Disabling Annotations Observer
  observe({
    if (input$enableAnnotations) ace_annotator$resume()
    else ace_annotator$suspend()
  })
})