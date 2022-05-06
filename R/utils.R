shiny::shinyAppDir(system.file(package = "shinyAce", "examples", "12-tooltips"))

#' Get namespace to get access to unexported functions, namely
#'   .getHelpFile
#'   .assignLinebuffer
#'   .assignEnd
#'   .guessTokenFromLine
#'   .completeToken
#'
#' @import utils
#' 
.utils <- asNamespace("utils")

#' Get namespace to get access to unexported functions, namely
#'   RdTags
#'   
#' @import tools
#' 
.tools <- asNamespace("tools")



#' Retrieve an Rd object of a help query
#' 
#' Safely return NULL if an error is encountered.
#'
#' @inheritParams utils::help
#' @inheritDotParams utils::help
#'
#' @return the Rd object returned from \code{utils:::getHelpFile}
#' 
#' @import utils
#' 
get_help_file <- function(...) {
  dots <- list(...)
  if (is.character(dots$package) && nchar(dots$package) == 0) 
    dots$package <- NULL
  
  tryCatch({
    h <- do.call(help, dots)
    if (length(h) > 1) h <- do.call(structure, c(h[1], attributes(h)))
    if (!length(h)) NULL
    else .utils$.getHelpFile(h)
  }, error = function(e) {
    shinyAce_debug("Error while trying to retrieve help files: \n", e$message)
    NULL
  })
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
#' @inheritDotParams get_help_file
#'
#' @return a character value representing the description section of a help
#'   document, rendered as HTML
#'
#' @examples 
#' shinyAce:::get_desc_help("match", package = "base")
#'
#' @import tools 
#'
get_desc_help <- function(...) {
  x <- get_help_file(...)
  if (is.null(x)) return(x)
  rd_2_html(x[[which(.tools$RdTags(x) == "\\description")]], fragment = TRUE)
}



#' Retrieve argument documentation from help document
#'
#' @inheritParams get_help_file
#' @inheritDotParams get_help_file
#' @param args function arguments names to get documentation for
#'
#' @return A character vector of help 
#'
#' @examples
#' shinyAce:::get_arg_help("match", package = "base", args = c("table", "nomatch"))
#' 
#' @import tools
#' 
get_arg_help <- function(..., args = character()) {
  # TODO:
  #   split multi-argument help text, e.g. for function "seq" which gives a
  #   description for arguments "from" and "to" together
  
  x <- get_help_file(...)
  if (is.null(x)) return(character())
  
  arg_rds <- x[[which(.tools$RdTags(x) == "\\arguments")]]
  arg_rds <- Filter(function(i) attr(i, "Rd_tag") == "\\item", arg_rds)
  names(arg_rds) <- Map(function(i) i[[1]][[1]], arg_rds)
  arg_rds <- lapply(arg_rds, "[[", 2)
  
  # split multiple argument entries (e.g "package, help" from ?library)
  arg_rds <- Reduce(c, Map(function(name, value) {
    n <- strsplit(name, ", ")[[1]]
    out <- rep(list(value), length(n))
    names(out) <- n
    out
  }, names(arg_rds), arg_rds))
  
  # rename R "\dots" fields
  names(arg_rds)[names(arg_rds) == "list()"] <- "..."
  
  if (length(args)) arg_rds <- arg_rds[which(names(arg_rds) %in% args)]
  
  out <- vector("character", length(args))
  names(out) <- args
  
  out[names(arg_rds)] <- vapply(arg_rds, rd_2_html, character(1L), fragment = TRUE)
  out
}



#' Retrieve usage section from help document
#'
#' @inheritParams get_help_file
#' @inheritDotParams get_help_file
#'
#' @return a character value representing the usage section of a help
#'   document, rendered as HTML
#'
#' @examples 
#' shinyAce:::get_usage_help("match", package = "base")
#'
#' @import tools 
#'
get_usage_help <- function(...) {
  x <- get_help_file(...)
  if (is.null(x)) return(x)
  rd_2_html(x[[which(.tools$RdTags(x) == "\\usage")]], fragment = TRUE)
}



#' Retrieve regular expression named capture groups as a list
#'
#' @param x a character string to capture from
#' @param re the regular expression to use
#' @param ... additional arguments passed to \code{\link[base]{regexpr}}
#'
#' @return a named list of matches
#'
#' @examples
#' shinyAce:::re_capture("ak09j b", "(?<num>\\d+)(?<alpha>[a-zA-Z]+)", perl = TRUE)
#' 
re_capture <- function(x, re, ...) {
  re_match <- regexpr(re, x, ...)
  out <- substring(x, 
    s <- attr(re_match, "capture.start"),  
    s + attr(re_match, "capture.length") - 1)
  names(out) <- attr(re_match, "capture.names")
  out
}



#' Character value to use for package meta field
meta_pkg <- function() "{pkg}"



#' Character value to use for object meta field
meta_obj <- function() "{obj}"



#' Function for handling optional debugging messages
#' 
#' @inheritParams base::message
#' 
shinyAce_debug <- function(...) {
  if (getOption("shinyAce.debug", FALSE))
    message("[shinyAce] ", ...)
}



#' Regular expression for matching the function name in a completion line in the
#' middle of a function call
.fname_regex <- paste0(
  "(?:^|.*[^a-zA-Z0-9._:])", # non-function name chars, non-capturing group
  "([a-zA-Z0-9._:]+)",       # function name capturing group
  "\\(",                     # function call open paren
  "[^)]*$"                   # remainder of line buffer within function call
)