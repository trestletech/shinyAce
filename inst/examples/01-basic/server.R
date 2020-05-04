# define server logic required to generate simple ace editor
shinyServer(function(input, output, session) {
  observe({
    # print all editor content to the R console
    cat(input$ace, "\n")
  })

  observe({
    # print only selected editor content to the R console
    # to access content of `selectionId` use `ace_selection`
    # i.e., the outputId is prepended to the selectionId for
    # use with Shiny modules
    cat(input$ace_selection, "\n")
  })

  observe({
    updateAceEditor(
      session,
      "ace",
      theme = input$theme,
      mode = input$mode,
      tabSize = input$size,
      useSoftTabs = as.logical(input$soft),
      showInvisibles = as.logical(input$invisible),
      showLineNumbers = as.logical(input$linenr)
    )
  })

  observeEvent(input$reset, {
    updateAceEditor(session, "ace", value = init)
  })

  observeEvent(input$clear, {
    updateAceEditor(session, "ace", value = "")
  })
})