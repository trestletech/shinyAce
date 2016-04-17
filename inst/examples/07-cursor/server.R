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
    if (input$highlight == 0){
      return(NULL)
    }
    isolate({
      lineNo<-as.integer(input$chosenline)
      updateAceEditor(session, "ace",highlight=c(lineNo) )
    })
 }) 
  
  observe({
    if (input$setCursorPos == 0){
      return(NULL)
    }
    isolate({
      lineNo<-as.integer(input$chosenline)
      updateAceEditor(session, "ace",cursorPos=c(lineNo,1) )
    })
  }) 
  
  observe({
    if (input$unhighlight == 0){
      return(NULL)
    }
    updateAceEditor(session, "ace", highlight=NULL )
    # updateAceEditor(session, "ace", 
    #                 clearHighlights=1 )
    })
  
  
}) 