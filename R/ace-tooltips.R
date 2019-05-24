#' @export
aceTooltip <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  shiny::observe({
    value <- session$input[[paste0(inputId, "_shinyAce_tooltipItem")]]
    if (is.null(value)) return()

    symbol <- value$symbol
    envir <- value$meta
     
    tooltip_caption <- if (endsWith(value$name, " = ")) {
      name <- gsub(" = $", "", value$name)
      paste0(
        "<b>", name, "</b>", 
        tryCatch({
          if (!length(envir) || envir == "R") {
            get_arg_help(symbol, args = name)
          } else {
            get_arg_help(symbol, package = envir, args = name)
          }
        }, error = function(e) { print(e$message); ""}))
    } else {
      paste0(
        "<b>", symbol, "</b>", 
        tryCatch({
          if (!length(envir) || envir == "R") {
            get_desc_help(symbol)
          } else {
            get_desc_help(symbol, package = envir)
          }
        }, error = function(e) { print(e$message); ""}))
    }
    
    return(session$sendCustomMessage('shinyAce', list(
      id = session$ns(inputId),
      docTooltip = jsonlite::toJSON(list(
        docHTML = paste0("<div>", tooltip_caption, "</div>")
      ), auto_unbox = TRUE))))
  })
}
