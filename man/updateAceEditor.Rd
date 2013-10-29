\name{updateAceEditor}
\alias{updateAceEditor}
\title{Update Ace Editor}
\usage{
  updateAceEditor(session, editorId, value, theme,
    readOnly, mode)
}
\arguments{
  \item{session}{The Shiny session to whom the editor
  belongs}

  \item{editorId}{The ID associated with this element}

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
}
\description{
  Update the styling or mode of an aceEditor component.
}
\author{
  Jeff Allen \email{jeff@trestletech.com}
}

