
# babelwhale: talk to docker and singularity from R

<!-- badges: start -->

[![R-CMD-check](https://github.com/dynverse/babelwhale/workflows/R-CMD-check/badge.svg)](https://github.com/dynverse/babelwhale/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/babelwhale)](https://cran.r-project.org/package=babelwhale)
[![Codecov test
coverage](https://codecov.io/gh/dynverse/babelwhale/branch/master/graph/badge.svg)](https://codecov.io/gh/dynverse/babelwhale?branch=master)
<!-- badges: end -->

Specify docker or singularity

``` r
library(babelwhale)
config <- create_docker_config()
set_default_config(config)
```

Run a command in a container

``` r
run("alpine", "echo", c("hello"))
```

    ## $status
    ## [1] 0
    ## 
    ## $stdout
    ## [1] "hello\n"
    ## 
    ## $stderr
    ## [1] ""
    ## 
    ## $timeout
    ## [1] FALSE

Get a file from a container

``` r
read_file("alpine", "/etc/alpine-release")
```

    ## [1] "3.13.5"

## Latest changes

Check out `news(package = "dynutils")` or [NEWS.md](NEWS.md) for a full
list of changes.

<!-- This section gets automatically generated from NEWS.md -->

### Recent changes in babelwhale 1.0.2

-   BUG FIX `test_docker_installation()`: Use `docker info` to check
    whether docker is available.

-   BUG FIX: Redirect stdout and stderr to files to avoid processx hangs
    (\#24, thanks @joelnitta!).

-   MINOR CHANGE: Change maintainer from Wouter to Robrecht.

### Recent changes in babelwhale 1.0.1 (03-10-2019)

-   BUG FIX `set_config_default()`: Fixed refactoring error; use
    `saveRDS` instead of `save`.
