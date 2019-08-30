// code jumping for R and Rmarkdown files
function code_jump(editor, range, imax) {
    var i = 1;
    var line = editor.session.getLine(range.end.row);
    var next_line = editor.session.getLine(range.end.row + i);

    if (/^```\{.*\}\s*$/.test(line)) {
        // code chunk in Rmd document
        while (/\n```\s*$/.test(line) === false & i < imax + 1) {
            i++;
            line = line.concat('\n', next_line);
            next_line = editor.session.getLine(range.end.row + i);
        }
        if (i === imax + 1) {
            line = '<h4>Code chunk not properly closed. Code chunks must end in &#96 &#96 &#96</h4>';
        }
    } else if (/^\$\$\s*$/.test(line)) {
        // equation in Rmd document
        while (/\n\$\$\s*$/.test(line) === false & i < imax + 1) {
            i++;
            line = line.concat('\n', next_line);
            next_line = editor.session.getLine(range.end.row + i);
        }
        if (i === imax + 1) {
            line = '<h4>Equation not properly closed. Display equations must start and end with $$</h4>';
        }
    } else if (/(\(|\{|\[)\s*$/.test(line)) {
        // jump to matching bracket
        editor.navigateLineEnd();
        editor.jumpToMatching();
        match_line = editor.selection.getCursor();
        if (match_line.row === range.end.row) {
            line = '#### Bracket not properly closed. Fix and try again';
        } else {
            line = editor.session.getLines(range.end.row, match_line.row).join('\n');
            i = match_line.row - range.end.row + 1
        }
    } else {
        // for pipes and ggplot type continuation
        rexpr = /(%>%|\+|\-|\,)\s*$/;
        rxeval = rexpr.test(line);
        while ((rxeval | /^\s*(\#|$)/.test(next_line)) & i < imax) {
            rxeval = rexpr.test(line);
            if (rxeval | /^\s*(\}|\))/.test(next_line)) {
                line = line.concat('\n', next_line);
            }
            i++;
            next_line = editor.session.getLine(range.end.row + i);
        }
    }
    editor.gotoLine(range.end.row + i + 1);
    if (line === '') {
        line = ' ';  // ensure whole report is not rendered
    }
    return (line)
};
