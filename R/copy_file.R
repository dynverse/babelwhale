#' Copy a file from a container to the host system
#'
#' @inheritParams run
#' @param path_container The path of the file inside the container
#' @param path_local The path of the file on the host system
#'
#' @export
#'
#' @importFrom utils tail
#' @importFrom dynutils safe_tempdir
#'
#' @examples
#' if (test_docker_installation()) {
#'   set_default_config(create_docker_config(), permanent = FALSE)
#'   copy_file("alpine", "/bin/date", tempfile())
#' }
copy_file <- function(
  container_id,
  path_container,
  path_local
) {
  config <- get_default_config()

  if (config$backend == "docker") {
    # start container
    output <- processx::run(
      "docker",
      c("create", "--entrypoint", "bash", container_id),
      stderr_callback = print_processx
    )
    id <- trimws(utils::tail(output$stdout, 1))

    # copy file from container
    processx::run(
      "docker",
      c("cp", paste0(id, ":", path_container), path_local),
      stderr_callback = print_processx
    )

    # remove container
    processx::run("docker", c("rm", id), stderr_callback = print_processx)

    invisible()
  } else if (config$backend == "singularity") {
    temp_folder <- dynutils::safe_tempdir("")
    on.exit(unlink(temp_folder, recursive = TRUE, force = TRUE))

    run(
      container_id = container_id,
      command = "cp",
      args = c(path_container, "/copy_mount"),
      volumes = paste0(temp_folder, ":/copy_mount")
    )

    file.copy(file.path(temp_folder, basename(path_container)), path_local)
  }
}
