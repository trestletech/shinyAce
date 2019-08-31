function(input, output, session) {
  shiny::callModule(editorSERVER,"termone")
  shiny::callModule(editorSERVER,"termtwo")
  shiny::callModule(editorSERVER,"termthree")
}
