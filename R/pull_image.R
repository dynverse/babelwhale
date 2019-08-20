#' Pull a container from dockerhub
#'
#' @inheritParams run
#'
#' @examples
#' if (test_docker_installation()) {
#'   pull_container("alpine")
#' }
#' @export
pull_container <- function(container_id) {
  config <- get_default_config()

  if (config$backend == "docker") {
    processx::run("docker", c("pull", container_id), echo = TRUE)

  } else if (config$backend == "singularity") {
    processx::run("singularity", c("exec", paste0("docker://", container_id), "echo", "hi"), echo_cmd = TRUE, echo = FALSE)
  }

  return(TRUE)
}
