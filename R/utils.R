#' Retrieve an Rd object of a help query
#' 
#' Safely return NULL if an error is encountered.
#'
#' @param topic character name of help topic 
#' @param package character name of help topic package namespace
#' @param ... additional arguments passed to \code{utils:::.getHelpFile}
#'
#' @return the Rd object returned from \code{utils:::.getHelpFile}
#' 
#' @import utils
#' 
get_help_file <- function(topic, package = NULL, ...) {
  tryCatch({
    utils:::.getHelpFile(eval(bquote(help(
      topic = .(topic), 
      package = .(package), 
      ...))))
  }, error = function(e) NULL)
}



#' Convert an Rd object to HTML
#'
#' @inheritParams tools::Rd2HTML
#'
#' @return a character value of Rd content rendered as HTML
#'
#' @importFrom tools Rd2HTML
#'
rd_2_html <- function(...) {
  paste(capture.output(tools::Rd2HTML(...)), collapse = " ")
}



#' Retrieve description section from help document
#'
#' @inheritParams get_help_file
#'
#' @return a character value representing the description section of a help
#'   document, rendered as HTML
#'
#' @examples 
#' get_desc_help("match", package = "base")
#'
#' @import tools 
#'
get_desc_help <- function(...) {
  x <- get_help_file(...)
  if (is.null(x)) return(x)
  
  rd_2_html(x[[which(tools:::RdTags(x) == "\\description")]], fragment = TRUE)
}



#' Retrieve argument documentation from help document
#'
#' @inheritParams get_help_file
#' @param args function arguments names to get documentation for
#'
#' @return A character vector of help 
#'
#' @examples
#' get_arg_help("match", package = "base", args = c("table", "nomatch"))
#' 
#' @import tools
#' 
get_arg_help <- function(..., args = character()) {
  x <- get_help_file(...)
  if (is.null(x)) return(character())
  
  arg_rds <- x[[which(tools:::RdTags(x) == "\\arguments")]]
  arg_rds <- Filter(function(i) attr(i, "Rd_tag") == "\\item", arg_rds)
  arg_rds <- setNames(lapply(arg_rds, "[[", 2), Map(function(i) i[[1]][[1]], arg_rds))
  if (length(args)) arg_rds <- arg_rds[which(names(arg_rds) %in% args)]
  
  out <- setNames(vector("character", length(args)), args)
  out[names(arg_rds)] <- sapply(arg_rds, rd_2_html, fragment = TRUE)
  out
}



#' Retrieve regular expression named capture groups as a list
#'
#' @param x a character string to capture from
#' @param re the regular expression to use
#' @inheritParams base::regexpr
#'
#' @return a named list of matches
#'
#' @examples
#' re_capture("ak09j b", "(?<num>\\d+)(?<alpha>[a-zA-Z]+)", perl = TRUE)
#' 
re_capture <- function(x, re, ...) {
  re_match <- regexpr(re, x, ...)
  out <- substring(x, 
    s <- attr(re_match, "capture.start"),  
    s + attr(re_match, "capture.length") - 1)
  names(out) <- attr(re_match, "capture.names")
  out
}