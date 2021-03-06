#' List docker containers
#'
#' @param container_id An optional container id
#'
#' @export
#'
#' @importFrom utils read.delim
#' @examples
#' if (test_docker_installation()) {
#'   set_default_config(create_docker_config(), permanent = FALSE)
#'   list_docker_images()
#' }
list_docker_images <- function(container_id = NULL) {
  columns <- c("ID", "Repository", "Tag", "Digest", "CreatedSince", "CreatedAt", "Size")
  format <- paste(paste0("{{.", columns, "}}"), collapse = "\t")
  stdout <- processx::run("docker", c("images", paste0("--format=", format), container_id), echo = FALSE)$stdout

  if (stdout != "") {
    df <- read.delim(text = stdout, sep = "\t", header = FALSE, stringsAsFactors = FALSE)
    colnames(df) <- columns
    df
  } else {
    map(columns, ~ character(0)) %>%
      set_names(columns) %>%
      as_tibble()
  }
}
