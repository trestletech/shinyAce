\name{aceEditor}
\alias{aceEditor}
\title{Render Ace}
\usage{
  aceEditor(outputId, value, mode, theme, readOnly = FALSE,
    height = "400px", fontSize = 12)
}
\arguments{
  \item{outputId}{The ID associated with this element}

  \item{value}{The initial text to be contained in the
  editor.}

  \item{mode}{The Ace \code{mode} to be used by the editor.
  The \code{mode} in Ace is often the programming or markup
  language that you're using and determines things like
  syntax highlighting and code folding. Use the
  \code{\link{getAceModes}} function to enumerate all the
  modes available.}

  \item{theme}{The Ace \code{theme} to be used by the
  editor. The \code{theme} in Ace determines the styling
  and coloring of the editor. Use
  \code{\link{getAceThemes}} to enumerate all the themes
  available.}

  \item{readOnly}{If set to \code{TRUE}, Ace will disable
  client-side editing.  If \code{FALSE} (the default), it
  will enable editing.}

  \item{height}{A number (which will be interpreted as a
  number of pixels) or any valid CSS dimension (such as
  "\code{50\%}", "\code{200px}", or "\code{auto}").}

  \item{fontSize}{Defines the font size (in px) used in the
  editor and should be an integer. The default is 12.}
}
\description{
  Render an Ace editor on an application page.
}
\examples{
\dontrun{
 aceEditor("myEditor", "Initial text for editor here", mode="r",
   theme="ambiance")
}
}
\author{
  Jeff Allen \email{jeff@trestletech.com}
}

