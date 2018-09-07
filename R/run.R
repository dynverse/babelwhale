#' @importFrom crayon bold
run <- function(
  container_id,
  command,
  extra_args = NULL,
  debug = FALSE,
  verbose = FALSE,
  volumes = NULL,
  workspace = NULL,
  environment_variables = NULL
) {
  config <- get_default_config()

  ###############################
  #### PREPROCESS PARAMETERS ####
  ###############################
  # determine executable
  container_exec <- match.arg(config$type, choices = c("docker", "singularity"))

  # add safe tempdir to volumes
  safe_tmp <- safe_tempdir("tmp")
  on.exit(unlink(safe_tmp, recursive = TRUE))
  volumes <- c(volumes, paste0(fix_windows_path(safe_tmp), ":/tmp2"))

  if (container_exec == "docker") {
    volumes <- unlist(map(volumes, ~ c("-v", .)))
  } else if (container_exec == "singularity") {
    volumes <- c("-B", paste0(volumes, collapse = ","))
  }

  # check debug
  if (debug) {
    command <- "bash"
    extra_args <- NULL
  }

  # process workspace
  if (!is.null(workspace)) {
    if (container_exec == "docker") {
      workspace <- c("--workdir", workspace)
    } else if (container_exec == "singularity") {
      workspace <- c("--pwd", workspace)
    }
  }

  # add tmpdir to environment variables
  environment_variables <- c(environment_variables, "TMPDIR=/tmp2")


  #################################
  #### CREATE DOCKER ARGUMENTS ####
  #################################
  if (container_exec == "docker") {
    # is entrypoint given
    if (!is.null(command)) {
      command <- c("--entrypoint", command)
      if (debug) {
        command <- c(command, "-it")
      }
    }

    # add -e fllags to each environment variable
    env <- unlist(map(environment_variables, ~ c("-e", .)))

    # determine command arguments
    args <- c("run", command, env, workspace, volumes, container_id, extra_args)

    # do not pass env directly to processx
    env <- NULL

  }


  ######################################
  #### CREATE SINGULARITY ARGUMENTS ####
  ######################################
  if (container_exec == "singularity") {
    # create caches and tmpdirs
    tempcache <- create_concurrent_dir()
    on.exit(finalise_concurrent_dir(tempcache))

    env <- c(
      set_names(
        environment_variables %>% gsub("^.*=", "", .),
        environment_variables %>% gsub("^(.*)=.*$", "SINGULARITYENV_\\1", .)
      ),
      "SINGULARITY_CACHEDIR" = tempcache,
      "SINGULARITY_LOCALCACHEDIR" = safe_tempdir("singularity_localcachedir"),
      "SINGULARITY_TMPDIR" = safe_tempdir("singularity_tmpdir"),
      "PATH" = Sys.getenv("PATH") # pass the path along
    )

    # pull container directly from shub or use a prebuilt image
    if (!config$prebuild) {
      container <- paste0("shub://", container_id)
    } else {
      container <- singularity_image_path(config, container_id)
    }

    # determine command arguments
    args <- c(
      ifelse(is.null(command), "run", "exec"),
      workspace, volumes, container, command, extra_args
    )
  }


  #########################
  #### EXECUTE COMMAND ####
  #########################
  if (!debug) {
    # run container
    process <- processx::run(container_exec, args, env = env, echo = verbose, echo_cmd = verbose, spinner = TRUE, error_on_status = FALSE)

    if (process$status != 0 && !verbose) {
      cat(process$stderr)
      stop(call. = FALSE)
    }

    process
  } else {
    # simply print the command the user needs to use to enter the container
    env_str <- if (length(env) > 0) paste0(names(env), "=", env, collapse = " ") else NULL

    command <- paste0(c(env_str, container_exec, args), collapse = " ")

    stop("Use this command for debugging: \n", crayon::bold(command), call. = FALSE)
  }
}
