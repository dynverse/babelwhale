detect_backend <- function() {
  witches <- Sys.which(c("docker", "singularity"))
  if (all(witches == "")) {
    stop(
      "Couldn't detect docker or singularity. Are you sure either is installed?\n",
      "Please run `test_docker_installation(detailed = TRUE)` or `test_singularity_installation(detailed = TRUE)` to verify."
    )
  }
  witches %>% keep(function(x) x != "") %>% names() %>% first()
}

#' @title Backend configuration for containerisation
#'
#' @description
#' It is advised to define the `"BABELWHALE_BACKEND"` environment variable as `"docker"` or `"singularity"`.
#'
#' When using singularity, also define the `"SINGULARITY_CACHEDIR"` environment variable,
#' which is the folder where the singularity images will be cached.
#'  Each TI method will require about 1GB of space.
#'
#' Alternatively, you can create a config and save it using `set_default_config()`.
#'
#' @param backend Which backend to use. Can be either `"docker"` or `"singularity"`.
#'
#' @examples
#' config <- create_docker_config()
#' set_default_config(config, permanent = FALSE)
#'
#' config <- create_singularity_config(
#'   # ideally, this would be set to a non-temporary directory
#'   cache_dir = tempdir()
#' )
#' set_default_config(config, permanent = FALSE)
#'
#' @export
create_config <- function(
  backend = get_env_or_null("BABELWHALE_BACKEND") %||% detect_backend()
) {
  backend <- match.arg(backend, choices = c("docker", "singularity"))

  switch(
    backend,
    docker = create_docker_config(),
    singularity = create_singularity_config()
  )
}

#' @rdname create_config
#' @param environment_variables A character vector of environment variables. Format: `c("ENVVAR=VALUE")`.
#' @export
create_docker_config <- function(environment_variables = character(0)) {
  list(backend = "docker", environment_variables = environment_variables)
}

#' @param cache_dir A folder in which to store the singularity images. A container typically requires 100MB to 2GB.
#' @rdname create_config
#' @export
create_singularity_config <- function(
  cache_dir = get_env_or_null("SINGULARITY_CACHEDIR") %||% ".singularity/",
  environment_variables = character(0)
) {
  dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  list(
    backend = "singularity",
    cache_dir = cache_dir,
    environment_variables = environment_variables
  )
}
