#' @importFrom jsonlite write_json
pull_image <- function(image) {
  config <- get_default_config()

  if (config$type == "docker") {
    processx::run("docker", c("pull", image), echo = TRUE)

  } else if (config$type == "singularity") {
    image_location <- singularity_image_path(config, image)
    image_folder <- dirname(image_location)
    image_file <- basename(image_location)

    # create directory if not present yet
    if (!file.exists(image_folder)) dir.create(image_folder, recursive = TRUE)

    tempcache <- create_concurrent_dir(cachedir = image_folder)
    on.exit(finalise_concurrent_dir(tempcache, cachedir = image_folder))

    # pull container
    processx::run(
      command = "singularity",
      args = c("pull", "--name", image_file, paste0("shub://", image)),
      env = c("SINGULARITY_CACHEDIR" = tempcache),
      echo = TRUE
    )
  }
}
