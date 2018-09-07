detect_backend <- function() {
  witches <- Sys.which(c("docker", "singularity"))
  witches %>% keep(~ . != "") %>% names() %>% first()
}

#' Backend configuration for containerisation
#'
#' @param backend Which backend to use. Can be either `"docker"` or `"singularity"`.
#'   If the value of this parameter is not passed explicitly, the default is defined by
#'   the `"BABELWHALE_BACKEND"` environment variable, or otherwise just `"docker"`.
#' @param ... Parameters to pass to `create_docker_config()` or `create_singularity_config()`.
#'
#' @usage
#' create_config(
#'   backend =
#'     get_env_or_null("BABELWHALE_BACKEND") \%||\%
#'     "docker",
#'   ...
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
  backend = get_env_or_null("BABELWHALE_BACKEND") %||% detect_backend(),
  ...
) {
  backend <- match.arg(backend, choices = c("docker", "singularity"))

  switch(
    backend,
    docker = create_docker_config(...),
    singularity = create_singularity_config(...)
  )
}

#' @rdname create_config
#' @export
create_docker_config <- function() {
  list(backend = "docker") %>% dynutils::add_class("babelwhale::config")
}

#' @param cache_dir A folder in which to store the singularity images. Each TI method will require about 1GB of space.
#' @param prebuild If the singularity images are not prebuilt, they will need to be built every time a method is run.
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
