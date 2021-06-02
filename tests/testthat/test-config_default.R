context("Testing config_default")

test_that("Testing that config_default functions work", {
  skip_on_github_actions()
  skip_on_cran()

  docker_config <- create_docker_config()
  set_default_config(docker_config, permanent = FALSE)
  expect_equal(getOption("babelwhale_config"), docker_config)

  singularity_config <- create_singularity_config(cache_dir = tempdir())
  set_default_config(singularity_config, permanent = FALSE)
  expect_equal(getOption("babelwhale_config"), singularity_config)

  set_default_config(NULL, permanent = FALSE)
  expect_null(getOption("babelwhale_config"))

  orig_config <- get_default_config()
  on.exit({
    set_default_config(orig_config, permanent = TRUE)
  })

  set_default_config(docker_config, permanent = TRUE)
  expect_equal(get_default_config(), docker_config)

  set_default_config(singularity_config, permanent = TRUE)
  expect_equal(get_default_config(), singularity_config)
})
