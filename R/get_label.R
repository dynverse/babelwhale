#' Inspect a container and return a label
#'
#' @inheritParams run
#' @param label_name The name of the label to return
#'
#' @importFrom jsonlite fromJSON
#'
#' @export
get_label <- function(container_id, label_name) {
  config <- get_default_config()

  if (config$backend == "docker") {
    result <- processx::run("docker", c("inspect", "--type=image", container_id, paste0("--format='{{ index .Config.Labels \"", tolower(label_name), "\" }}'")), error_on_status = FALSE, echo = FALSE)

    # check whether image is available locally
    if (result$status > 0) {
      NA
    } else {
      result$stdout %>%
        stringr::str_replace_all("['\\n]", "")
    }
  } else if (config$backend == "singularity") {
    simg_location <- singularity_image_path(container_id)

    # check whether image is available locally
    if (!file.exists(simg_location)) {
      NA
    } else {
      result <- processx::run("singularity", c("inspect", simg_location), error_on_status = FALSE)
      if (result$status > 0) {
        warning(paste0(result$stdout, "\n", result$stderr))
        NA
      } else {
        jsonlite::fromJSON(result$stdout, simplifyVector = TRUE)[[toupper(label_name)]]
      }
    }
  }
}
