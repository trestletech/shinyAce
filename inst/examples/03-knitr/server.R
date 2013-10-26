library(shiny)
library(shinyAce)
library(knitr)

#' Define server logic required to generate simple ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyServer(function(input, output, session) {
  output$knitDoc <- renderUI({
    input$eval
    return(isolate(HTML(knit2html(text = input$rmd, fragment.only = TRUE, quiet = TRUE))))
  })  
})