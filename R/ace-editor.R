#' Render Ace
#'
#' Render an Ace editor on an application page.
#' @param outputId The ID associated with this element
#' @param value The initial text to be contained in the editor.
#' @param mode The Ace \code{mode} to be used by the editor. The \code{mode}
#'   in Ace is often the programming or markup language that you're using and
#'   determines things like syntax highlighting and code folding. Use the
#'   \code{\link{getAceModes}} function to enumerate all the modes available.
#' @param theme The Ace \code{theme} to be used by the editor. The \code{theme}
#'   in Ace determines the styling and coloring of the editor. Use
#'   \code{\link{getAceThemes}} to enumerate all the themes available.
#' @param vimKeyBinding If set to \code{TRUE}, Ace will enable vim-keybindings.
#'   Default value is \code{FALSE}.
#' @param readOnly If set to \code{TRUE}, Ace will disable client-side editing.
#'   If \code{FALSE} (the default), it will enable editing.
#' @param height A number (which will be interpreted as a number of pixels) or
#'   any valid CSS dimension (such as "\code{50\%}", "\code{200px}", or
#'   "\code{auto}").
#' @param fontSize Defines the font size (in px) used in the editor and should
#'   be an integer. The default is 12.
#' @param debounce The number of milliseconds to debounce the input. This will
#'   cause the client to withhold update notifications until the user has
#'   stopped typing for this amount of time. If 0, the server will be notified
#'   of every keystroke as it happens.
#' @param wordWrap If set to \code{TRUE}, Ace will enable word wrapping.
#'   Default value is \code{FALSE}.
#' @param showLineNumbers If set to \code{TRUE}, Ace will show line numbers.
#' @param highlightActiveLine If set to \code{TRUE}, Ace will highlight the active
#'   line.
#' @param cursorId The ID associated with a cursor change.
#' @param selectionId  The ID associated with a change of selected text
#' @param hotkeys A list whose names are ID names and whose elements are the
#'   shortcuts of keys. Shortcuts can either be a simple string or a list with
#'   elements 'win' and 'mac' that that specifies different shortcuts for win and
#'   mac (see example 05).
#' @param code_hotkeys A nested list. The first element indicates the code type (e.g., "r")
#'   The second element is a list whose names are ID names and whose elements are the
#'   shortcuts of keys (see \code{hotkeys})
#' @param autoComplete Enable/Disable auto code completion. Must be one of the following:
#'  \describe{
#'    \item{\code{"disabled"}}{Disable Code Autocomplete}
#'    \item{\code{"enabled"}}{Enable Basic Code Autocomplete. Autocomplete can be
#'      triggered using Ctrl-Space, Ctrl-Shift-Space, or Alt-Space.}
#'    \item{\code{"live"}}{Enable Live Code Autocomplete. In addition to Basic
#'      Autocomplete, it will automatically trigger at each key stroke.}
#'  }
#'  By default, only local completer is used where all aforementioned code pieces
#'    will be considered as candidates. Use \code{autoCompleteList} for static
#'    completions and \code{\link{aceAutocomplete}} for dynamic R code completions.
#' @param autoCompleters Character vector of completers to enable. If set to \code{NULL},
#'   all completers will be disabled. Select one or more of "snippet", "text", "static",
#'   "keyword", and "rlang" to control which completers to use. Default option is to
#'    use the "snippet", "text", and "keyword" autocompleters
#' @param autoCompleteList A named list that contains static code completions
#'   candidates. This can be especially useful for Non-Standard Evaluation (NSE)
#'   functions such as those in \code{dplyr} and \code{ggvis}. Each element in list
#'   should be a character array whose words will be listed under the element key.
#'   For example, to suggests column names from \code{mtcars} and \code{airquality},
#'   you can use \code{list(mtcars = colnames(mtcars), airquality = colnames(airquality))}.
#' @param tabSize Set tab size. Default value is 4
#' @param useSoftTabs Replace tabs by spaces. Default value is TRUE
#' @param showInvisibles Show invisible characters (e.g., spaces, tabs, newline characters).
#'   Default value is FALSE
#' @param setBehavioursEnabled Determines if the auto-pairing of special characters, like
#'   quotation marks, parenthesis, or brackets should be enabled. Default value is TRUE.
#' @param autoScrollEditorIntoView If TRUE, expands the size of the editor window as new lines are added
#' @param maxLines Maximum number of lines the editor window will expand to when autoScrollEditorIntoView is TRUE
#' @param minLines Minimum number of lines in the editor window when autoScrollEditorIntoView is TRUE
#' @param placeholder A string to use a placeholder when the editor has no content
#'
#' @import shiny
#' @importFrom utils compareVersion
#' @importFrom utils packageVersion
#'
#' @examples
#' \dontrun{
#' aceEditor(
#'   outputId = "myEditor",
#'   value = "Initial text for editor here",
#'   mode = "r",
#'   theme = "ambiance"
#' )
#'
#' aceEditor(
#'   outputId = "myCodeEditor",
#'   value = "# Enter code",
#'   mode = "r",
#'   hotkeys = list(
#'     helpKey = "F1",
#'     runKey = list(
#'       win = "Ctrl-R|Ctrl-Shift-Enter",
#'       mac = "CMD-ENTER|CMD-SHIFT-ENTER"
#'     )
#'   ),
#'   wordWrap = TRUE, debounce = 10
#' )
#'
#' aceEditor(
#'   outputId = "mySmartEditor",
#'   value = "plot(wt ~ mpg, data = mtcars)",
#'   mode = "r",
#'   autoComplete = "live",
#'   autoCompleteList = list(mtcars = colnames(mtcars))
#' )
#' }
#'
#' @author Jeff Allen \email{jeff@@trestletech.com}
#'
#' @export
aceEditor <- function(
  outputId, value, mode, theme,
  vimKeyBinding = FALSE, readOnly = FALSE, 
  height = "400px", fontSize = 12,
  debounce = 1000, wordWrap = FALSE, showLineNumbers = TRUE,
  highlightActiveLine = TRUE, 
  selectionId = NULL, cursorId = NULL,
  hotkeys = NULL, code_hotkeys = NULL,
  autoComplete = c("disabled", "enabled", "live"),
  autoCompleters = c("snippet", "text", "keyword"),
  autoCompleteList = NULL,
  tabSize = 4, useSoftTabs = TRUE,
  showInvisibles = FALSE, setBehavioursEnabled = TRUE,
  autoScrollEditorIntoView = FALSE, 
  maxLines = NULL, minLines = NULL,
  placeholder = NULL
) {
  
  escapedId <- gsub("\\.", "\\\\\\\\.", outputId)
  escapedId <- gsub("\\:", "\\\\\\\\:", escapedId)
  payloadLst <-
    list(
      id = escapedId,
      vimKeyBinding = vimKeyBinding,
      readOnly = readOnly,
      wordWrap = wordWrap,
      showLineNumbers = showLineNumbers,
      highlightActiveLine = highlightActiveLine,
      selectionId = selectionId,
      cursorId = cursorId,
      hotkeys = hotkeys,
      code_hotkeys = code_hotkeys,
      autoComplete = match.arg(autoComplete),
      autoCompleteList = autoCompleteList,
      tabSize = tabSize,
      useSoftTabs = useSoftTabs,
      showInvisibles = showInvisibles,
      setBehavioursEnabled = setBehavioursEnabled,
      autoScrollEditorIntoView = autoScrollEditorIntoView,
      maxLines = maxLines,
      minLines = minLines,
      placeholder = placeholder
    )

  if (is.empty(autoCompleters)) {
    payloadLst$autoComplete <- "disabled"
  } else if (any(autoCompleters %in% c("snippet", "text", "static", "keyword", "rlang"))) {
    payloadLst$autoCompleters <- I(autoCompleters)
  } else {
    payloadLst$autoComplete <- "disabled"
  }

  # "value" could be provided as a list or vector, see https://github.com/trestletech/shinyAce/issues/64
  if (!missing(value)) payloadLst$value <- paste0(unlist(value), collapse = "\n")
  if (!missing(mode)) payloadLst$mode <- mode
  if (!missing(theme)) payloadLst$theme <- theme
  if (!is.empty(as.numeric(fontSize))) payloadLst$fontSize <- as.numeric(fontSize)
  if (!is.empty(as.numeric(debounce))) payloadLst$debounce <- as.numeric(debounce)
  # Filter out any elements of the list that are NULL
  # In the javascript code we use ".hasOwnProperty" to test whether a property
  # should be set, and all of our properties are such that a javascript value of
  # `null` does not make sense.
  payloadLst <- Filter(f = function(y) !is.empty(y), x = payloadLst)
  payload <- jsonlite::toJSON(payloadLst, null = "null", auto_unbox = TRUE)

  # assign code-jump js file to source, if any
  if (is.empty(code_hotkeys)) {
    cfile <- NULL
  } else {
    cfile <- paste0("shinyAce/code/code-jump-", code_hotkeys[[1]], ".js")
  }

  tagList(
    singleton(tags$head(
      initResourcePaths(),
      tags$script(src = "shinyAce/ace/ace.js"),
      tags$script(src = "shinyAce/ace/ext-language_tools.js"),
      tags$script(src = "shinyAce/ace/ext-searchbox.js"),
      tags$script(src = "shinyAce/shinyAce.js"),
      tags$script(src = cfile),
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "shinyAce/shinyAce.css"
      )
    )),
    pre(
      id = outputId,
      class = "shiny-ace",
      style = paste("height:", validateCssUnit(height)),
      `data-auto-complete-list` = jsonlite::toJSON(autoCompleteList)
    ),
    tags$script(type = "application/json", `data-for` = escapedId, HTML(payload))
  )
}
