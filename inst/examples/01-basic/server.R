library(shiny)
library(shinyAce)

#' Define server logic required to generate simple ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyServer(function(input, output, session) {
  observe({
    print(input$ace)
  })
  
  observe({
    updateAceEditor(session, "ace", theme=input$theme, mode=input$mode)
  })
  
})