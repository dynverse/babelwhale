# babelwhale 1.1.0

* NEW FUNCTIONALITY `run_auto_mount()`: Added helper function for letting `babelwhale` figure out which directories to mount automatically (#26, thanks @joelnitta!).


## Test environments
* local installation, R release
* ubuntu (on github actions), R release
* ubuntu (on github actions), R devel
* win-builder (via devtools), R release
* win-builder (via devtools), R devel

## R CMD check results
```
> revdepcheck::revdep_check(timeout = as.difftime(600, units = "mins"), num_workers = 30)
── INIT ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── Computing revdeps ──
── INSTALL ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 2 versions ──
Installing CRAN version of babelwhale
also installing the dependencies ‘glue’, ‘fansi’, ‘pkgconfig’, ‘ellipsis’, ‘cli’, ‘utf8’, ‘rprojroot’, ‘RcppParallel’, ‘RcppArmadillo’, ‘generics’, ‘lifecycle’, ‘R6’, ‘rlang’, ‘tibble’, ‘tidyselect’, ‘vctrs’, ‘pillar’, ‘assertthat’, ‘desc’, ‘proxyC’, ‘Rcpp’, ‘remotes’, ‘ps’, ‘crayon’, ‘dplyr’, ‘dynutils’, ‘processx’, ‘purrr’

Installing DEV version of babelwhale
Installing 32 packages: stringi, magrittr, glue, rlang, RcppArmadillo, RcppParallel, Rcpp, purrr, ellipsis, pkgconfig, utf8, fansi, cli, pillar, vctrs, tidyselect, tibble, R6, lifecycle, generics, rprojroot, ps, remotes, proxyC, dplyr, desc, crayon, assertthat, digest, processx, dynutils, fs
── CHECK ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 1 packages ──
✔ dynwrap 1.2.2                          ── E: 1     | W: 0     | N: 0                                                                                 
OK: 1                                                                                                                                                
BROKEN: 0
Total time: 11 min
── REPORT ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Writing summary to 'revdep/README.md'
Writing problems to 'revdep/problems.md'
Writing failures to 'revdep/failures.md'
Writing CRAN report to 'revdep/cran.md'
```
