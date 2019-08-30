library(shiny)

shinyServer(function(input, output, session) {
  output$shinyUI <- renderUI({
    input$eval
    eval(parse(text = isolate(input$code)))
  })
})
