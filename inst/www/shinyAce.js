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
          cursorPosition: pos.column,
          // nonce causes autcomplement event to trigger
          // on R side even if Ctrl-Space is pressed twice
          // with the same linebuffer and cursorPosition
          nonce: Math.random() 
        });
        //store callback for dynamic completion
        $('#' + inputId).data('autoCompleteCallback', callback);
    }
};
langTools.addCompleter(rlangCompleter);
})();

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
    //editor.setOption("behavioursEnabled", true);
  }
  
  if(data.behaviours){
    //var value = data.autoComplete;
    editor.setOption("behavioursEnabled", data.behaviours==='enable');
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
  
  // STARTING EDITING HERE
  if (data.cursorPos){
    var res = data.cursorPos.split(",");
    var row = Number(res[0]);
    var col = Number(res[1]);
    editor.navigateTo(row, col );
  } 
  
  
  if(data.clearHighlights){
    //var HighlightedLines=editor.getSession().$backMarkers;
    var clearLines=data.clearHighlights;
    //console.log( HighlightedLines );
    while(clearLines.length>0){
      var cline = clearLines.pop();
      // NEED TO CHANGE THIS APPROACH, SHOULD TRY TO USE 
      // EditSession.getMarkers(Boolean inFront) INSTEAD 
      // FOR REMOVING MARKERS
      
      editor.getSession().removeMarker(cline);
    }      
  }
  
  if(data.clearAllHighlights){
    var HighlightedLines=editor.getSession().getMarkers(true)
    //$backMarkers;
    //var clearLines=data.clearHighlights;
    console.log( HighlightedLines );
    while(HighlightedLines.length>0){
      var cline = HighlightedLines.pop();
      console.log(cline);
      // NEED TO CHANGE THIS APPROACH, SHOULD TRY TO USE 
      // EditSession.getMarkers(Boolean inFront) INSTEAD 
      // FOR REMOVING MARKERS
      
      //editor.getSession().removeMarker(cline);
    }      
  }
  
  if(data.removeMarkers){
    var markers = editor.getSession().getMarkers(false);
    for (var idm in markers) {
      // All language analysis' markers are prefixed with language_highlight
      if (markers[id].clazz.indexOf('language_highlight_') === 0) {
          session.removeMarker(id);
        }
      }
    //  for (var i = 0; i < session.markerAnchors.length; i++) {
    //      session.markerAnchors[i].detach();
    //  }
    //  session.markerAnchors = [];
  }

  
    
  if ( data.highlight ){
    var highlightRows = data.highlight;
    var row1 = highlightRows[0]; 
    var row2 = highlightRows[1]; 
    var Range = ace.require("ace/range").Range;
    var highlightLine = 
       editor.session.addMarker(new Range(row1, 0, row2, 1), 
      'ace_highlight-marker', 
      'fullLine');
    //alert(highlightLine);
    //HighlightedLines.push(highlightLine); 
    // NEED TO CHANGE THIS APPROACH, SHOULD TRY TO USE 
    // EditSession.getMarkers(Boolean inFront) INSTEAD 
    // FOR REMOVING MARKERS
    Shiny.onInputChange("mydata", highlightLine);
  } 
  // END EDITING HERE

});