library(shiny)
library(shinyAce)

#' Define server logic required to generate simple ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyServer(function(input, output, session) {
  observe({
    print(input$ace)
  })
  
  observe({
    print(input$selection)
  })
  
  observe({
    updateAceEditor(session, "ace", theme=input$theme, mode=input$mode)
  })
  
  observe({
    if (input$reset == 0){
      return(NULL)
    }
    
    updateAceEditor(session, "ace", value="createData <- function(rows){
  data.frame(col1=1:rows, col2=rnorm(rows))
}")
  })
  
})