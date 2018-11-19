context("Testing print_processx")

test_that("print_processx works correctly", {
  expect_output(print_processx("Quinoa"), regexp = "Quinoa")
  expect_output(print_processx("Edamame"), regexp = "Edamame")
})
