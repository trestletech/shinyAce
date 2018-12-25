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
#'   mac (see example). 
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
#' @param autoCompleters List of completers to enable. If set to \code{NULL},
#'   all completers will be disabled. Select one or more of "snippet", "text", "static", 
#'   and "keyword" to control which completers to use. Default option is an empty character
#'   vector which does not effect default completion options
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
#' 
#' @import shiny
#' @importFrom utils compareVersion
#' @importFrom utils packageVersion
#' 
#' @examples \dontrun{
#'  aceEditor(
#'    outputId = "myEditor", 
#'    value = "Initial text for editor here", 
#'    mode = "r", 
#'    theme = "ambiance"
#'  )
#'    
#'  aceEditor(
#'    outputId = "myCodeEditor", 
#'    value = "# Enter code", 
#'    mode = "r",
#'    hotkeys = list(
#'      helpKey = "F1",
#'      runKey = list(
#'        win = "Ctrl-R|Ctrl-Shift-Enter",
#'        mac = "CMD-ENTER|CMD-SHIFT-ENTER"
#'      )
#'    ),
#'    wordWrap = TRUE, debounce = 10
#'  ) 
#'    
#'  aceEditor(
#'    outputId = "mySmartEditor", 
#'    value = "plot(wt ~ mpg, data = mtcars)", 
#'    mode = "r",
#'    autoComplete = "live",
#'    autoCompleteList = list(mtcars = colnames(mtcars))
#'  )
#' } 
#' 
#' @author Jeff Allen \email{jeff@@trestletech.com}
#' 
#' @export
aceEditor <- function(
  outputId, value, mode, theme,  
  vimKeyBinding = FALSE, readOnly = FALSE, height = "400px", fontSize = 12,  
  debounce = 1000,  wordWrap = FALSE, showLineNumbers = TRUE, 
  highlightActiveLine = TRUE, selectionId = NULL,  cursorId = NULL, 
  hotkeys = NULL, 
  autoComplete = c("disabled", "enabled", "live"),
  autoCompleters = "",
  autoCompleteList = NULL,
  tabSize = 4, useSoftTabs = TRUE, 
  showInvisibles = FALSE, setBehavioursEnabled = TRUE,
  autoScrollEditorIntoView = FALSE, maxLines = NULL, minLines = NULL
) {
  
  editorVar <- paste0("editor__", sanitizeId(outputId))
  js <- paste("var ", editorVar," = ace.edit('", outputId, "');", sep = "")
  if (!missing(theme)) {
    js <- paste(js, "", editorVar, ".setTheme('ace/theme/", theme, "');", sep = "")
  }
  if (vimKeyBinding) {
    js <- paste(js, "", editorVar, ".setKeyboardHandler('ace/keyboard/vim');", sep = "")
  }
  if (!missing(mode)) {
    js <- paste(js, "", editorVar, ".getSession().setMode('ace/mode/", mode,"');", sep = "")
  }
  if (!missing(value)) {
    js <- paste(js, "", editorVar, ".setValue(", jsQuote(value), ", -1);", sep = "")
  }  
  if (!showLineNumbers) {
    js <- paste(js, "", editorVar, ".renderer.setShowGutter(false);", sep = "")
  }
  if (!highlightActiveLine) {
    js <- paste(js, "", editorVar, ".setHighlightActiveLine(false);", sep = "")
  }
  if (readOnly) {
    js <- paste(js, "", editorVar, ".setReadOnly(", jsQuote(readOnly), ");", sep = "")
  }
  if (!is.null(fontSize) && !is.na(as.numeric(fontSize))) {
    js <- paste(js, "document.getElementById('", outputId, "').style.fontSize='",
                as.numeric(fontSize), "px'; ", sep = "")
  }
  if (!is.null(debounce) && !is.na(as.numeric(debounce))) {
    # I certainly hope there's a more reasonable way to compare 
    # versions with an extra field in them...
    re <- regexpr("^\\d+\\.\\d+(\\.\\d+)?", utils::packageVersion("shiny"))
    shinyVer <- substr(utils::packageVersion("shiny"), 0, attr(re, "match.length"))
    minorVer <- as.integer(substr(utils::packageVersion("shiny"),
      attr(re, "match.length") + 2,
      nchar(utils::packageVersion("shiny"))))
    comp <- utils::compareVersion(shinyVer, "0.9.1")
    if (comp < 0 || (comp == 0 && minorVer < 9004)) {
      warning("Shiny version 0.9.1.9004 required to use input debouncing in shinyAce.")
    }
    js <- paste(js, "$('#", outputId ,"').data('debounce',", debounce,");", sep = "")
  }
  
  if (wordWrap) {
    js <- paste(js, "", editorVar,".getSession().setUseWrapMode(true);", sep = "")
  }
  
  # https://learn.jquery.com/using-jquery-core/faq/how-do-i-select-an-element-by-an-id-that-has-characters-used-in-css-notation/
  escapedId <- gsub("\\.", "\\\\\\\\.", outputId)
  escapedId <- gsub("\\:", "\\\\\\\\:", escapedId)
  js <- paste(js, "$('#", escapedId, "').data('aceEditor',", editorVar, ");", sep = "")

  if (!is.null(selectionId)) {
    selectJS <- paste("", editorVar, ".getSelection().on(\"changeSelection\", function() {
      Shiny.onInputChange(\"", selectionId,
      "\",", editorVar, ".getCopyText());})", 
      sep = "")
    js <- paste(js, selectJS, sep = "")
  }
  
  if (!is.null(cursorId)) {    
    curJS <- paste("\n", editorVar, ".getSelection().on(\"changeCursor\", function() {
      Shiny.onInputChange(\"", cursorId,
      "\",", editorVar, ".selection.getCursor() );}\n);", 
    sep = "")
    js <- paste(js, curJS, sep = "")
  }
  
  for (i in seq_along(hotkeys)) {
    shortcut = hotkeys[[i]]
    if (is.list(shortcut)) {
      shortcut = paste0(names(shortcut), ": '", shortcut, "'", collapse = ", ")
    } else {
      shortcut = paste0("win: '", shortcut, "',  mac: '", shortcut, "'")
    }
    
    id = names(hotkeys)[i]
    code = paste0("
    ", editorVar,".commands.addCommand({
        name: '", id,"',
        bindKey: {", shortcut,"},
        exec: function(", editorVar,") {

          var selection = ", editorVar, ".session.getTextRange();
          var range = ", editorVar, ".selection.getRange();
          var imax = ", editorVar, ".session.getLength() - range.end.row;
                  
          if(selection === '') {
            var i = 1;
            var line = ", editorVar, ".session.getLine(range.end.row);
            var next_line = ", editorVar, ".session.getLine(range.end.row + i);

            if (/^```\\{.*\\}\\s*$/.test(line)) {
              // run R-code chunk
              while(/\\n```\\s*$/.test(line) === false & i < imax + 1) {
                i++;
                line = line.concat('\\n', next_line);
                next_line = ", editorVar, ".session.getLine(range.end.row + i);
                // console.log(next_line, i, imax);
              }
              if (i === imax + 1) {
                line = '<h4>Code chunk not properly closed. Code chunks must end in &#96 &#96 &#96</h4>';
              } 
            } else if (/^\\$\\$\\s*$/.test(line)) {
              // evaluate equation
              while(/\\n\\$\\$\\s*$/.test(line) === false & i < imax + 1) {
                i++;
                line = line.concat('\\n', next_line);
                next_line = ", editorVar, ".session.getLine(range.end.row + i);
              }
              if (i === imax + 1) {
                line = '<h4>Equation not properly closed. Display equations must start and end with $$</h4>';
              } 
            } else if (/(\\(|\\{|\\[)\\s*$/.test(line)) {
              ", editorVar, ".navigateLineEnd();
              ", editorVar, ".jumpToMatching();
              match_line = ", editorVar, ".selection.getCursor();
              if (match_line.row === range.end.row) {
                line = '#### Bracket not properly closed. Fix and try again';
              } else {
                line = ", editorVar, ".session.getLines(range.end.row, match_line.row).join('\\n');
                i = match_line.row - range.end.row + 1
              } 
            } else {
              rexpr = /(%>%|\\+|\\-|\\,)\\s*$/;
              rxeval = rexpr.test(line);
              while((rxeval | /^\\s*(\\#|$)/.test(next_line)) & i < imax) {
                rxeval = rexpr.test(line);
                if (rxeval | /^\\s*(\\}|\\))/.test(next_line)) {
                  line = line.concat('\\n', next_line);
                }
                i++;
                next_line = ", editorVar, ".session.getLine(range.end.row + i);
                // console.log(next_line, i, imax)
              }
            }
            ", editorVar, ".gotoLine(range.end.row + i + 1);
            if (line === '') {
              line = ' ';  // ensure whole report is not rendered
            }
          }

          Shiny.onInputChange(\"", id,
          "\",{
            editorId: '", outputId,"',
            selection: selection,
            range: range,
            line: line,
            randNum: Math.random()
          });            
        },
        readOnly: true // false if this command should not apply in readOnly mode
    });    
    ")
    js <- paste0(js, code)
  }
  
  autoComplete <- match.arg(autoComplete)
  if (autoComplete != "disabled") {
    js <- paste(js, "", editorVar, ".setOption('enableBasicAutocompletion', true);", sep = "")
  }
  if (autoComplete == "live") {
    js <- paste(js, "", editorVar, ".setOption('enableLiveAutocompletion', true);", sep = "")
  }

  if (length(autoCompleters) > 0) {
    if (sum(autoCompleters %in% c("snippet", "text", "static", "keyword")) > 0) {
      js <- paste(js, 'var langTools = ace.require("ace/ext/language_tools");')
      js <- paste(js, "", editorVar, ".completers = [];", sep = "")
      if ("snippet" %in% autoCompleters) {
        js <- paste(js, "", editorVar, ".completers.push(langTools.snippetCompleter);", sep = "")
      }
      if ("text" %in% autoCompleters) {
        js <- paste(js, "", editorVar, ".completers.push(langTools.textCompleter);", sep = "")
      }
      if ("keyword" %in% autoCompleters) {
        js <- paste(js, "", editorVar, ".completers.push(langTools.keywordCompleter);", sep = "")
      }
      if ("static" %in% autoCompleters) {
        code <- 'var staticCompleter = {
            getCompletions: function(editor, session, pos, prefix, callback) {
              var comps = $("#" + editor.container.id).data("auto-complete-list");
              if(comps) {
                var words = [];
                Object.keys(comps).forEach(function(key) {
                  var comps_key = comps[key];
                  if (!Array.isArray(comps[key])) {
                    comps_key = [comps_key];
                  }
                  words = words.concat(comps_key.map(function(d) {
                    return {name: d, value: d, meta: key};
                  }));
                });
                callback(null, words);
              }
            }
          };
          langTools.addCompleter(staticCompleter);'
        js <- paste0(js, code)
        js <- paste(js, "", editorVar, ".completers.push(staticCompleter);", sep = "")
      }
    }
  } else {
    js <- paste(js, "", editorVar, ".completers = [];", sep = "")
  }

  if (!useSoftTabs) {
    js <- paste(js, "", editorVar, ".setOption('useSoftTabs', false);", sep = "")
  }
  js <- paste(js, "", editorVar, ".setOption('tabSize', ", tabSize, ");", sep = "")
  if (showInvisibles) {
    js <- paste(js, "", editorVar, ".setOption('showInvisibles', true);", sep = "")
  }
  if (!setBehavioursEnabled) {
    js <- paste(js, "", editorVar, ".setBehavioursEnabled(false);", sep = "")
  }
  
  if (autoScrollEditorIntoView) {
    js <- paste(js, "", editorVar, ".setOption('autoScrollEditorIntoView', true);", sep = "")
    if (!is.null(maxLines)) {
      js <- paste(js, "", editorVar, ".setOption('maxLines', ", maxLines, ");", sep = "")
    }
    if (!is.null(minLines)) {
      js <- paste(js, "", editorVar, ".setOption('minLines', ", minLines, ");", sep = "")
    }
  }

  tagList(
    singleton(tags$head(
      initResourcePaths(),
      tags$script(src = 'shinyAce/ace/ace.js'),
      tags$script(src = 'shinyAce/ace/ext-language_tools.js'),
      tags$script(src = 'shinyAce/ace/ext-searchbox.js'),
      tags$script(src = 'shinyAce/shinyAce.js'),
      tags$link(
        rel = 'stylesheet',
        type = 'text/css',
        href = 'shinyAce/shinyAce.css'
      )
    )),
    pre(
      id = outputId, 
      class = "shiny-ace", 
      style = paste("height:", validateCssUnit(height)),
      `data-auto-complete-list` = jsonlite::toJSON(autoCompleteList)
    ),
    tags$script(type = "text/javascript", HTML(js))
  )
}

sanitizeId <- function(id) {
  gsub("[^[:alnum:]]", "", id)
}
