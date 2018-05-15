## Resubmission

This is a resubmission. The new maintainer of the shinyAce package is Vincent Nijs (radiant@rady.ucsd.edu). In this version several bugs have been fixed and some new features have been added (see NEWS.md for details). 

## Test environments

* local macOS install, R 3.5.0
* local Windows install, R 3.5.0
* ubuntu on travis-ci, R release and devel
* win-builder

## R CMD check results

There were no ERRORs or WARNINGs. There were 2 NOTEs however. The first is about the maintainer change. The second is about the size of the www sub-directory and the resulting installed package size (7.6MB). This is due to the size of the JavaScript [Ace](https://github.com/ajaxorg) library shinyAce provides an interface for.

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Vincent Nijs <radiant@rady.ucsd.edu>'

New maintainer:
  Vincent Nijs <radiant@rady.ucsd.edu>
Old maintainer(s):
  Jeff Allen <cran@trestletechnology.net>

* checking installed package size ... NOTE
  installed size is  7.6Mb
  sub-directories of 1Mb or more:
    www   7.5Mb

## Reverse dependencies

A reverse decency check using `devtools::revdep_check()` produced no errors or notes. It did, however, produce the warning below for the shinyjs package. The warning does not seem to be related to shinyAce however, as confirmed in an email exchange with the author of the shinyjs package.

checking re-building of vignette outputs ... WARNING
Error in re-building vignettes:
  ...
pandoc: Could not fetch https://www.r-pkg.org/badges/version/shinyjs
TlsExceptionHostPort (HandshakeFailed Error_EOF) "www.r-pkg.org" 443
Error: processing vignette 'shinyjs.Rmd' failed with diagnostics:
pandoc document conversion failed with error 67
Execution halted
