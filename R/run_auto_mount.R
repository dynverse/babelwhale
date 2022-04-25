#' Run a containerised command with automatic mounting of files
#'
#' Similar to [run()], but automatically mounts files (and directories) so the
#' user doesn't have to keep track of volumes.
#'
#' The main difference to [run()] is that the use of names for the `args`; any
#' file (or directory) that should be mounted inside the container must be named
#' `file`. The other elements (arguments) don't need to be named. Note that it
#' is fine to have multiple elements with the same name (`file`).
#'
#' This should generally work as long as the command accepts absolute paths
#' for file input. If that is not the case, use [run()] instead and specify
#' paths and mounting manually.
#'
#' @inheritParams run
#' @param args Character vector, arguments to the command. Any files or
#'   directories that should be mounted must be named "file" (see example).
#' @param wd Local working directory to run command. If specified, the working
#'   directory will be mounted to the docker container.
#' @param wd_in_container Working directory to run command in
#'   the container. Defaults to the working directory mounted to the container
#'   (`wd`).
#'
#' @return List, formatted as output from [processx::run()]
#' @examples
#' if (test_docker_installation()) {
#'
#' # Count the number of lines in the DESCRIPTION and LICENSE
#' # files of this package
#' run_auto_mount(
#'   container_id = "alpine",
#'   command = "wc",
#'   args = c("-l",
#'     file = system.file("DESCRIPTION", package = "babelwhale"),
#'     file = system.file("LICENSE", package = "babelwhale")
#'   )
#' )
#'
#' }
#' @export
run_auto_mount <- function(
  container_id,
  command,
  args = NULL,
  wd = NULL,
  wd_in_container = NULL,
  environment_variables = NULL,
  debug = FALSE,
  verbose = FALSE,
  stdout = "|",
  stderr = "|") {

  # Convert paths of file arguments to absolute for docker
  file_args <- args[names(args) == "file"]
  in_path <- fs::path_abs(file_args)
  in_file <- fs::path_file(in_path)
  in_dir <- fs::path_dir(in_path)

  # Make (most likely) unique prefix for folder name that
  # won't conflict with an existing folder in the container
  # based on the hash of the container id and command
  prefix <- digest::digest(c(container_id, command))

  # Specify volume mounting for working directory
  wd_volume <- NULL
  if (!is.null(wd)) {
    wd_path <- fs::path_abs(wd)
    if (is.null(wd_in_container)) wd_in_container <- glue::glue("/{prefix}_wd")
    wd_volume <- glue::glue("{wd_path}:{wd_in_container}")
  }

  # Specify all volumes: one per file, plus working directory
  volumes <- unique(
    c(
      glue::glue("{in_dir}:/{prefix}_{1:length(in_dir)}"),
      wd_volume
    ))

  # Replace file arg paths with location in container
  files_in_container <- glue::glue("/{prefix}_{1:length(in_dir)}/{in_file}")
  args[names(args) == "file"] <- files_in_container

  # Run docker via babelwhale
  babelwhale::run(
    container_id = container_id,
    command = command,
    args = args,
    volumes = volumes,
    workspace = wd_in_container,
    environment_variables = environment_variables,
    debug = debug,
    verbose = verbose,
    stdout = stdout,
    stderr = stderr
  )
}
