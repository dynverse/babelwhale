context("Testing test_docker_installation")

test_that("Testing that test_docker_installation works", {
  skip_on_github_actions()
  skip_on_cran()

  expect_true(test_docker_installation())
  expect_message(test_docker_installation(detailed = TRUE), "\u2714.*")
})
