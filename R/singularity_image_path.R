#' Determine the cached path of singularity images
#'
#' @inheritParams run
singularity_image_path <- function(container_id) {
  config <- get_default_config()

  path <-
    container_id %>%
    gsub("@sha256:", "_hash-", .) %>%
    gsub(":", "_tag-", .) %>%
    paste0(config$cache_dir, ., ".simg") %>%
    normalizePath(mustWork = FALSE)

  dir.create(gsub("[^/]*.simg$", "", path), recursive = TRUE, showWarnings = FALSE)

  path
}

#' @examples
#' singularity_image_path("dynverse/dynwrap@sha256:3456789iuhijkm")
#' singularity_image_path("dynverse/dynwrap:r")
#' singularity_image_path("dynverse/dynwrap")
