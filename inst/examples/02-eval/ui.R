library(shiny)
library(shinyAce)

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyUI(
  bootstrapPage(
    headerPanel("Shiny Ace Evaluate Code"),
    div(
    class="container-fluid",
    div(class="row-fluid",
        div(class="span6",
          h2("Source Code"),  
          aceEditor("code", mode="r", value="df <- data.frame(num=1:4, 
  let=LETTERS[2:5], 
  rand=rnorm(4))
df"),
            actionButton("eval", "Evaluate")
        ),
        div(class="span6",
          h2("Output"),
          verbatimTextOutput("output")
        )
  )
)))