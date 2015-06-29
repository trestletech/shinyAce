library(shiny)
library(shinyAce)

shinyUI(fluidPage(

  # Application title
  titlePanel("shinyAce Code Autocompletion Demo"),

  sidebarLayout(
    sidebarPanel(
      helpText("Modify the code chunks below and click Eval to see the plot update. 
               Use Ctrl+Space for code completion when enabled."),
      radioButtons("dataset", "Dataset: ", c("mtcars", "airquality"), inline = TRUE),
      tags$pre("  %>%"),
      aceEditor("mutate", mode="r", value="select(wt, mpg) \n", height = "50px"),
      tags$pre("  %>% function(data) {"),
      aceEditor("plot", mode="r", value="plot(data) \n", height = "50px"),
      tags$pre("  }"),
      div(actionButton("eval", "Eval"), class = "pull-right"),
      br(), #pad the above pull-right
      checkboxInput("enableAutocomplete", "Enable AutoComplete", TRUE),
      conditionalPanel(
        "input.enableAutocomplete", 
        wellPanel(
          checkboxInput("enableLiveCompletion", "Live auto completion", TRUE),
          checkboxInput("enableNameCompletion", list("Dataset column names completion in", tags$i("mutate")), TRUE),
          checkboxInput("enableRCompletion", "R code completion", TRUE)
        )
      ),
      textOutput("error")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot"),
      dataTableOutput("table")
    )
  )
))
