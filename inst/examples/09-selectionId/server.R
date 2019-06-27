library(shiny)

shinyServer(function(input, output, session) {
  output$log <- renderText({
    # note that the editor `outputId` is prepended to the name of
    # the input value for both cursor position and selection
    # i.e., use `ace_cusor` and `ace_selection` rather than
    # `cursor` and `selection`
    req(input$ace_cursor)
    paste0(
      "Cursor position: row ", input$ace_cursor$row,
      ", column ", input$ace_cursor$col,
      "\nSelection: \"", input$ace_selection, "\""
    )
  })
})
