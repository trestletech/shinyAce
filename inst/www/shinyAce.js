(function() {
  
  var lang = ace.require("ace/lib/lang");
  var langTools = ace.require("ace/ext/language_tools");
  
  var shinyAceInputBinding = new Shiny.InputBinding();
  $.extend(shinyAceInputBinding, {
    find: function(scope) {
      return $(scope).find(".shiny-ace");
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
            console.log("here");
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

  var staticCompleter = {
    getCompletions: function(editor, session, pos, prefix, callback) {
      var comps = $('#' + editor.container.id).data('auto-complete-list');
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
    },
    getDocTooltip: function(item) {
      Shiny.onInputChange(item.inputId + '_shinyAce_tooltipItem', item);
    }
  };
  langTools.addCompleter(rlangCompleter);

  Shiny.addCustomMessageHandler('shinyAce', function(data) {
    var id = data.id;
    var $el = $('#' + id);
    var editor = $el.data('aceEditor');
    
    if (data.theme) {
      editor.setTheme("ace/theme/" + data.theme);
    }
    
    if (data.mode) {
      editor.getSession().setMode("ace/mode/" + data.mode);
    }
    
    if (data.value !== undefined) {
      editor.getSession().setValue(data.value, -1);
    }
    
    if (data.hasOwnProperty('readOnly')) {
      editor.setReadOnly(data.readOnly);
    }
    
    if (data.fontSize) {
      document.getElementById(id).style.fontSize = data.fontSize + 'px';
    }
    
    if (data.hasOwnProperty('wordWrap')) {
      editor.getSession().setUseWrapMode(data.wordWrap);
    }
    
    if (data.border) {
      var classes = ['acenormal', 'aceflash', 'acealert'];
      $el.removeClass(classes.join(' '));
      $el.addClass(data.border);
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
    
    if (data.autoComplete) {
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
        completers.forEach(function(completer) {
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
    
    if (data.tabSize) {
      editor.setOption('tabSize', data.tabSize);
    } 
    
    if (data.useSoftTabs === false) {
      editor.setOption('useSoftTabs', false);
    } else if (data.useSoftTabs === true) {
      editor.setOption('useSoftTabs', true);
    }
   
    if (data.showInvisibles === true) {
      editor.setOption('showInvisibles', true);
    } else if (data.showInvisibles === false) {
      editor.setOption('showInvisibles', false);
    }
    
    if (data.hasOwnProperty('autoCompleteList')) {
      $el.data('auto-complete-list', data.autoCompleteList);
    }
    
    if (data.codeCompletions) {
      var callback = $el.data('autoCompleteCallback');
      
      data.codeCompletions = data.codeCompletions.map(function(completion) {
        completion.completer = {};
        completion.completer.insertMatch = function(editor, data) {
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
            var re_match = remainder.match(/(^[a-zA-Z0-9._:]*)((?:\(\)?)?)(.*)/);
            if (re_match) {
              // remove word that we're clobbering
              editor.getSession().getDocument().removeInLine(
                cursor.row, cursor.column, cursor.column + re_match[1].length);
                
              // if function call, delete parens and navigate into existing call
              if (insertString.endsWith("()") && re_match[2].length) {
                editor.getSession().getDocument().removeInLine(
                  cursor.row, cursor.column - 2, cursor.column);
                editor.navigateRight(1);
              }
              
            } else if (insertString.endsWith("()")) {
              // navigate backwards into ()'s for function completions
              editor.navigateLeft(1);
            }
            
          }
        };
        return completion;
      });
      
      if (callback !== undefined) callback(null, data.codeCompletions);
    }
  });

  // Allow toggle of the search-replace box in Ace
  // see https://github.com/ajaxorg/ace/issues/3552
  var toggle_search_replace = ace.require("ace/ext/searchbox").SearchBox.prototype.$searchBarKb.bindKey( "Ctrl-f|Command-f|Ctrl-H|Command-Option-F", function(sb) {
    var isReplace = sb.isReplace = !sb.isReplace;
    sb.replaceBox.style.display = isReplace ? "" : "none";
    sb[isReplace ? "replaceInput" : "searchInput"].focus();
  });

})();