configs <- list(
  docker = create_docker_config(),
  singularity = create_singularity_config(cache_dir = tempdir())
)

config <- configs[[2]]

for (config in configs) {
  context(paste0("Testing ", config$backend))

  set_default_config(config, permanent = FALSE)

  skip_on_appveyor()
  skip_on_travis_mac()
  skip_on_cran()

  if (config$backend == "singularity") skip_on_travis()

  test_that(paste0("babelwhale can copy and read a file from ", config$backend), {
    dest <- tempfile()
    copy_file("alpine", "/etc/inittab", dest)
    expect_true(file.exists(dest))

    hosts <- read_file("alpine", "/etc/inittab")
    expect_equal(hosts[1], "# /etc/inittab")
  })
}
