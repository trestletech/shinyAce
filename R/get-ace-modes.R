#' Get available modes
#'
#' Gets all of the available \code{modes} available in the installed version
#' of shinyAce. Modes are often the programming or markup language which will
#' be used in the editor and determine things like syntax highlighting and
#' code folding.
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
getAceModes <- function() {
  modes <- dir(system.file("www/ace", package = "shinyAce"), "^mode-.*.js$")
  sub("^mode-(.*).js$", "\\1", modes)
}
