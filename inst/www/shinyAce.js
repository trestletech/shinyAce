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
      callback();
    });
    
    $(el).data('aceEditor').getSession().addEventListener("change", 
        $(el).data('aceChangeCallback') 
    );
  },
  unsubscribe: function(el) {
    $(el).data('aceEditor').getSession().removeEventListener("change", 
        $(el).data('aceChangeCallback'));
  }
});

Shiny.inputBindings.register(shinyAceInputBinding);
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
  
  if (Object.prototype.hasOwnProperty.call(data, 'readOnly')){
    editor.setReadOnly(data.readOnly);
  }
  
  if (data.fontSize){
    document.getElementById(id).style.fontSize = data.fontSize + 'px';
  }
});