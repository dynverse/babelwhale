# travis osx docker not supported https://github.com/travis-ci/travis-ci/issues/5738
skip_on_travis_mac <- function() {
  skip_if(Sys.getenv("TRAVIS") == "true" && "darwin" %in% tolower(Sys.info()[["sysname"]]))
}
skip_on_github_actions <- function() {
  skip_if(Sys.getenv("GA_OS") == "MacOSX")
}
