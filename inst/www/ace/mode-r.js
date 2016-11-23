ace.define("ace/mode/tex_highlight_rules",
   ["require","exports","module","ace/lib/oop","ace/lib/lang","ace/mode/text_highlight_rules"],
   function(e,t,n){
     "use strict";
     var r=e("../lib/oop"),
     i=e("../lib/lang"),
     s=e("./text_highlight_rules").TextHighlightRules,
     o=function(e){e||(e="text"),
        this.$rules={
          start:[
            {token:"comment",regex:"%.*$"},
            {token:e,regex:"\\\\[$&%#\\{\\}]"},
            {token:"keyword",
              regex:"\\\\(?:documentclass|usepackage|newcounter|setcounter|addtocounter|value|arabic|stepcounter|newenvironment|renewenvironment|ref|vref|eqref|pageref|label|cite[a-zA-Z]*|tag|begin|end|bibitem)\\b"
              ,
              next:"nospell"
            },
            {token:"keyword",regex:"\\\\(?:[a-zA-z0-9]+|[^a-zA-z0-9])"},
            {token:"paren.keyword.operator",regex:"[[({]"},
            {token:"paren.keyword.operator",regex:"[\\])}]"},
            {token:e,regex:"\\s+"}
          ],
          nospell:[
            {token:"comment",regex:"%.*$",next:"start"},
            {token:"nospell."+e,regex:"\\\\[$&%#\\{\\}]"},
            {token:"keyword",regex:"\\\\(?:documentclass|usepackage|newcounter|setcounter|addtocounter|value|arabic|stepcounter|newenvironment|renewenvironment|ref|vref|eqref|pageref|label|cite[a-zA-Z]*|tag|begin|end|bibitem)\\b"},
            {token:"keyword",regex:"\\\\(?:[a-zA-z0-9]+|[^a-zA-z0-9])",next:"start"},
            {token:"paren.keyword.operator",regex:"[[({]"},
            {token:"paren.keyword.operator",regex:"[\\])]"},
            {token:"paren.keyword.operator",regex:"}",next:"start"},
            {token:"nospell."+e,regex:"\\s+"},
            {token:"nospell."+e,regex:"\\w+"}
          ]
        } //endof this.rules
    } //endof o fn
    ; // bad semicolon????
    r.inherits(o,s),
    t.TexHighlightRules=o
  } //endof function(e,t,n)
), //endof ace.define("ace/mode/tex_highlight_rules"

ace.define(
  "ace/mode/r_highlight_rules",
  ["require","exports","module","ace/lib/oop","ace/lib/lang","ace/mode/text_highlight_rules","ace/mode/tex_highlight_rules"],
  function(e,t,n){
    var 
    r=e("../lib/oop"),
    i=e("../lib/lang"),
    s=e("./text_highlight_rules").TextHighlightRules,
    o=e("./tex_highlight_rules").TexHighlightRules,
    u=function(){
      var 
        e=i.arrayToMap("function|if|in|break|next|repeat|else|for|return|switch|while|try|tryCatch|stop|warning|require|library|attach|detach|source|setMethod|setGeneric|setGroupGeneric|setClass".split("|")),
        t=i.arrayToMap("NULL|NA|TRUE|FALSE|T|F|Inf|NaN|NA_integer_|NA_real_|NA_character_|NA_complex_".split("|") ),
        svgRAN=i.arrayToMap("animate|animateColor|animateMotion|animateTransform|set".split("|")),
        svgRME=i.arrayToMap("desc|metadata|title".split("|")),
        svgRFE=i.arrayToMap("feBlend|feColorMatrix|feComponentTransfer|feComposite|feConvolveMatrix|feDiffuseLighting|feDisplacementMap|feFlood|feGaussianBlur|feImage|feMerge|feMorphology|feOffset|feSpecularLighting|feTile|feTurbulence".split("|")),
        svgRGR=i.arrayToMap("linearGradient|radialGradient".split("|")),
        svgRSH=i.arrayToMap("circle|ellipse|line|path|polygon|polyline|rect".split("|")),
        svgRCO=i.arrayToMap("ptR|tagR|svg|svgR|defs|g|Merge|symbol|use".split("|")),
        svgRTX=i.arrayToMap("altGlyph|textPath|tref|tspan|text".split("|")),
        svgRFI=i.arrayToMap("filter".split("|")),
        svgRMM=i.arrayToMap("mask|marker".split("|"))
      ;
      this.$rules={
        start:[
          {token:"comment.sectionhead",regex:"#+(?!').*(?:----|====|####)\\s*$"},
          {token:"comment",regex:"#+'",next:"rd-start"},
          {token:"comment",regex:"#.*$"},
          {token:"string",regex:'["]',next:"qqstring"},
          {token:"string",regex:"[']",next:"qstring"},
          {token:"constant.numeric",regex:"0[xX][0-9a-fA-F]+[Li]?\\b"},
          {token:"constant.numeric",regex:"\\d+L\\b"},
          {token:"constant.numeric",regex:"\\d+(?:\\.\\d*)?(?:[eE][+\\-]?\\d*)?i?\\b"},
          {token:"constant.numeric",regex:"\\.\\d+(?:[eE][+\\-]?\\d*)?i?\\b"},
          {token:"constant.language.boolean",regex:"(?:TRUE|FALSE|T|F)\\b"},
          {token:"identifier",regex:"`.*?`"},
          {onMatch:
            function(n){
              return e[n]?"keyword":t[n]?"constant.language":
              svgRAN[n]?".bold.italic.svgRAN":
              svgRME[n]?".bold.italic.svgRME":
              svgRFE[n]?".bold.italic.svgRFE":
              svgRGR[n]?".bold.italic.svgRGR":
              svgRSH[n]?".bold.italic.svgRSH":
              svgRCO[n]?".bold.italic.svgRCO":
              svgRTX[n]?".bold.italic.svgRTX":
              svgRFI[n]?".bold.italic.svgRFI":
              svgRMM[n]?".bold.italic.svgRMM":
              n=="..."||n.match(/^\.\.\d+$/)?"variable.language":"identifier"
            },
            regex:"[a-zA-Z.][a-zA-Z0-9._]*\\b"
          }, //onMatch
          {
            token:"keyword.operator",regex:"%%|>=|<=|==|!=|\\->|<\\-|\\|\\||&&|=|\\+|\\-|\\*|/|\\^|>|<|!|&|\\||~|\\$|:"
          },
          {token:"keyword.operator",regex:"%.*?%"},{token:"paren.keyword.operator",regex:"[[({]"},
          {token:"paren.keyword.operator",regex:"[\\])}]"},
          {token:"text",regex:"\\s+"}
        ],  //endof start:
        qqstring:[
          {token:"string",regex:'(?:(?:\\\\.)|(?:[^"\\\\]))*?"',next:"start"},
          {token:"string",regex:".+"}
        ],
        qstring:[
          {token:"string",regex:"(?:(?:\\\\.)|(?:[^'\\\\]))*?'",next:"start"},
          {token:"string",regex:".+"}
        ]
      } //endof this.$rules
      ;
      var n=(new o("comment")).getRules();
      for(var r=0;r<n.start.length;r++)
        n.start[r].token+=".virtual-comment";
      this.addRules(n,"rd-"),
      this.$rules["rd-start"].unshift({token:"text",regex:"^",next:"start"}),
      this.$rules["rd-start"].unshift({token:"keyword",regex:"@(?!@)[^ ]*"}),
        this.$rules["rd-start"].unshift({token:"comment",regex:"@@"}),
        this.$rules["rd-start"].push({token:"comment",regex:"[^%\\\\[({\\])}]+"})
    } //endof u=function()
    ;
    r.inherits(u,s),
    t.RHighlightRules=u
  } //endof function(e,t,n)
), // endof ace.define("ace/mode/r_highlight_rules"

ace.define(
  "ace/mode/matching_brace_outdent",
  ["require","exports","module","ace/range"],
  function(e,t,n){
    "use strict";
    var r=e("../range").Range,i=function(){};
    (
      function(){
      this.checkOutdent=function(e,t){
        return/^\s+$/.test(e)?/^\s*\}/.test(t):!1
      },
      this.autoOutdent=function(e,t){
       var n=e.getLine(t),
       i=n.match(/^(\s*\})/);
       if(!i)
         return 0;
       var s=i[1].length,
       o=e.findMatchingBracket({row:t,column:s});
       if(!o||o.row==t)
         return 0;
       var u=this.$getIndent(e.getLine(o.row));
       e.replace(new r(t,0,t,s-1),u)
    },
    this.$getIndent=function(e){
      return e.match(/^\s*/)[0]
    }
  }
).call(i.prototype),
    t.MatchingBraceOutdent=i}
), //endof ace.define "ace/mode/matching_brace_outdent"

ace.define("ace/mode/behaviour/cstyle",["require","exports","module","ace/lib/oop","ace/mode/behaviour","ace/token_iterator","ace/lib/lang"],function(e,t,n){"use strict";var r=e("../../lib/oop"),i=e("../behaviour").Behaviour,s=e("../../token_iterator").TokenIterator,o=e("../../lib/lang"),u=["text","paren.rparen","punctuation.operator"],a=["text","paren.rparen","punctuation.operator","comment"],f,l={},c=function(e){var t=-1;e.multiSelect&&(t=e.selection.index,l.rangeCount!=e.multiSelect.rangeCount&&(l={rangeCount:e.multiSelect.rangeCount}));if(l[t])return f=l[t];f=l[t]={autoInsertedBrackets:0,autoInsertedRow:-1,autoInsertedLineEnd:"",maybeInsertedBrackets:0,maybeInsertedRow:-1,maybeInsertedLineStart:"",maybeInsertedLineEnd:""}},h=function(){this.add("braces","insertion",function(e,t,n,r,i){var s=n.getCursorPosition(),u=r.doc.getLine(s.row);if(i=="{"){c(n);var a=n.getSelectionRange(),l=r.doc.getTextRange(a);if(l!==""&&l!=="{"&&n.getWrapBehavioursEnabled())return{text:"{"+l+"}",selection:!1};if(h.isSaneInsertion(n,r))return/[\]\}\)]/.test(u[s.column])||n.inMultiSelectMode?(h.recordAutoInsert(n,r,"}"),{text:"{}",selection:[1,1]}):(h.recordMaybeInsert(n,r,"{"),{text:"{",selection:[1,1]})}else if(i=="}"){c(n);var p=u.substring(s.column,s.column+1);if(p=="}"){var d=r.$findOpeningBracket("}",{column:s.column+1,row:s.row});if(d!==null&&h.isAutoInsertedClosing(s,u,i))return h.popAutoInsertedClosing(),{text:"",selection:[1,1]}}}else{if(i=="\n"||i=="\r\n"){c(n);var v="";h.isMaybeInsertedClosing(s,u)&&(v=o.stringRepeat("}",f.maybeInsertedBrackets),h.clearMaybeInsertedClosing());var p=u.substring(s.column,s.column+1);if(p==="}"){var m=r.findMatchingBracket({row:s.row,column:s.column+1},"}");if(!m)return null;var g=this.$getIndent(r.getLine(m.row))}else{if(!v){h.clearMaybeInsertedClosing();return}var g=this.$getIndent(u)}var y=g+r.getTabString();return{text:"\n"+y+"\n"+g+v,selection:[1,y.length,1,y.length]}}h.clearMaybeInsertedClosing()}}),this.add("braces","deletion",function(e,t,n,r,i){var s=r.doc.getTextRange(i);if(!i.isMultiLine()&&s=="{"){c(n);var o=r.doc.getLine(i.start.row),u=o.substring(i.end.column,i.end.column+1);if(u=="}")return i.end.column++,i;f.maybeInsertedBrackets--}}),this.add("parens","insertion",function(e,t,n,r,i){if(i=="("){c(n);var s=n.getSelectionRange(),o=r.doc.getTextRange(s);if(o!==""&&n.getWrapBehavioursEnabled())return{text:"("+o+")",selection:!1};if(h.isSaneInsertion(n,r))return h.recordAutoInsert(n,r,")"),{text:"()",selection:[1,1]}}else if(i==")"){c(n);var u=n.getCursorPosition(),a=r.doc.getLine(u.row),f=a.substring(u.column,u.column+1);if(f==")"){var l=r.$findOpeningBracket(")",{column:u.column+1,row:u.row});if(l!==null&&h.isAutoInsertedClosing(u,a,i))return h.popAutoInsertedClosing(),{text:"",selection:[1,1]}}}}),this.add("parens","deletion",function(e,t,n,r,i){var s=r.doc.getTextRange(i);if(!i.isMultiLine()&&s=="("){c(n);var o=r.doc.getLine(i.start.row),u=o.substring(i.start.column+1,i.start.column+2);if(u==")")return i.end.column++,i}}),this.add("brackets","insertion",function(e,t,n,r,i){if(i=="["){c(n);var s=n.getSelectionRange(),o=r.doc.getTextRange(s);if(o!==""&&n.getWrapBehavioursEnabled())return{text:"["+o+"]",selection:!1};if(h.isSaneInsertion(n,r))return h.recordAutoInsert(n,r,"]"),{text:"[]",selection:[1,1]}}else if(i=="]"){c(n);var u=n.getCursorPosition(),a=r.doc.getLine(u.row),f=a.substring(u.column,u.column+1);if(f=="]"){var l=r.$findOpeningBracket("]",{column:u.column+1,row:u.row});if(l!==null&&h.isAutoInsertedClosing(u,a,i))return h.popAutoInsertedClosing(),{text:"",selection:[1,1]}}}}),this.add("brackets","deletion",function(e,t,n,r,i){var s=r.doc.getTextRange(i);if(!i.isMultiLine()&&s=="["){c(n);var o=r.doc.getLine(i.start.row),u=o.substring(i.start.column+1,i.start.column+2);if(u=="]")return i.end.column++,i}}),this.add("string_dquotes","insertion",function(e,t,n,r,i){if(i=='"'||i=="'"){c(n);var s=i,o=n.getSelectionRange(),u=r.doc.getTextRange(o);if(u!==""&&u!=="'"&&u!='"'&&n.getWrapBehavioursEnabled())return{text:s+u+s,selection:!1};var a=n.getCursorPosition(),f=r.doc.getLine(a.row),l=f.substring(a.column-1,a.column);if(l=="\\")return null;var p=r.getTokens(o.start.row),d=0,v,m=-1;for(var g=0;g<p.length;g++){v=p[g],v.type=="string"?m=-1:m<0&&(m=v.value.indexOf(s));if(v.value.length+d>o.start.column)break;d+=p[g].value.length}if(!v||m<0&&v.type!=="comment"&&(v.type!=="string"||o.start.column!==v.value.length+d-1&&v.value.lastIndexOf(s)===v.value.length-1)){if(!h.isSaneInsertion(n,r))return;return{text:s+s,selection:[1,1]}}if(v&&v.type==="string"){var y=f.substring(a.column,a.column+1);if(y==s)return{text:"",selection:[1,1]}}}}),this.add("string_dquotes","deletion",function(e,t,n,r,i){var s=r.doc.getTextRange(i);if(!i.isMultiLine()&&(s=='"'||s=="'")){c(n);var o=r.doc.getLine(i.start.row),u=o.substring(i.start.column+1,i.start.column+2);if(u==s)return i.end.column++,i}})};h.isSaneInsertion=function(e,t){var n=e.getCursorPosition(),r=new s(t,n.row,n.column);if(!this.$matchTokenType(r.getCurrentToken()||"text",u)){var i=new s(t,n.row,n.column+1);if(!this.$matchTokenType(i.getCurrentToken()||"text",u))return!1}return r.stepForward(),r.getCurrentTokenRow()!==n.row||this.$matchTokenType(r.getCurrentToken()||"text",a)},h.$matchTokenType=function(e,t){return t.indexOf(e.type||e)>-1},h.recordAutoInsert=function(e,t,n){var r=e.getCursorPosition(),i=t.doc.getLine(r.row);this.isAutoInsertedClosing(r,i,f.autoInsertedLineEnd[0])||(f.autoInsertedBrackets=0),f.autoInsertedRow=r.row,f.autoInsertedLineEnd=n+i.substr(r.column),f.autoInsertedBrackets++},h.recordMaybeInsert=function(e,t,n){var r=e.getCursorPosition(),i=t.doc.getLine(r.row);this.isMaybeInsertedClosing(r,i)||(f.maybeInsertedBrackets=0),f.maybeInsertedRow=r.row,f.maybeInsertedLineStart=i.substr(0,r.column)+n,f.maybeInsertedLineEnd=i.substr(r.column),f.maybeInsertedBrackets++},h.isAutoInsertedClosing=function(e,t,n){return f.autoInsertedBrackets>0&&e.row===f.autoInsertedRow&&n===f.autoInsertedLineEnd[0]&&t.substr(e.column)===f.autoInsertedLineEnd},h.isMaybeInsertedClosing=function(e,t){return f.maybeInsertedBrackets>0&&e.row===f.maybeInsertedRow&&t.substr(e.column)===f.maybeInsertedLineEnd&&t.substr(0,e.column)==f.maybeInsertedLineStart},h.popAutoInsertedClosing=function(){f.autoInsertedLineEnd=f.autoInsertedLineEnd.substr(1),f.autoInsertedBrackets--},h.clearMaybeInsertedClosing=function(){f&&(f.maybeInsertedBrackets=0,f.maybeInsertedRow=-1)},r.inherits(h,i),t.CstyleBehaviour=h}),

ace.define("ace/mode/folding/cstyle",["require","exports","module","ace/lib/oop","ace/range","ace/mode/folding/fold_mode"],function(e,t,n){"use strict";var r=e("../../lib/oop"),i=e("../../range").Range,s=e("./fold_mode").FoldMode,o=t.FoldMode=function(e){e&&(this.foldingStartMarker=new RegExp(this.foldingStartMarker.source.replace(/\|[^|]*?$/,"|"+e.start)),this.foldingStopMarker=new RegExp(this.foldingStopMarker.source.replace(/\|[^|]*?$/,"|"+e.end)))};r.inherits(o,s),function(){this.foldingStartMarker=/(\{|\[)[^\}\]]*$|^\s*(\/\*)/,this.foldingStopMarker=/^[^\[\{]*(\}|\])|^[\s\*]*(\*\/)/,this.getFoldWidgetRange=function(e,t,n,r){var i=e.getLine(n),s=i.match(this.foldingStartMarker);if(s){var o=s.index;if(s[1])return this.openingBracketBlock(e,s[1],n,o);var u=e.getCommentFoldRange(n,o+s[0].length,1);return u&&!u.isMultiLine()&&(r?u=this.getSectionRange(e,n):t!="all"&&(u=null)),u}if(t==="markbegin")return;var s=i.match(this.foldingStopMarker);if(s){var o=s.index+s[0].length;return s[1]?this.closingBracketBlock(e,s[1],n,o):e.getCommentFoldRange(n,o,-1)}},this.getSectionRange=function(e,t){var n=e.getLine(t),r=n.search(/\S/),s=t,o=n.length;t+=1;var u=t,a=e.getLength();while(++t<a){n=e.getLine(t);var f=n.search(/\S/);if(f===-1)continue;if(r>f)break;var l=this.getFoldWidgetRange(e,"all",t);if(l){if(l.start.row<=s)break;if(l.isMultiLine())t=l.end.row;else if(r==f)break}u=t}return new i(s,o,u,e.getLine(u).length)}}.call(o.prototype)}),

ace.define(
  "ace/mode/r",
  ["require","exports","module","ace/range","ace/lib/oop",
  "ace/mode/text","ace/mode/text_highlight_rules","ace/mode/r_highlight_rules",
  "ace/mode/matching_brace_outdent","ace/unicode",
  "ace/mode/behaviour/cstyle","ace/mode/folding/cstyle"],
  function(e,t,n){
    "use strict";
    var 
      r=e("../range").Range, 
      i=e("../lib/oop"),
      s=e("./text").Mode,
      o=e("./text_highlight_rules").TextHighlightRules,
      u=e("./r_highlight_rules").RHighlightRules,
      a=e("./matching_brace_outdent").MatchingBraceOutdent,
      f=e("../unicode"),
      gg=e("./behaviour/cstyle").CstyleBehaviour,
      hh=e("./folding/cstyle").FoldMode,
      l=function(){
        this.HighlightRules=u,
        this.$outdent=new a,
        this.$behaviour=new gg,
        this.foldingRules=new hh
      }
    ;
    i.inherits(l,s),
    function(){
      this.lineCommentStart="#",
      this.$id="ace/mode/r"
    }.call(l.prototype),
    t.Mode=l
  } //endof function(e,t,n)
)