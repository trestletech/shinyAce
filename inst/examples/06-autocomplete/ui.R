library(shiny)
library(shinyAce)

shinyUI(fluidPage(
  titlePanel("shinyAce auto completion demo"),
  sidebarLayout(
    sidebarPanel(
      helpText("Modify the code chunks below and click Eval to see the plot update. 
                Use Ctrl+Space for code completion when enabled."),
      radioButtons("dataset", "Dataset: ", c("mtcars", "airquality"), inline = TRUE),
      tags$pre("  %>%"),
      aceEditor("mutate", mode = "r", value = "select(wt, mpg) \n", height = "50px"),
      tags$pre("  %>% {"),
      aceEditor("plot", mode = "r", value = "plot(.) \n", height = "50px"),
      tags$pre("  }"),
      div(actionButton("eval", "Eval"), class = "pull-right"), br(),
      checkboxInput("enableAutocomplete", "Enable AutoComplete", TRUE),
      conditionalPanel(
        "input.enableAutocomplete", 
        wellPanel(
          checkboxInput("enableLiveCompletion", "Live auto completion", TRUE),
          checkboxInput("enableNameCompletion", list("Dataset column names completion in", tags$i("mutate")), TRUE),
          checkboxInput("enableRCompletion", "R code completion", TRUE),
          checkboxInput("enableLocalCompletion", "Local text completion", TRUE)
        )
      ),
      textOutput("error")
    ),
    mainPanel(
      plotOutput("plot"),
      dataTableOutput("table")
    )
  )
))
