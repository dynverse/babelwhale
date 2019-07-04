detect_backend <- function() {
  witches <- Sys.which(c("docker", "singularity"))
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
#' @usage
#' create_config(
#'   backend =
#'     get_env_or_null("BABELWHALE_BACKEND") \%||\%
#'     detect_backend()
#' )
#'
#' @examples
#' config <- create_docker_config()
#' set_default_config(config, permanent = FALSE)
#'
#' config <- create_singularity_config(
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
#' @export
create_docker_config <- function() {
  list(backend = "docker")
}

#' @param cache_dir A folder in which to store the singularity images. A container typically requires 100MB to 2GB.
#'
#' @usage
#' create_singularity_config(
#'   cache_dir =
#'     get_env_or_null("SINGULARITY_CACHEDIR") \%||\%
#'     ".singularity/"
#' )
#'
#' @rdname create_config
#' @export
create_singularity_config <- function(
  cache_dir = get_env_or_null("SINGULARITY_CACHEDIR") %||% ".singularity/"
) {
  dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  lst(
    backend = "singularity",
    cache_dir
  )
}
