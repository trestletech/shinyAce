library(shiny)

shinyServer(function(input, output, session) {
  output$knitDoc <- renderUI({
    input$eval
    HTML(knitr::knit2html(text = isolate(input$rmd), fragment.only = TRUE, quiet = TRUE))
  })
})