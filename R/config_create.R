detect_backend <- function() {
  witches <- Sys.which(c("docker", "singularity"))
  witches %>% keep(~ . != "") %>% names() %>% first()
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
#'     "docker"
#' )
#'
#' @examples
#' \dontrun{
#' config <- create_docker_config()
#' set_default_config(config)
#'
#' config <- create_singularity_config(
#'   cache_dir = "~/babelwhale_singularity_images/"
#' )
#' set_default_config(config)
#' }
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
  list(backend = "docker") %>% dynutils::add_class("babelwhale::config")
}

#' @param cache_dir A folder in which to store the singularity images. Each TI method will require about 1GB of space.
#' @param prebuild If the singularity images are not cached, they will need to be downloaded every time a method is run.
#'
#' @usage
#' create_singularity_config(
#'   cache_dir =
#'     get_env_or_null("SINGULARITY_CACHEDIR") \%||\%
#'     "./",
#'   use_cache = cache_dir != "./"
#' )
#'
#' @rdname create_config
#' @export
create_singularity_config <- function(
  cache_dir = get_env_or_null("SINGULARITY_CACHEDIR") %||% "./",
  use_cache = cache_dir != "./"
) {
  if (use_cache && cache_dir == "./") {
    warning(
      "No singularity cache directory specified, will use the working directory.\n",
      "Check `?create_singularity_config` for more information on how to define the cache directory."
    )
  }

  lst(
    backend = "singularity",
    use_cache,
    cache_dir
  ) %>%
    dynutils::add_class("babelwhale::config")
}
