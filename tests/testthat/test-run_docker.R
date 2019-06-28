configs <- list(
  docker = create_docker_config(),
  singularity = create_singularity_config()
)

config <- configs[[1]]

for (config in configs) {
  context(paste0("Testing ", config$backend))

  set_default_config(config, permanent = FALSE)

  skip_on_appveyor()
  skip_on_travis_mac()
  skip_on_cran()

  if (config$backend == "singularity") skip_on_travis()

  test_that(paste0("babelwhale can run a ", config$backend), {
    output <- run("alpine", "echo", "hello")
    expect_equal(output$stdout, "hello\n")
    expect_equal(output$status, 0)
    expect_equal(output$stderr, "")
  })
}
