#' @importFrom stringr str_replace_all str_replace
singularity_image_path <- function(container_id) {
  config <- get_default_config()

  path <-
    container_id %>%
    stringr::str_replace_all("@sha256:", "_hash-") %>%
    stringr::str_replace_all(":", "_tag-") %>%
    paste0(config$cache_dir, ., ".simg") %>%
    normalizePath(mustWork = FALSE)

  dir.create(stringr::str_replace(path, "[^/]*.simg$", ""), recursive = TRUE, showWarnings = FALSE)

  path
}

#' @examples
#' singularity_image_path("dynverse/dynwrap@sha256:3456789iuhijkm")
#' singularity_image_path("dynverse/dynwrap:r")
#' singularity_image_path("dynverse/dynwrap")
