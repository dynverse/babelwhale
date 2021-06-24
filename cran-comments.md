# babelwhale 1.0.2

* BUG FIX `test_docker_installation()`: Use `docker info` to check whether docker is available.

* BUG FIX: Redirect stdout and stderr to files to avoid processx hangs (#24, thanks @joelnitta!).

* MINOR CHANGE: Change maintainer from Wouter to Robrecht.

## Test environments
* local Fedora 30 installation, R 4.0
* ubuntu (on github actions), R 4.0
* win-builder (via devtools), R release
* win-builder (via devtools), R devel

## R CMD check results
```
> revdepcheck::revdep_check(timeout = as.difftime(600, units = "mins"), num_workers = 30)
── INIT ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── Computing revdeps ──
── INSTALL ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 2 versions ──
Installing CRAN version of babelwhale
also installing the dependencies ‘fansi’, ‘pkgconfig’, ‘cli’, ‘utf8’, ‘rprojroot’, ‘RcppParallel’, ‘RcppArmadillo’, ‘stringi’, ‘ellipsis’, ‘generics’, ‘glue’, ‘lifecycle’, ‘magrittr’, ‘R6’, ‘rlang’, ‘tibble’, ‘tidyselect’, ‘vctrs’, ‘pillar’, ‘assertthat’, ‘desc’, ‘proxyC’, ‘Rcpp’, ‘remotes’, ‘stringr’, ‘ps’, ‘crayon’, ‘dplyr’, ‘dynutils’, ‘processx’, ‘purrr’

Installing DEV version of babelwhale
Installing 31 packages: stringi, magrittr, glue, rlang, RcppArmadillo, RcppParallel, Rcpp, purrr, pkgconfig, utf8, fansi, crayon, cli, pillar, vctrs, tidyselect, tibble, R6, lifecycle, generics, ellipsis, rprojroot, ps, stringr, remotes, proxyC, dplyr, desc, assertthat, processx, dynutils
── CHECK ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 1 packages ──
✓ dynwrap 1.2.2                          ── E: 1     | W: 0     | N: 0                                                                                                                                                                             
OK: 1                                                                                                                                                                                                                                            
BROKEN: 0
Total time: 12 min
── REPORT ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Writing summary to 'revdep/README.md'
Writing problems to 'revdep/problems.md'
Writing failures to 'revdep/failures.md'
Writing CRAN report to 'revdep/cran.md'
```
