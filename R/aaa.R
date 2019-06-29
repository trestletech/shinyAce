#' Check if vector is empty
#'
#' @param x vector
#'   
#' @examples 
#' is.empty(NULL)
#' is.empty(NA)
#' is.empty(c())
#' is.empty("")
#' is.empty(" ")
#' is.empty(c(" ", " "))
#' is.empty(list())
#' is.empty(list(a = "", b = ""))
#' 
#' @export
is.empty <- function(x) {
  length(x) == 0 || 
  any(is.na(x))  || 
  sum(nchar(sub("\\s+", "", x))) == 0
}


