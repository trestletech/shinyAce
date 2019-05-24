get_help_file <- function(topic, package = NULL, ...) {
  tryCatch({
    utils:::.getHelpFile(eval(bquote(help(
      topic = .(topic), 
      package = .(package), 
      ...))))
  }, error = function(e) NULL)
}

rd_2_html <- function(...) {
  paste(capture.output(tools::Rd2HTML(...)), collapse = " ")
}

get_desc_help <- function(...) {
  x <- get_help_file(...)
  if (is.null(x)) return(x)
  
  rd_2_html(x[[which(tools:::RdTags(x) == "\\description")]], fragment = TRUE)
}


get_arg_help <- function(..., args = character()) {
  x <- get_help_file(...)
  if (is.null(x)) return(character())
  
  arg_rds <- x[[which(tools:::RdTags(x) == "\\arguments")]]
  arg_rds <- Filter(function(i) attr(i, "Rd_tag") == "\\item", arg_rds)
  arg_rds <- setNames(lapply(arg_rds, "[[", 2), Map(function(i) i[[1]][[1]], arg_rds))
  if (length(args)) arg_rds <- arg_rds[which(names(arg_rds) %in% args)]
  sapply(arg_rds, rd_2_html, fragment = TRUE)
}


re_capture <- function(x, re, ...) {
  re_match <- regexpr(re, x, ...)
  setNames(
    substring(x, 
      s <- attr(re_match, "capture.start"),  
      s + attr(re_match, "capture.length") - 1),
    attr(re_match, "capture.names"))
}