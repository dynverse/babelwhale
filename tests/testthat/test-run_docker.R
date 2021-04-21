configs <- list(
  docker = create_docker_config(),
  singularity = create_singularity_config(cache_dir = tempdir())
)

config <- configs[[2]]

for (config in configs) {
  context(paste0("Testing ", config$backend))

  set_default_config(config, permanent = FALSE)

  skip_on_cran()
  skip_on_github_actions()

  test_that(paste0("babelwhale can run a ", config$backend), {
    # warm up
    output <- run("alpine", "echo", "hello")

    output <- run("alpine", "echo", "hello")
    expect_equal(output$stdout, "hello\n")
    expect_equal(output$status, 0)

    stderr <- output$stderr
    if (stderr != "") {
      stderr <- stderr %>% strsplit("\n") %>% .[!grepl("^INFO: ", .)]
    } else {
      stderr <- c()
    }

    expect_true(length(stderr) == 0)
  })
}
