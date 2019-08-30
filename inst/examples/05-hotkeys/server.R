library(shiny)

renderLogEntry <- function(entry) {
  paste0(entry, " - ", date())
}

shinyServer(function(input, output, session) {
  vals <- reactiveValues(log = "")

  # note that the editor `outputId` is prepended to the name of
  # the input value (i.e., use `ace_run_key` rather than `run_key`)
  observeEvent(input$ace_run_key, {
    print(str(input$ace_run_key))
    vals$log <- paste(vals$log, renderLogEntry("Run Key"), sep = "\n")
    print(input$ace_run_key)
  })

  # note that the editor `outputId` is prepended to the name of
  # the input value (i.e., use `ace_help_key` rather than `help_key`)
  observeEvent(input$ace_help_key, {
    print(str(input$ace_help_key))
    vals$log <- paste(vals$log, renderLogEntry("Help Key"), sep = "\n")
    print(input$ace_help_key)
  })

  output$log <- renderText({
    vals$log
  })
})
