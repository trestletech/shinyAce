library(shiny)
library(shinyAce)

aceEditorInModuleUI <- function(inputId, ...) {
  ns <- NS(inputId)
  
  aceEditor_hotkeys <- list(list(
    win = "Ctrl-R|Ctrl-Shift-Enter",
    mac = "CMD-ENTER|CMD-SHIFT-ENTER"))
  names(aceEditor_hotkeys) <- ns("ace_editor_run")

  aceEditor_defaults <- list(
    autoScrollEditorIntoView = TRUE,
    minLines = 10,
    maxLines = 25,
    autoComplete = "live",
    autoCompleters = "rlang")

  aceEditor_fixed <- list(
    outputId = ns("editor"),
    mode = "r",
    hotkeys = aceEditor_hotkeys)

  aceEditor_args <- Reduce(modifyList, list(
    aceEditor_defaults,
    list(...),
    aceEditor_fixed))
  
  do.call(aceEditor, aceEditor_args)
}

shinyUI(function() {
  fluidPage(
    title = "Example of shinyAce in a shiny module",
    aceEditorInModuleUI("ace_editor"),
    verbatimTextOutput("ace_output")
  )
})