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
    if (!el){
      console.log("Using an older version of Shiny, so unable to set the debounce rate policy.");
      return(null);
    }
    return ({policy: 'debounce', delay: $(el).data('debounce') || 1000 });
  }
});

Shiny.inputBindings.register(shinyAceInputBinding);


var langTools = ace.require("ace/ext/language_tools");
var staticCompleter = {
  getCompletions: function(editor, session, pos, prefix, callback) {
        //if (prefix.length === 0) { callback(null, []); return }
        var comps = $('#' + editor.container.id).data('autoCompleteList');
        if(comps){
          var words = [];
          
          Object.keys(comps).forEach(function(key) {
            words = words.concat(comps[key].map(function(d){
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
        //if (prefix.length === 0) { callback(null, []); return }
        var inputId = editor.container.id;
        Shiny.onInputChange('shinyAce_' + inputId + '_hint', {
          linebuffer: session.getLine(pos.row),
          cursorPosition: pos.column
        });
        //store callback for dynamic completion
        $('#' + inputId).data('autoCompleteCallback', callback);
    }
};
langTools.addCompleter(rlangCompleter);
})();

var HighlightedLines=[];

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
  
  if (data.value){
    editor.getSession().setValue(data.value, -1);
  }
  
  if (data.hasOwnProperty('readOnly')){
    editor.setReadOnly(data.readOnly);
  }
  
  if (data.fontSize){
    document.getElementById(id).style.fontSize = data.fontSize + 'px';
  }
  
  if (data.hasOwnProperty('wordWrap')){
    editor.getSession().setUseWrapMode(data.wordWrap);
  }
  
  if (data.border){
    var classes = ['acenormal', 'aceflash', 'acealert'];
    $el.removeClass(classes.join(' '));
    $el.addClass(data.border);
  }
  
  if (data.autoComplete){
    var value = data.autoComplete;
    editor.setOption('enableLiveAutocompletion', value === 'live');
    editor.setOption('enableBasicAutocompletion', value !== 'disabled');
  }
  
  if (data.hasOwnProperty('autoCompleteList')){
    $el.data('autoCompleteList', data.autoCompleteList);
  }
  
  if (data.codeCompletions) {
    var words = data.codeCompletions.split(/[ ,]+/).map(function(e) {
      return {name: e, value: e, meta: 'R'};
    });
    var callback = $el.data('autoCompleteCallback');
    if(callback !== undefined) callback(null, words);
  }
  
  if (data.cursorPos){
    var res = data.cursorPos.split(",");
    var row = Number(res[0]);
    var col = Number(res[1]);
    editor.navigateTo(row, col );
  } 
  
  if (data.highlightRange){ 
    var highlightRows = data.highlightRange.split(",");
    var row1 = highlightRows[0]; 
    var row2 = highlightRows[1]; 
    var Range = ace.require("ace/range").Range;
    var highlightLine = editor.session.addMarker(new Range(row1, 0, row2, 1), 
      'ace_highlight-marker', 'fullLine');
    HighlightedLines.push(highlightLine); 
  } 
  
  if(data.clearHighlights ){
    while(HighlightedLines.length>0){
      var highlightedLine = HighlightedLines.pop();
      editor.getSession().removeMarker(highlightedLine);
    }
  }
  
  
  
});