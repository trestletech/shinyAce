library(shiny)

shinyServer(function(input, output, session) {
  output$output <- renderPrint({
    input$eval
    eval(parse(text = isolate(input$code)))
  })
})