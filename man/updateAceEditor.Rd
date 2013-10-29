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

  \item{theme}{The Ace theme}

  \item{mode}{The Ace mode}

  \item{readOnly}{If set to \code{TRUE}, Ace will disable
  client-side editing.  If \code{FALSE}, it will enable
  editing.}
}
\description{
  Update the styling or mode of an aceEditor component.
}
\author{
  Jeff Allen \email{jeff@trestletech.com}
}

