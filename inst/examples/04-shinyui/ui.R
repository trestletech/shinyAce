library(shiny)
library(shinyAce)

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyUI(
  bootstrapPage(div(
    class="container-fluid",
    div(class="row-fluid",
        div(class="span6",
            h2("UI Code"),  
            aceEditor("code", mode="r", value='# Wrap UI code in a `tagList` 
# then enumerate comma-separated elements
tagList(
  # Create a header
  h3("Dynamic UI!"),
  
  # Some arbitrary form elements.
  selectInput("dynamicSelect", "Select", 
    paste("Choice", 1:9)),
  actionButton("dynamicButton", "A Button!")
)
'),
            actionButton("eval", "Update UI")
        ),
        div(class="span6",
            h2("Generated UI"),
            div(class="well", htmlOutput("shinyUI"))
        )
    )
  )))