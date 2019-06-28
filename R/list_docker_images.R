#' List docker containers
#'
#' @param container_id An optional container id
#'
#' @export
#'
#' @examples
#' if (test_docker_installation()) {
#'   set_default_config(create_docker_config(), permanent = FALSE)
#'   list_docker_images()
#' }
#'
#' @importFrom readr read_tsv cols
list_docker_images <- function(container_id = NULL) {
  columns <- c("ID", "Repository", "Tag", "Digest", "CreatedSince", "CreatedAt", "Size")
  format <- paste0("{{.", columns, "}}") %>% paste(collapse = "\t")
  stdout <- processx::run("docker", c("images", paste0("--format=", format), container_id), echo = FALSE) %>%
    .$stdout

  if (stdout != "") {
    readr::read_tsv(
      stdout,
      col_names = columns,
      col_types = readr::cols(.default = "c")
    )
  } else {
    map(columns, ~ character(0)) %>%
      set_names(columns) %>%
      as_tibble()
  }
}
