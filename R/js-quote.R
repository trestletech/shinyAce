#' Escape a JS String
#' 
#' Escape a String to be sent to JavaScript
#' @param text The text to escape
#' 
#' @author Jeff Allen \email{jeff@@trestletech.com}
jsQuote <- function(text){
  toReturn <- shQuote(text)
  toReturn <- gsub('\f', '\\\\f', toReturn)
  toReturn <- gsub('\r', '\\\\r', toReturn)
  gsub('\n', '\\\\n', toReturn)
}