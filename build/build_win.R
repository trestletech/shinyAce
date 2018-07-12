## build for windows
rv <- R.Version()
rv <- paste0(rv$major,".", strsplit(rv$minor,".", fixed = TRUE)[[1]][1])

rvprompt <- readline(prompt = paste0("Running for R version: ", rv, ". Is that what you wanted y/n: "))
if (grepl("[nN]", rvprompt))
  stop("Change R-version using Rstudio > Tools > Global Options > Rversion")

## build for windows
app <- basename(getwd())
path <- "../"
devtools::install(file.path(path, app))
f <- devtools::build(file.path(path, app))
curr <- getwd(); setwd(path)
system(paste0("R CMD INSTALL --build ", f))
setwd(curr)

