library(shiny)
library(shinyAce)

# use an environment to evaluate R code evaluated by knitr
ace_envir <- environment()

shinyServer(function(input, output, session) {

  # using a reactive value so we can use either the
  # action button or hotkeys (see ui.R)
  code <- reactiveVal("")

  observeEvent(input$code_run_key, {
    if (!is.empty(input$code_run_key$selection)) {
      # evaluate only the selected code
      code(input$code_run_key$selection)
    } else {
      # evalute the line where the cursor is located
      # using "code-jumping" to include lines as needed
      # see www/code/code-jump-r.js for details
      code(input$code_run_key$line)
    }
  })

  observeEvent(input$eval, {
    if (!is.empty(input$code_selection)) {
      # evaluate only the selected code
      code(input$code_selection)
    } else {
      # evalute all code in the editor
      code(input$code)
    }
  })

  output$output <- renderUI({
    input$eval
    input$code_run_key
    eval_code <- paste0("\n```{r echo = TRUE, comment = NA}\n", code(), "\n```\n")
    HTML(knitr::knit2html(text = eval_code, fragment.only = TRUE, quiet = TRUE, envir = ace_envir))
  })
})