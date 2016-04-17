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
    updateAceEditor(session, "ace",
                    unHighLightRange=1 )

    lineNo<-as.integer(input$line2highlight)
    updateAceEditor(session, "ace",
                    highLightRange=c(lineNo,lineNo) )
    # updateAceEditor(session, "ace", 
    #                 cursorPos=c(5,1) )
  }) 
  
  observe({
    if (input$unhighlight == 0){
      return(NULL)
    }
    updateAceEditor(session, "ace",
                    unHighLightRange=1 )
    })
}) 