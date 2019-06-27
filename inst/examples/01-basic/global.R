library(shiny)
library(shinyAce)

modes <- getAceModes()
themes <- getAceThemes()

init <- "createData <- function(rows) {
  data.frame(col1 = 1:rows, col2 = rnorm(rows))
}"
