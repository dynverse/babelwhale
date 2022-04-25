configs <- list(
  docker = create_docker_config(),
  singularity = create_singularity_config(cache_dir = tempdir())
)

config <- configs[[1]]

for (config in configs) {
  context(paste0("Testing ", config$backend))

  set_default_config(config, permanent = FALSE)

  skip_on_cran()
  skip_on_github_actions()

  test_that(paste0("run_auto_mount can mount files on ", config$backend), {
    # warm up
    output <- run("alpine", "echo", "hello")

    output <-
      run_auto_mount(
        container_id = "alpine",
        command = "cat",
        args = c(file = system.file("DESCRIPTION", package = "babelwhale")
        )
      )
    expect_equal(
      strsplit(output$stdout, "\n", fixed = TRUE)[[1]][[1]],
      "Package: babelwhale" # first line of DESCRIPTION
    )
    expect_equal(output$status, 0)

  })

  test_that(paste0("run_auto_mount wd arg works on ", config$backend), {
    output <-
      run_auto_mount(
        container_id = "alpine",
        command = "ls",
        wd = system.file(package = "babelwhale")
      )
    expect_match(
      output$stdout,
      "DESCRIPTION" # should be a DESCRIPTION file in babelwhale package dir
    )
    expect_equal(output$status, 0)
  })

  test_that(paste0("run_auto_mount wd_in_container arg works on ", config$backend), {
    output <-
      run_auto_mount(
        container_id = "alpine",
        command = "pwd",
        wd_in_container = "/bin"
      )
    expect_equal(
      output$stdout,
      "/bin\n"
    )
    expect_equal(output$status, 0)
  })

}
