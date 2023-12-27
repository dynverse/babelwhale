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
    local_sif_path <- Sys.getenv("LOCAL_SIF_PATH")
    container_sif <- paste0(local_sif_path, "/", gsub("[/,:]", "_", container_id), ".sif")
    if (!file.exists(container_sif)) {
      processx::run("singularity", c("pull", container_sif, paste0("docker://", container_id)), echo_cmd = TRUE, echo = FALSE)  
    }
  }

  return(TRUE)
}
