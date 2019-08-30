library(shinyAce)

init <- "### Sample knitr Doc

This is some markdown text. It may also have embedded R code
which will be executed.

```{r}
2*3
rnorm(5)
```

It can even include graphical elements.

```{r}
hist(rnorm(100))
```
"

shinyUI(
  fluidPage(
    h1("Shiny Ace knitr Example"),
    fluidRow(
      column(
        6,
        h2("Source R-Markdown"),
        aceEditor("rmd", mode = "markdown", value = init),
        actionButton("eval", "Update")
      ),
      column(
        6,
        h2("Knitted Output"),
        htmlOutput("knitDoc")
      )
    )
  )
)
