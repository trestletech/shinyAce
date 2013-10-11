\name{renderHtable}
\alias{renderHtable}
\title{Render a Handsontable Element}
\usage{
  renderHtable(expr, env = parent.frame(), quoted = FALSE)
}
\arguments{
  \item{expr}{The expression to be evaluated which should
  produce a data.frame}

  \item{env}{The environment in which \code{expr} should be
  evaluated.}

  \item{quoated}{Is \code{expr} a quoted expression (with
  \code{quote()})? This is useful if you want to save an
  expression in a variable.}
}
\description{
  Render a Handsontable Shiny output.
}
\author{
  Jeff Allen \email{jeff@trestletech.com}
}

