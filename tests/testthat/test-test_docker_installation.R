context("Testing test_docker_installation")

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
