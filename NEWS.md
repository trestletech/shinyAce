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

* Added vim key bindings (@Vincent, #9)


shinyAce 0.1.0
--------------------------------------------------------------------

* Initial release
