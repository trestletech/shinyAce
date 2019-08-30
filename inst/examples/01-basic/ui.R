# define UI for application that demonstrates a simple Ace editor
shinyUI(
  pageWithSidebar(
    headerPanel("Simple Shiny Ace!"),
    sidebarPanel(
      selectInput("mode", "Mode: ", choices = modes, selected = "r"),
      selectInput("theme", "Theme: ", choices = themes, selected = "ambience"),
      numericInput("size", "Tab size:", 4),
      radioButtons("soft", NULL, c("Soft tabs" = TRUE, "Hard tabs" = FALSE), inline = TRUE),
      radioButtons("invisible", NULL, c("Hide invisibles" = FALSE, "Show invisibles" = TRUE), inline = TRUE),
      actionButton("reset", "Reset text"),
      actionButton("clear", "Clear text"),
      HTML("<hr />"),
      helpText(HTML("A simple Shiny Ace editor.
                  <p>Created using <a href = \"http://github.com/trestletech/shinyAce\">shinyAce</a>."))
    ),
    mainPanel(
      aceEditor(
        outputId = "ace",
        # to access content of `selectionId` in server.R use `ace_selection`
        # i.e., the outputId is prepended to the selectionId for use
        # with Shiny modules
        selectionId = "selection",
        value = init,
        placeholder = "Show a placeholder when the editor is empty ..."
      )
    )
  )
)