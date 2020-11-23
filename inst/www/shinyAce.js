(function () {
  var lang = ace.require("ace/lib/lang");
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
    identifierRegexps: [
      /[a-zA-Z_0-9\.\:\-\u00A2-\uFFFF]/, 
    ],
    getCompletions: function(editor, session, pos, prefix, callback) {
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
  };
  langTools.addCompleter(rlangCompleter);

  // behavior upon selection of an autocompletion
  //   I was expecting this to be able to be defined with the rlangCompleter,
  //   but it appears to only be able to be defined per-completion.
  //   Upon a completion callback, completions are mapped over and assigned this 
  //  function for insertion behavior for each completion entry
  function r_insertMatch(editor, data) {
    if (editor.completer.completions.filterText) {
      var ranges = editor.selection.getAllRanges();
      for (var i = 0, range; range = ranges[i]; i++) {
        range.start.column -= editor.completer.completions.filterText.length;
        editor.session.remove(range);
      }
    }
    if (data.snippet) {
      snippetManager.insertSnippet(editor, data.snippet);
    } else {
      // insert completion
      var insertString = data.value || data;
      editor.execCommand("insertstring", insertString);
      
      // automatically clobber existing code
      var cursor = editor.getCursorPosition();
      var remainder = editor.session.getLine(cursor.row).slice(cursor.column);
      var re_match = remainder.match(/(^[a-zA-Z0-9._:]*)((?:\(\)?|\))?)/);
      if (re_match && re_match[0].length) {
        // remove word that we're clobbering
        editor.getSession().getDocument().removeInLine(
          cursor.row, cursor.column, cursor.column + re_match[1].length);
          
        // if function call, delete parens and navigate into existing call
        if (insertString.endsWith("()") && re_match[2].length) {
          editor.getSession().getDocument().removeInLine(
            cursor.row, cursor.column - re_match[2].length, cursor.column);
          if (re_match[2].length > 1) editor.navigateRight(1);
        }
        
      } else if (insertString.endsWith("()")) {
        // navigate backwards into ()'s for function completions
        editor.navigateLeft(1);
      }
      
    }
  };
  langTools.addCompleter(rlangCompleter);

  function updateEditor(el, data) {
    var editor = {};
    if (typeof $(el).data('aceEditor') !== 'undefined')
      editor = $(el).data('aceEditor');
    else
      editor = ace.edit(el);

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
      });
    }

    if (data.hasOwnProperty("cursorId")) {
      editor.getSelection().on("changeCursor", function () {
        Shiny.onInputChange(el.id + "_" + data.cursorId, editor.selection.getCursor());
      });
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
            var line = "";
            if (selection === "") {
              line = code_jump(editor, range, imax);
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

    if (data.hasOwnProperty("showLineNumbers")) {
      if (data.showLineNumbers === false) {
        editor.renderer.setShowGutter(false);
      } else if (data.showLineNumbers === true) {
        editor.renderer.setShowGutter(true);
      }
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

    if (data.hasOwnProperty("showPrintMargin")) {
      editor.setOption("showPrintMargin", data.showPrintMargin);
    }

    if (data.hasOwnProperty('border')) {
      var classes = ['acenormal', 'aceflash', 'acealert'];
      $(el).removeClass(classes.join(' '));
      $(el).addClass(data.border);
    }
    
    if (data.annotations) {
      editor.getSession().setAnnotations(data.annotations);
    }
    
    if (data.docTooltip) {
      // { docHTML: "", docText: "" }
      if (data.docTooltip.docHTML || data.docTooltip.docText) {
        if (!editor.completer.tooltipNode) {
          if (editor.__tooltipTimerCall)
            editor.__tooltipTimerCall.cancel();
            
          editor.__tooltipTimerCall = lang.delayedCall(
            function() { 
              if (this.completer.activated)
                this.completer.showDocTooltip(data.docTooltip); 
            }.bind(editor), 1000);
            
          editor.__tooltipTimerCall();
        } else {
          editor.completer.showDocTooltip(data.docTooltip);
        }
      }
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
              completer = langTools.snippetCompleter;
              break;
            case 'text':
              completer = langTools.textCompleter;
              break;
            case 'keyword':
              completer = langTools.keyWordCompleter;
              break;
            case 'static':
              completer = staticCompleter;
              break;
            case 'rlang':
              completer = rlangCompleter;
              // add a keybind for "smart" tab - using tab for both indentation 
              // and autocompletion triggering, specific to R object names
              editor.commands.addCommand({
                name: 'rlang_smartTab',
                bindKey: { win: 'Tab', mac: 'TAB' },
                multiSelectAction: 'forEach',
                exec: function(editor) {
                  var selection = editor.session.getTextRange();
                  var range = editor.selection.getRange();
                  var imax = editor.session.getLength() - range.end.row;
                
                  //// use regular indent whenever cursor is anything but standard
                  if (selection !== '' || editor.inMultiSelectMode) {
                    editor.indent();
                    
                  // otherwise see if autocompletion should be triggered
                  } else {
                    var linebuffer = editor.session.getLine(range.start.row).slice(0, range.start.column);
                  
                    // if at the start of an object name or function call, kick off autocompletion
                    if (/[a-zA-Z._][a-zA-Z0-9._:]*$/.test(linebuffer) || /[a-zA-Z0-9._]\([^)]*$/.test(linebuffer)) {
                      if (editor.completer) editor.completer.detach();
                      editor.execCommand('startAutocomplete');
                    
                    // otherwise do an indentation
                    } else {
                      editor.indent();
                    }
                  }
                }
              });
              break;
          }
          
          // to each completer, add getDocTooltip callback to R
          if (!completer.hasOwnProperty("getDocTooltip")) {
            completer.getDocTooltip = function(item) {
              Shiny.onInputChange(data.id + '_shinyAce_tooltipItem', item);
            };
          }
          
          editor.completers.push(completer);
        });
      }
    }

    if (data.hasOwnProperty('autoCompleteList')) {
      $(el).data('auto-complete-list', data.autoCompleteList);
    }

    if (data.hasOwnProperty("setBehavioursEnabled") && data.setBehavioursEnabled === false) {
      editor.setBehavioursEnabled(data.setBehavioursEnabled);
    }
    
    // if (data.hasOwnProperty("codeCompletions")) {
    //   var callback = $(el).data('autoCompleteCallback');
    //   if (callback !== undefined) callback(null, data.codeCompletions);
    // }

    // this is a bit r-specific, perhaps there's a better way to only link it 
    // to the rlang completer?
    if (data.hasOwnProperty("codeCompletions")) {
      var callback = $(el).data('autoCompleteCallback');
      data.codeCompletions = data.codeCompletions.map(function(completion) {
        if (typeof completion.completer == "string") {
          switch (completion.completer) {
            case 'rlang': 
              completion.completer = {};
              completion.completer.insertMatch = r_insertMatch;
              break;
          }
        }
        return completion;
      });
      
      if (callback !== undefined) callback(null, data.codeCompletions);
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
    find: function(scope) {
      return $(scope).find(".shiny-ace");
    },
    initialize: function (el) {
      var scriptData = document.querySelector("script[data-for='" + el.id + "'][type='application/json']");
      if (scriptData) {
        var data = JSON.parse(scriptData.textContent);
        updateEditor(el, data);
      }
    },
    getValue: function(el) {
      return($(el).data('aceEditor').getValue());
    },
    setValue: function(el, value) {
      //TODO
    },
    subscribe: function(el, callback) {
      var editor = $(el).data('aceEditor');
      
      $(el).data('aceChangeCallback', function(e) {
        callback(true);
        
        // always clear annotation at current line on edit
        var cp = editor.getCursorPosition();
        editor.getSession().setAnnotations(
          editor.getSession().getAnnotations().filter(
            a => !(a.row === cp.row && a.type === 'error')));
        
        // only trigger syntax parsing if idle for some time
        if (editor.__annotationTimerCall)
          editor.__annotationTimerCall.cancel();
        
        editor.__annotationTimerCall = lang.delayedCall(
          function() { 
            Shiny.onInputChange(
              this.attr('id') + '_shinyAce_annotationTrigger', 
              Math.random());
          }.bind($(el)), 1000);
        editor.__annotationTimerCall();
      });
            
      $(el).data('aceEditor').getSession().addEventListener("change",
        $(el).data('aceChangeCallback')
      );
    },
    unsubscribe: function(el) {
      $(el).data('aceEditor').getSession().removeEventListener("change", 
        $(el).data('aceChangeCallback'));
    }, 
    getRatePolicy: function(el){
      return ({policy: 'debounce', delay: $(el).data('debounce') || 1000 });
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
