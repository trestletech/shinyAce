(function(){
  
var shinyAceOutputBinding = new Shiny.OutputBinding();
$.extend(shinyAceOutputBinding, {
  find: function(scope) {
    return $(scope).find('.shiny-ace');
  },
  renderValue: function(el, value) {
    if (!value){
      return;
    }
    
    $(el).data('aceEditor').setValue(value);
  }
});
Shiny.outputBindings.register(shinyAceOutputBinding, 'shinyAce.aceBinding');

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