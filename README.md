
# babelwhale: talk to docker and singularity from R

[![](https://travis-ci.org/dynverse/babelwhale.svg?branch=master)](https://travis-ci.org/dynverse/babelwhale)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/babelwhale)](https://cran.r-project.org/package=babelwhale)
[![](https://codecov.io/gh/dynverse/babelwhale/branch/master/graph/badge.svg)](https://codecov.io/gh/dynverse/babelwhale)

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

    ## [1] "3.10.2"

## Latest changes

Check out `news(package = "dynutils")` or [NEWS.md](NEWS.md) for a full
list of changes.

<!-- This section gets automatically generated from NEWS.md -->

### Recent changes in babelwhale 1.0.1

  - Fix issue with permanent saving of config.

### Recent changes in babelwhale 1.0.0 (28-06-2019)

  - Release of babelwhale, a package to run docker and singularity
    containers from R.
