editorUI <- function(id) {
  ns <- NS(id)

  fluidRow(
    shiny::column(width = 4,
      shinyAce::aceEditor(
        ns("code"),
        mode = "r",
        height = "200px",
        autoComplete = "live",
        autoCompleters = "rlang",
        hotkeys = list(
          runKey=list(
            win = "Ctrl-Enter",
            mac = "CMD-ENTER"
          )
        )
      )
    ), # column
    shiny::column(width = 8,
      tags$div(
        style = "overflow-y:scroll; max-height: 300px;",
        verbatimTextOutput(ns("codeOutput"))
      )
    ) # column
  ) # row

}

editorSERVER <- function(
  input,
  output,
  session
) {

  ns <- session$ns
  shinyAce::aceAutocomplete("code")
  tmpFile <- tempfile()

  output$codeOutput <- renderPrint({
    val <- input$code_runKey
    if(is.null(val)) {
      return(
        "Execute [R] chunks with Ctrl/Cmd-Enter"
      )
    }

    selectionLocal <- val$selection
    lineLocal <- val$line
    if(val$selection != "") {
      toExecute <- selectionLocal
    } else {
      shiny::validate(
        need(!is.null(lineLocal), "Unable to find execution text")
      )
      toExecute <- lineLocal
    }
    writeLines(toExecute, con = tmpFile)
    return(source(tmpFile, echo = TRUE, local = TRUE))

  })

}
