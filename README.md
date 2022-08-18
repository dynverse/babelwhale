
# babelwhale: talk to docker and singularity from R

<!-- badges: start -->

[![R-CMD-check](https://github.com/dynverse/babelwhale/workflows/R-CMD-check/badge.svg)](https://github.com/dynverse/babelwhale/actions)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/babelwhale)](https://cran.r-project.org/package=babelwhale)
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

    ## [1] "3.16.2"

## Latest changes

Check out `news(package = "dynutils")` or [NEWS.md](NEWS.md) for a full
list of changes.

<!-- This section gets automatically generated from NEWS.md -->

### Recent changes in babelwhale 1.1.0

-   NEW FUNCTIONALITY `run_auto_mount()`: Added helper function for
    letting `babelwhale` figure out which directories to mount
    automatically (#26, thanks @joelnitta!).

### Recent changes in babelwhale 1.0.3

-   BUG FIX `detect_backend()`: Print helpful message when neither
    docker or singularity are installed (Thanks @KforKuma).
