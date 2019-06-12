library(shiny)
library(shinyAce)

#' Define server logic required to generate simple ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyServer(function(input, output, session) {
  
  vals <- reactiveValues(log = "")
  
  observe({
    input$ace_runKey
    isolate(vals$log <- paste(vals$log, renderLogEntry("Run Key"), sep="\n"))
  })
  
  observe({
    input$ace_helpKey
    isolate(vals$log <- paste(vals$log, renderLogEntry("Help Key"), sep="\n"))
  })
  
  output$log <- renderText({
    vals$log
  })
})

renderLogEntry <- function(entry){
  paste0(date(), " - ", entry)
}

