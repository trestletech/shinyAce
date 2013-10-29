#' Get available themes
#' 
#' Gets all of the available \code{themes} available in the installed version
#' of shinyAce. Themes determine the styling and colors used in the editor.
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' @export
getAceThemes <- function(){
  themes <- dir(system.file('www/ace', package='shinyAce'), "^theme-.*.js$")
  themes <- sub("^theme-(.*).js$", "\\1", themes)
  themes
}