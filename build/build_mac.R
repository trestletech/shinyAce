## build for mac
app <- basename(getwd())
curr <- setwd("../")
f <- devtools::build(app)
system(paste0("R CMD INSTALL --build ", f))
setwd(curr)
