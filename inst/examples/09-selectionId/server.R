library(shiny)
library(shinyAce)

#' Define server logic required to generate simple ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyServer(function(input, output, session) {

  vals <- reactiveValues(log = "")

  observe({
    valC <- input$ace_cursor
    if (!is.null(valC) && length(valC)) {
      isolate(vals$log <- paste(
        vals$log,
        renderLogEntry(
          paste0("Cursor moved to row: ", valC$row, " col: ", valC$col)
        ),
        sep="\n")
      )
    }
  })

  observe({
    valS <- input$ace_selection
    isolate({
      if (!is.null(valS) && valS != "") {
        vals$log <- paste(
          vals$log,
          renderLogEntry(paste0("Selection: ", valS)),
        sep="\n")
      }
    })
  })

  output$log <- renderText({
    vals$log
  })
})

renderLogEntry <- function(entry){
  paste0(date(), " - ", entry)
}

