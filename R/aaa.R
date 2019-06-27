#' Check if vector is empty
#'
#' @param x vector
#'   
#' @examples 
#' is.empty(NULL)
#' is.empty(NA)
#' is.empty(c())
#' is.empty("")
#'
is.empty <- function(x) {
  length(x) == 0 || sum(nchar(x)) == 0 || any(is.na(x))
}

