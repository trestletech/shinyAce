shinyAce
==========

[![Build Status](https://travis-ci.org/trestletech/shinyAce.svg?branch=master)](https://travis-ci.org/trestletech/shinyAce)

The `shinyAce` package enables Shiny application developers to use the 
[Ace text editor](http://ace.c9.io/#nav=about) in their applications. All
current modes (languages) and themes are supported in this package. The 
mode, theme, and current text can be defined when the element is initialized 
in `ui.R` or afterwards using the `updateAceEditor()` function. The editor
registers itself as a reactive Shiny input, so the current value of the
editor can easily be pulled from `server.R` using `input$yourEditorsName`.

![shinyAce](http://trestletech.github.io/shinyAce/images/shinyAce.png)

Or view an [interactive example](https://starkingdom.shinyapps.io/shinyAce-01-basic/).

Installation
------------

shinyAce is available [on CRAN](https://cran.r-project.org/package=shinyAce), so installation is as simple as:

```
install.packages("shinyAce")
```

You can install the latest development version of the code using the `devtools` R package.

```
# Install devtools, if you haven't already.
install.packages("devtools")

library(devtools)
install_github("trestletech/shinyAce")
```

## Getting Started

Various examples are available in the [`inst/examples`](https://github.com/trestletech/shinyAce/tree/master/inst/examples) directory included in the package. A few examples are described below. (Note that the package must be installed before you can run any examples.)

### 01-basic ([Live Demo](https://starkingdom.shinyapps.io/shinyAce-01-basic/))

Run example: `library(shiny); runApp(system.file("examples/01-basic", package="shinyAce"));`

![shinyAce](http://trestletech.github.io/shinyAce/images/shinyAce.png)

Demonstrates the basic capabilities of shinyAce including the ability to set an initial value, or interactively assign a value, theme, or mode later on in the session.

### 02-eval

Run example: `library(shiny); runApp(system.file("examples/02-eval", package="shinyAce"));`

![shinyAce](http://trestletech.github.io/shinyAce/images/shinyAce-eval.png)

Shows an example of using shinyAce to allow the user to compose R code which will then be evaluated on the server.

### 03-knitr

Run example: `library(shiny); runApp(system.file("examples/03-knitr", package="shinyAce"));`

![shinyAce](http://trestletech.github.io/shinyAce/images/shinyAce-knitr.png)

Demonstrates integrating shinyAce with the [knitR](http://yihui.name/knitr/) package. (Note also that an example of this integration is available [in the knitR package](https://github.com/yihui/knitr/tree/master/inst/shiny) itself and includes features such as R syntax highlighting.)

### 04-shinyui

Run example: `library(shiny); runApp(system.file("examples/04-shinyui", package="shinyAce"));`

![shinyAce](http://trestletech.github.io/shinyAce/images/shinyAce-renderui.png)

Demonstrates using shinyAce to allow a user to create a Shiny UI within Shiny itself. The UI can then be rendered on the right half of the page. Could be a great learning tool for teaching how to construct Shiny UIs.

### 05-hotkeys ([Live Demo](https://trestletech.shinyapps.io/shinyAce5/))

Run example: `library(shiny); runApp(system.file("examples/05-hotkeys", package="shinyAce"));`

An example using the `hotkeys` feature of ShinyAce to allow application developers to expose keyboard shortcuts to their users. 

### 06-autocomplete ([Live Demo](https://trestletech.shinyapps.io/shinyAce6/))

Run example: `library(shiny); runApp(system.file("examples/06-autocomplete", package="shinyAce"));`

An example using the `autocomplete` feature of ShinyAce to enable Ace to suggest completions as the user types.

### Security Note

As with any online application, it is a **genuinely bad idea** to allow arbitrary users to execute code on your server. The above examples show such an environment in which arbitrary R code is being executed on a remote machine. In a trusted environment (such as after authenticating a user or on a network protected by a firewall), this may not be a terrible idea; on a public server without authentication, it most certainly is. So please use the above examples with caution, realizing that without proper security checks in place, allowing unknown users to execute arbitrary R code would make it trivial for an attacker to compromise your server or steal your private data.

Contributors (In order of first commit)
---------------------------------------

 - [Jeff Allen](https://github.com/trestletech) - Core project
 - [Vincent Nijs](https://github.com/vnijs) - Vim key bindings, keyboard shortcuts to run code chunks, expanded access to various Ace editor options, package maintenance ([#9](https://github.com/trestletech/shinyAce/pull/9), [#35](https://github.com/trestletech/shinyAce/pull/35), [#51](https://github.com/trestletech/shinyAce/pull/51))
 - [Nick Carchedi](https://github.com/ncarchedi) - Word wrapping ([#12](https://github.com/trestletech/shinyAce/pull/12))
 - [Sebastian Kranz](https://github.com/skranz) - Hotkey feature and cursor listener ([#16](https://github.com/trestletech/shinyAce/pull/16/files))
 - [Forest Fang](https://github.com/saurfang) - Code completion ([#21](https://github.com/trestletech/shinyAce/pull/21), [#52](https://github.com/trestletech/shinyAce/pull/52),  [#53](https://github.com/trestletech/shinyAce/pull/53)) 
  - [Gregor De Cillia](https://github.com/GregorDeCillia) - Auto completion with shiny modules ([#54](https://github.com/trestletech/shinyAce/pull/54))


Known Bugs
----------

See the [Issues page](https://github.com/trestletech/shinyAce/issues) for
information on outstanding issues. 

License
-------

The development of this project was generously sponsored by the [Institut de 
Radioprotection et de Sûreté Nucléaire](http://www.irsn.fr/EN/Pages/home.aspx) 
and performed by [Jeff Allen](http://trestletech.com). The code is
licensed under The MIT License (MIT).

Copyright (c) 2013 Institut de Radioprotection et de Sûreté Nucléaire

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
