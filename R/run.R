#' Run a containerised command, and wait until finished
#'
#' @param container_id The name of the container, usually the repository name on dockerhub.
#' @inheritParams processx::run
#' @param volumes Which volumes to be mounted. Format: a character vector, with each element containing the source path and container path concatenated with a ":". For example: `c("/source_folder:/container_folder")`.
#' @param workspace Which working directory to run the command in.
#' @param environment_variables A character vector of environment variables. Format: `c("ENVVAR=VALUE")`.
#' @param debug If `TRUE`, a command will be printed that the user can execute to enter the container.
#' @param verbose Whether or not to print output
#'
#' @examples
#' if (test_docker_installation()) {
#'   set_default_config(create_docker_config(), permanent = FALSE)
#'
#'   # running a command
#'   run("alpine", "echo", c("hello"))
#'
#'   # mounting a folder
#'   folder <- tempdir()
#'   write("i'm a mounted file", paste0(folder, "/file.txt"))
#'   run("alpine", "cat", c("/mounted_folder/file.txt"), volumes = paste0(folder, "/:/mounted_folder"))
#' }
#'
#' @importFrom crayon bold
#' @importFrom dynutils safe_tempdir
#'
#' @export
run <- function(
  container_id,
  command,
  args = NULL,
  volumes = NULL,
  workspace = NULL,
  environment_variables = NULL,
  debug = FALSE,
  verbose = FALSE
) {
  config <- get_default_config()

  ###############################
  #### PREPROCESS PARAMETERS ####
  ###############################
  # determine executable
  processx_command <- Sys.which(config$backend) %>% unname()

  # add safe tempdir to volumes
  safe_tmp <- dynutils::safe_tempdir("tmp")
  on.exit(unlink(safe_tmp, recursive = TRUE))
  volumes <- c(volumes, paste0(fix_windows_path(safe_tmp), ":/tmp2"))

  if (config$backend == "docker") {
    volumes <- unlist(map(volumes, function(x) c("-v", x)))
  } else if (config$backend == "singularity") {
    volumes <- c("-B", paste0(volumes, collapse = ","))
  }

  # check debug
  if (debug) {
    command <- "bash"
    args <- NULL
  }

  # process workspace
  if (!is.null(workspace)) {
    if (config$backend == "docker") {
      workspace <- c("--workdir", workspace)
    } else if (config$backend == "singularity") {
      workspace <- c("--pwd", workspace)
    }
  }

  # add tmpdir to environment variables
  environment_variables <- c(environment_variables, "TMPDIR=/tmp2")


  #################################
  #### CREATE DOCKER ARGUMENTS ####
  #################################
  if (config$backend == "docker") {
    # is entrypoint given
    if (!is.null(command)) {
      command <- c("--entrypoint", command, "--rm")
      if (debug) {
        command <- c(command, "-it")
      }
    }

    # give it a name

    name <- dynutils::random_time_string("container")

    command <- c(command, "--name", name)

    # add -e flags to each environment variable
    env <- unlist(map(environment_variables, function(x) c("-e", x)))

    # do not pass env directly to processx
    processx_env <- NULL

    # determine command arguments
    processx_args <- c("run", command, env, workspace, volumes, container_id, args)


  ######################################
  #### CREATE SINGULARITY ARGUMENTS ####
  ######################################
  } else if (config$backend == "singularity") {
    # create tmpdir
    tmpdir <- dynutils::safe_tempdir("singularity_tmpdir")
    on.exit(unlink(tmpdir, force = TRUE, recursive = TRUE))

    processx_env <- c(
      set_names(
        environment_variables %>% str_replace_all("^.*=", ""),
        environment_variables %>% str_replace_all("^(.*)=.*$", "SINGULARITYENV_\\1")
      ),
      "SINGULARITY_TMPDIR" = tmpdir,
      "PATH" = Sys.getenv("PATH") # pass the path along
    )

    container <- paste0("docker://", container_id)

    # determine command arguments
    processx_args <- c(
      ifelse(is.null(command), "run", "exec"),
      "--containall",
      workspace, volumes, container, command, args
    )
  }


  #########################
  #### EXECUTE COMMAND ####
  #########################
  if (debug) {
    processx_env_str <- if (length(processx_env) > 0) paste0(names(processx_env), "=", processx_env, collapse = " ") else NULL
    command <- paste0(c(processx_env_str, processx_command, processx_args), collapse = " ")
    message("Use this command to enter the container: \n", crayon::bold(command))

    processx_args <- processx_args[processx_args != "-it"]
  }

  # stop container when interrupted
  # stopping a docker process won't kill the container (you can test this by sending signal 9 to a docker process)
  # so we need to do it manually
  if (config$backend == "docker") {
    on.exit({processx::run("docker", c("kill", name))})
  }

  # run container
  process <- processx::run(
    command = processx_command,
    args = processx_args,
    env = processx_env,
    echo = verbose,
    echo_cmd = verbose,
    spinner = TRUE,
    error_on_status = FALSE,
    cleanup_tree = TRUE
  )

  # reset the on exit
  if (config$backend == "docker") {
    on.exit({})
  }

  # capture out of memory
  if (process$status == 137) {
    process$stderr <- paste0(process$stderr, "Container was killed, possibly because it ran out of memory (error code 137)")
  }

  if (process$status != 0) {
    stop(process$stderr, call. = FALSE)
  }

  process
}
