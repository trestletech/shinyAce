(function () {

  var langTools = ace.require("ace/ext/language_tools");
  var staticCompleter = {
    getCompletions: function (editor, session, pos, prefix, callback) {
      var comps = $('#' + editor.container.id).data('auto-complete-list');
      if (comps) {
        var words = [];
        Object.keys(comps).forEach(function (key) {
          var comps_key = comps[key];
          if (!Array.isArray(comps[key])) {
            comps_key = [comps_key];
          }
          words = words.concat(comps_key.map(function (d) {
            return { name: d, value: d, meta: key };
          }));
        });
        callback(null, words);
      }
    }
  };
  langTools.addCompleter(staticCompleter);

  var rlangCompleter = {
    getCompletions: function (editor, session, pos, prefix, callback) {
      var inputId = editor.container.id;
      // TODO: consider dropping onInputChange hook when completer is disabled for performance
      Shiny.onInputChange(inputId + '_shinyAce_hint', {
        // TODO: add an option to disable full document parsing for performance
        document: session.getValue(),
        linebuffer: session.getLine(pos.row),
        cursorPosition: pos,
        // nonce causes autocomplete event to trigger
        // on R side even if Ctrl-Space is pressed twice
        // with the same linebuffer and cursorPosition
        nonce: Math.random()
      });
      // store callback for dynamic completion
      $('#' + inputId).data('autoCompleteCallback', callback);
    }
    // TODO: add option to include optional getDocTooltip for suggestion context
  };
  langTools.addCompleter(rlangCompleter);

  function updateEditor(el, data) {
    if (typeof $(el).data('aceEditor') !== 'undefined')
      var editor = $(el).data('aceEditor');
    else
      var editor = ace.edit(el);

    if (data.hasOwnProperty('fontSize')) {
      el.style.fontSize = data.fontSize + 'px';
    }

    if (data.hasOwnProperty('theme')) {
      editor.setTheme("ace/theme/" + data.theme);
    }

    if (data.hasOwnProperty('mode')) {
      editor.getSession().setMode('ace/mode/' + data.mode);
    }

    if (data.hasOwnProperty('value')) {
      editor.setValue(data.value, -1);
    }

    if (data.hasOwnProperty("selectionId")) {
      editor.getSelection().on("changeSelection", function () {
        Shiny.onInputChange(el.id + "_" + data.selectionId, editor.getCopyText());
      })
    }

    if (data.hasOwnProperty("cursorId")) {
      editor.getSelection().on("changeCursor", function () {
        Shiny.onInputChange(el.id + "_" + data.cursorId, editor.selection.getCursor());
      })
    }

    if (data.hasOwnProperty("hotkeys")) {
      Object.keys(data.hotkeys).forEach(function (key) {
        editor.commands.addCommand({
          name: key,
          bindKey: data.hotkeys[key],
          exec: function (editor) {
            var selection = editor.session.getTextRange();
            var range = editor.selection.getRange();
            var imax = editor.session.getLength() - range.end.row;
            var inputId = editor.container.id;
            var shinyEvent = {
              editorId: inputId,
              selection: selection,
              range: range,
              randNum: Math.random()
            };
            Shiny.onInputChange(inputId + "_" + key, shinyEvent);
          }, // exec end
          readOnly: true // false if this command should not apply in readOnly mode
        }); //editor.addCommand end
      }); // forEach end
    }

    if (data.hasOwnProperty("code_hotkeys")) {
      // data.code_hotkeys[0] should indicate the code type (e.g., "r", "python", etc.)
      // in the future, this could load js code to "jump" through code of that type
      Object.keys(data.code_hotkeys[1]).forEach(function (key) {
        editor.commands.addCommand({
          name: key,
          bindKey: data.code_hotkeys[1][key],
          exec: function (editor) {
            var selection = editor.session.getTextRange();
            var range = editor.selection.getRange();
            var imax = editor.session.getLength() - range.end.row;
            var inputId = editor.container.id;
            if (selection === "") {
              var line = code_jump(editor, range, imax);
            }
            var shinyEvent = {
              editorId: inputId,
              selection: selection,
              range: range,
              line: line,
              randNum: Math.random()
            };
            Shiny.onInputChange(inputId + "_" + key, shinyEvent);
          }, // exec end
          readOnly: true // false if this command should not apply in readOnly mode
        }); //editor.addCommand end
      }); // forEach end
    }

    if (data.hasOwnProperty("debounce")) {
      $(el).data("debounce", data.debounce);
    }

    if (data.hasOwnProperty("vimKeyBinding") && data.vimKeyBinding === true) {
      editor.setKeyboardHandler("ace/keyboard/vim");
    }

    if (data.hasOwnProperty("showLineNumbers") && data.showLineNumbers === false) {
      editor.renderer.setShowGutter(false);
    }

    if (data.hasOwnProperty("highlightActiveLine") && data.highlightActiveLine === false) {
      editor.setHighlightActiveLine(false);
    }

    if (data.hasOwnProperty('readOnly')) {
      editor.setReadOnly(data.readOnly);
    }

    if (data.hasOwnProperty('wordWrap')) {
      editor.getSession().setUseWrapMode(data.wordWrap);
    }

    if (data.hasOwnProperty("useSoftTabs")) {
      editor.setOption("useSoftTabs", data.useSoftTabs);
    }

    if (data.hasOwnProperty("tabSize")) {
      editor.setOption("tabSize", data.tabSize);
    }

    if (data.hasOwnProperty("showInvisibles")) {
      editor.setOption("showInvisibles", data.showInvisibles);
    }

    if (data.hasOwnProperty('border')) {
      var classes = ['acenormal', 'aceflash', 'acealert'];
      $(el).removeClass(classes.join(' '));
      $(el).addClass(data.border);
    }

    if (data.hasOwnProperty('autoComplete')) {
      var value = data.autoComplete;
      editor.setOption('enableLiveAutocompletion', value === 'live');
      editor.setOption('enableBasicAutocompletion', value !== 'disabled');
    }

    if (data.hasOwnProperty('autoCompleters')) {
      var completers = data.autoCompleters;
      editor.completers = [];
      if (completers) {
        if (!Array.isArray(completers)) {
          completers = [completers];
        }
        completers.forEach(function (completer) {
          switch (completer) {
            case 'snippet':
              editor.completers.push(langTools.snippetCompleter);
              break;
            case 'text':
              editor.completers.push(langTools.textCompleter);
              break;
            case 'keyword':
              editor.completers.push(langTools.keyWordCompleter);
              break;
            case 'static':
              editor.completers.push(staticCompleter);
              break;
            case 'rlang':
              editor.completers.push(rlangCompleter);
              break;
          }
        });
      }
    }

    if (data.hasOwnProperty('autoCompleteList')) {
      $(el).data('auto-complete-list', data.autoCompleteList);
    }

    if (data.hasOwnProperty("setBehavioursEnabled") && data.setBehavioursEnabled === false) {
      editor.setBehavioursEnabled(data.setBehavioursEnabled);
    }

    if (data.hasOwnProperty("autoScrollEditorIntoView") && data.autoScrollEditorIntoView === true) {
      editor.setOption("autoScrollEditorIntoView", true);
      if (data.hasOwnProperty("maxLines")) {
        editor.setOption("maxLines", data.maxLines);
      }
      if (data.hasOwnProperty("minLines")) {
        editor.setOption("minLines", data.minLines);
      }
    }

    if (data.hasOwnProperty("codeCompletions")) {
      var callback = $(el).data('autoCompleteCallback');
      if (callback !== undefined) callback(null, data.codeCompletions);
    }

    if (data.hasOwnProperty('placeholder')) {
      // adapted from https://stackoverflow.com/a/26700324/1974918
      
      function update() {
        var shouldShow = !editor.session.getValue().length;
        var node = editor.renderer.emptyMessageNode;
        if (!shouldShow && node) {
          editor.renderer.scroller.removeChild(editor.renderer.emptyMessageNode);
          editor.renderer.emptyMessageNode = null;
        } else if (shouldShow && !node) {
          node = editor.renderer.emptyMessageNode = document.createElement("div");
          node.textContent = data.placeholder;
          node.className = "ace_emptyMessage";
          node.style.padding = "0 15px";
          node.style.position = "absolute";
          node.style.zIndex = 9;
          node.style.opacity = 0.5;
          editor.renderer.scroller.appendChild(node);
        }
      }

      editor.on("input", update);
      setTimeout(update, 100);
    }

    if (typeof $(el).data('aceEditor') == 'undefined')
      $(el).data("aceEditor", editor);

  };

  var shinyAceInputBinding = new Shiny.InputBinding();
  $.extend(shinyAceInputBinding, {
    find: function (scope) {
      return $(scope).find(".shiny-ace");
    },
    initialize: function (el) {
      var scriptData = document.querySelector("script[data-for='" + el.id + "'][type='application/json']");
      if (scriptData) {
        var data = JSON.parse(scriptData.textContent);
        updateEditor(el, data);
      }
    },
    getValue: function (el) {
      return ($(el).data('aceEditor').getValue());
    },
    setValue: function (el, value) {
      //TODO
    },
    subscribe: function (el, callback) {
      $(el).data('aceChangeCallback', function (e) {
        callback(true);
      });

      $(el).data('aceEditor').getSession().addEventListener("change",
        $(el).data('aceChangeCallback')
      );
    },
    unsubscribe: function (el) {
      $(el).data('aceEditor').getSession().removeEventListener("change",
        $(el).data('aceChangeCallback'));
    },
    getRatePolicy: function (el) {
      return ({ policy: 'debounce', delay: $(el).data('debounce') || 1000 });
    }
  });

  Shiny.inputBindings.register(shinyAceInputBinding);

  Shiny.addCustomMessageHandler('shinyAce', function (data) {
    var id = data.id;
    var el = document.getElementById(data.id);
    updateEditor(el, data);
  });

  // Allow toggle of the search-replace box in Ace
  // see https://github.com/ajaxorg/ace/issues/3552
  var toggle_search_replace = ace.require("ace/ext/searchbox").SearchBox.prototype.$searchBarKb.bindKey("Ctrl-f|Command-f|Ctrl-H|Command-Option-F", function (sb) {
    var isReplace = sb.isReplace = !sb.isReplace;
    sb.replaceBox.style.display = isReplace ? "" : "none";
    sb[isReplace ? "replaceInput" : "searchInput"].focus();
  });

})();
