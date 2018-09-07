#' Backend configuration for containerisation
#'
#' @param type Which backend to use. Can be either `"docker"` or `"singularity"`.
#'   If the value of this parameter is not passed explicitly, the default is defined by
#'   the `"BABELWHALE_RUN_ENVIRONMENT"` environment variable, or otherwise just `"docker"`.
#' @param ... Parameters to pass to `create_docker_config()` or `create_singularity_config()`.
#'
#' @usage
#' create_config(
#'   type =
#'     get_env_or_null("DYNWRAP_RUN_ENVIRONMENT") \%||\%
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
#'   images_folder = "~/dynwrap_singularity_images/"
#' )
#' set_default_config(config)
#' }
#'
#' @export
create_config <- function(
  type = get_env_or_null("DYNWRAP_RUN_ENVIRONMENT") %||% "docker",
  ...
) {

  if (!type %in% c("docker", "singularity")) {
    stop("Container type must be either \"docker\" or \"singularity\"")
  }

  switch(
    type,
    docker = create_docker_config(...),
    singularity = create_singularity_config(...)
  )
}

#' @rdname create_config
#' @export
create_docker_config <- function() {
  list(type = "docker") %>% dynutils::add_class("babelwhale::config")
}

#' @param prebuild If the singularity images are not prebuilt, they will need to be built every time a method is run.
#' @param images_folder A folder in which to store the singularity images. Each TI method will require about 1GB of space.
#'
#' @usage
#' create_singularity_config(
#'   images_folder =
#'     get_env_or_null("DYNWRAP_SINGULARITY_IMAGES_FOLDER") \%||\%
#'     "./",
#'   prebuild = images_folder != "./"
#' )
#'
#' @rdname create_config
#' @export
create_singularity_config <- function(
  images_folder = get_env_or_null("DYNWRAP_SINGULARITY_IMAGES_FOLDER") %||% "./",
  prebuild = images_folder != "./"
) {
  if (prebuild && images_folder == "./") {
    warning(
      "No singularity images folder specified, will use the working directory.\n",
      "Check `?singularity` for more information on how to define the images folder."
    )
  }

  lst(
    type = "singularity",
    prebuild,
    images_folder
  ) %>%
    dynutils::add_class("babelwhale::config")
}
