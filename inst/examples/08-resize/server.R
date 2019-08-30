library(shiny)
library(shinyAce)

shinyServer(function(input, output, session) {
  observeEvent(input$clear, {
    updateAceEditor(session, "ace", value = "\r")
  })
})
