shinyAce 0.4.4
--------------------------------------------------------------------

* Accepted a pull request to address a [security issue](https://github.com/trestletech/shinyAce/pull/88)

shinyAce 0.4.3
--------------------------------------------------------------------

* Addressed documentation issue identified by CRAN

shinyAce 0.4.2
--------------------------------------------------------------------

* Addressed documentation issue identified by CRAN

shinyAce 0.4.1
--------------------------------------------------------------------

* @dgkf provided a PR with improvements to rlang autocompletion, tooltips & annotations [PR66](https://github.com/trestletech/shinyAce/pull/66)

shinyAce 0.4.0
--------------------------------------------------------------------

* Refactor of JS code to provide better support for use with Shiny modules (@detule). These (breaking) changes were made to work with shiny modules and make the javascript in the package more easily maintainable and extensible. If you use "selectionID" or "cursorID" in calls to "aceEditor", note that to access the information in these input you must now prepend the "outputId" of the ace editor element. For example, if outputId = "myeditor" and selectionId = "myselection" you can now access the selection information using "myeditor_myselection". FYI This is the same approach used in the DT package on CRAN. The same naming convention applies to hotkeys.  For example, if outputId = "myeditor" and hotkeys = list(help_key = "F1") you can now access information related to the key press using "myeditor_help_key". See README.md at https://github.com/trestletech/shinyAce for an overview of updated examples
* Option to add a placeholder to be shown when the editor is empty (see placeholder argument for aceEditor, @vnijs)
* Option to add JS code to "jump" through code using hotkeys (see code_hotkeys argument for aceEditor, @vnijs)
* Arguments `autoScrollEditorIntoView`, `maxLines`, and `minLines` added that allow the editor window to resize as extra lines are added by the user. The editor size starts at `minLines` and will not expand beyond `maxLines`. See `inst/examples/08-resize` for an example (@vnijs)

shinyAce 0.3.4
--------------------------------------------------------------------

* Downgrade R version requirement [@yonicd](https://github.com/trestletech/shinyAce/issues/61) 

shinyAce 0.3.3
--------------------------------------------------------------------

* Enhanced keyboard shortcuts to execute code blocks by jumping to matching bracket using CTRL-enter (CMD-enter on macOS) (@vnijs)
* Arguments `autoScrollEditorIntoView`, `maxLines`, and `minLines` added that allow the editor window to resize as extra lines are added by the user. The editor size starts at `minLines` and will not expand beyond `maxLines`. See `inst/examples/08-resize` for an example (@vnijs)

shinyAce 0.3.2
--------------------------------------------------------------------

* Using `selectionId` in the call to `shinyAce::aceEditor` can cause javascript errors (@laderast)

shinyAce 0.3.1
--------------------------------------------------------------------

* Keyboard shortcuts for to execute code blocks, code chunks, and equations in display form using CTRL-enter (CMD-enter on macOS)

* Added options to set tab size (tabSize), replace tabs by spaces (useSoftTabs), and show invisible characters (showInvisibles). See 

* Upgrade to Ace 1.3.0 (https://github.com/ajaxorg/ace-builds/releases)

* Allow toggling of search-replace using CMD-f (CTRL-f on Windows). See https://github.com/ajaxorg/ace/issues/3552)

* Clear editor using "" (@dmenne #30)

* Fix when ace is initialized with \r or \f (@The-Dub #46)

* Fix for auto complete in shiny modules (@GregorDeCillia #47 and [PR54](https://github.com/trestletech/shinyAce/pull/54))

Note: This fix required a breaking change (i.e., the `aceAutocomplete` function now uses `inputid_shinAce_hint` rather than the the old `shinyAce_inputid_hint`)

* Fix for auto complete lists (@Ping2016 #48 and @saurfang  ([PR52](https://github.com/trestletech/shinyAce/pull/52))

* Improved configuration options for auto completers by @saurfang ([PR53]https://github.com/trestletech/shinyAce/pull/53))


shinyAce 0.2.0
--------------------------------------------------------------------

* Upgrade to Ace 1.1.8

* Add code autocompletion (@saurfang, #21)


shinyAce 0.1.1
--------------------------------------------------------------------

* Added input debouncing

* Add shortcut and cursor listeners (@skranz, #16)

* Added word wrapping (@ncarchedi, #12)

* Added vim key bindings (@vnijs, #9)


shinyAce 0.1.0
--------------------------------------------------------------------

* Initial release
