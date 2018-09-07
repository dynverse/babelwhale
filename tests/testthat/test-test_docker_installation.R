context("Testing test_docker_installation")

# travis osx docker not supported https://github.com/travis-ci/travis-ci/issues/5738
skip_on_travis_mac <- function() {
  skip_if(Sys.getenv("TRAVIS") == "true" && "darwin" %in% tolower(Sys.info()[["sysname"]]))
}

test_that("Testing that test_docker_installation works", {
  skip_on_appveyor()
  skip_on_travis_mac()
  skip_on_cran()

  expect_true(test_docker_installation())
  expect_message(test_docker_installation(detailed = TRUE), "\u2714.*")
})

test_that("Testing that test_docker_installation fails when on windows on appveyor", {
  skip_if_not(Sys.getenv("APPVEYOR") == "True")

  expect_error(test_docker_installation(detailed = TRUE))
})
