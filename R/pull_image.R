#' Pull a container from dockerhub or singularityhub
#'
#' @inheritParams run
#'
#' @importFrom jsonlite write_json
#'
#' @export
pull_container <- function(container_id) {
  config <- get_default_config()

  if (config$backend == "docker") {
    processx::run("docker", c("pull", container_id), echo = TRUE)

  } else if (config$backend == "singularity") {
    image_location <- singularity_image_path(container_id)
    image_folder <- dirname(image_location)
    image_file <- basename(image_location)

    # create directory if not present yet
    if (!file.exists(image_folder)) dir.create(image_folder, recursive = TRUE)

    tempcache <- create_concurrent_dir(dest_dir = image_folder)
    on.exit(finalise_concurrent_dir(temp_dir = tempcache, dest_dir = image_folder))

    # pull container
    processx::run(
      command = "singularity",
      args = c("pull",paste0("shub://", container_id)),
      env = c("SINGULARITY_CACHEDIR" = tempcache, Sys.getenv()),
      wd = tempcache,
      echo = TRUE
    )
  }

  return(TRUE)
}
