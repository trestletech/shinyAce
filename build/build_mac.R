## build for mac
app <- "shinyAce"
curr <- setwd("../")
devtools::install(app)
f <- devtools::build(app)
system(paste0("R CMD INSTALL --build ", f))
setwd(curr)

## https://stackoverflow.com/a/37292839/1974918
# devtools::build() %>%
  # install.packages(repos = NULL, type = "source")
