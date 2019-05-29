library(shiny)
library(shinyAce)

aceEditorInModule <- function(input, output, session) {
  ns <- session$ns
  updateAceEditor(session, ns("editor"), autoCompleters = "rlang")
  ace_completer <- aceAutocomplete("editor")
  ace_annotater <- aceAnnotate("editor")
  ace_tooltip   <- aceTooltip("editor")
  input$editor
}

shinyServer(
  function(input, output, session) {
    observe({ callModule(aceEditorInModule, "ace_editor") })
  }
)