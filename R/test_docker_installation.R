#' Tests whether docker is correctly installed and available
#'
#' @param detailed Whether top do a detailed check
#'
#' @importFrom glue glue
#' @importFrom crayon red green bold
#' @importFrom stringr str_pad
#' @importFrom dynutils safe_tempdir
#'
#' @export
test_docker_installation <- function(detailed = FALSE) {
  if (!detailed) {
    output <- tryCatch(
      processx::run("docker", "version", error_on_status = FALSE, stderr_callback = print_processx, timeout = 1),
      error = function(e) {list(status = 1)}
    )

    output$status == 0
  } else {
    # test if docker command is found
    output <- tryCatch(
      processx::run("docker", "version", error_on_status = FALSE, stderr_callback = print_processx),
      error = function(e) {list(status = 1)}
    )
    if (output$status == 0) {
      message(crayon::green("\u2714 Docker is installed"))
    } else {
      installation_url <- switch(
        tolower(Sys.info()["sysname"]),
        windows = "https://docs.docker.com/docker-for-windows/install/ (for Windows 10) or https://docs.docker.com/toolbox/toolbox_install_windows/ (for older Windows installations)",
        darwin = "https://docs.docker.com/docker-for-mac/install/",
        "https://docs.docker.com/install/"
      )

      stop(crayon::red(glue::glue("\u274C An installation of docker is necessary to run this method. See {installation_url} for instructions.")))
    }

    # test if docker daemon is running
    output <- processx::run("docker", c("version", "--format", "{{.Client.APIVersion}}"), error_on_status = FALSE, stderr_callback = print_processx)
    if (output$status != 0) {
      stop(crayon::red(glue::glue(
        "\u274C Docker daemon does not seem to be running... \n",
        "- Try running {crayon::bold('dockerd')} in the command line \n",
        "- See https://docs.docker.com/config/daemon/"
      )))
    }
    message(crayon::green("\u2714 Docker daemon is running"))

    # test if docker version is recent enough
    version <- output$stdout %>% trimws() %>% str_replace_all("'", "") # remove trailing ' (in windows)
    if (utils::compareVersion("1.0", version) > 0) {
      stop(crayon::red("\u274C Docker API version is", version, ". Requires 1.0 or later"))
    }

    message(crayon::green(glue::glue("\u2714 Docker is at correct version (>1.0): ", version)))

    # test if docker format is linux
    output <- processx::run("docker", c("info", "--format", "{{.OSType}}"), error_on_status = FALSE, stderr_callback = print_processx)
    ostype <- output$stdout %>% trimws() %>% str_replace_all("'", "") # remove trailing ' (in windows)

    if (ostype != "linux") {
      stop(crayon::red(glue::glue(
        "\u274C Docker is not running in linux mode, but in {ostype} mode. \n",
        " Please switch to linux containers: https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers"
      )))
    }

    message(crayon::green(glue::glue("\u2714 Docker is in linux mode")))

    # test if docker images can be pulled
    output <- processx::run("docker", c("pull", "alpine:3.7"), error_on_status = FALSE, stderr_callback = print_processx, spinner = TRUE)
    if (output$status != 0) {
      stop(crayon::red("\u274C Unable to pull docker images."))
    }
    message(crayon::green("\u2714 Docker can pull images"))

    # test if docker can run images, will fail on windows if linux containers are not enabled
    output <- processx::run("docker", c("run", "alpine:3.7"), error_on_status = FALSE, stderr_callback = print_processx)
    if (output$status != 0) {
      stop(crayon::red("\u274C Unable to run an image"))
    }
    message(crayon::green("\u2714 Docker can run image"))

    # test if docker volume can be mounted
    volume_dir <- dynutils::safe_tempdir("")
    output <- processx::run("docker", c("run", "-v", glue::glue("{volume_dir}:/mount"), "alpine:3.7"), error_on_status = FALSE, stderr_callback = print_processx)
    if (output$status != 0) {
      stop(crayon::red(glue::glue(
        "\u274C Unable to mount temporary directory: {volume_dir}. \n",
        "\tOn windows, you need to enable the shared drives (https://rominirani.com/docker-on-windows-mounting-host-directories-d96f3f056a2c)"
      )))
    }
    message(crayon::green("\u2714 Docker can mount temporary volumes"))

    message(crayon::green(crayon::bold(stringr::str_pad("\u2714 Docker test successful ", 90, side = "right", "-"))))

    TRUE
  }
}
