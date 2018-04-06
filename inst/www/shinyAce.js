(function(){

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
      $(el).data('aceChangeCallback', function(e) {
        callback(true);
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

  var langTools = ace.require("ace/ext/language_tools");
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
    // TODO: add option to include optional getDocTooltip for suggestion context 
  };
  langTools.addCompleter(rlangCompleter);

  Shiny.addCustomMessageHandler('shinyAce', function(data) {
    var id = data.id;
    var $el = $('#' + id);
    var editor = $el.data('aceEditor');
    
    if (data.theme){
      editor.setTheme("ace/theme/" + data.theme);
    }
    
    if (data.mode){
      editor.getSession().setMode("ace/mode/" + data.mode);
    }
    
    if (data.value !== undefined){
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
      if(callback !== undefined) callback(null, data.codeCompletions);
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