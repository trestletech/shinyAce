library(shiny)
library(shinyAce)

shinyUI(fluidPage(
  titlePanel("shinyAce auto completion demo"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("enableAutocomplete", "Enable R AutoComplete", TRUE),
      checkboxInput("enableTooltips", "Enable R Tooltips", TRUE),
      checkboxInput("enableAnnotations", "Enable R Annotations", TRUE)),
    mainPanel(
      aceEditor("ace_editor", 
        mode = "r", 
        autoComplete = "live",
        autoCompleters = "rlang", 
        value = "# Tooltips:
# linger over an autocomplete option to view some documentation. See
# - Function descriptions
#     data.fra  # <autocomplete>
# - Argument descriptions
#     data.frame(  # <autocomplete>
# - Package descriptions
#     shinyAc  # <autocomplete>


# Annotations:
# gutter annotations used to indicate syntax errors, try uncommenting this line 
# with an incomplete string
# '''


"
    )))
))
