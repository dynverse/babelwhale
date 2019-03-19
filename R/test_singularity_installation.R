#' Tests whether singularity is correctly installed and available
#'
#' @param detailed Whether top do a detailed check
#'
#' @importFrom glue glue
#' @importFrom crayon red green bold
#' @importFrom stringr str_pad
#' @importFrom dynutils safe_tempdir
#'
#' @export
test_singularity_installation <- function(detailed = FALSE) {
  output <- tryCatch(
    processx::run("singularity", "version", error_on_status = FALSE, stderr_callback = print_processx, timeout = 2),
    error = function(e) {list(status = 1, message = e$message)}
  )

  if (output$status == 1) {
    stop(crayon::red(paste0(
      "\u274C Singularity (>= 3.0) could not be found. ",
      "Install the latest stable release from: https://github.com/sylabs/singularity/releases."
    )))
  }

  if (output$stdout < "3.0") {
    stop(crayon::red(paste0(
      "\u274C An older version of Singularity was detected (", output$stdout, "). ",
      "Install the latest stable release from: https://github.com/sylabs/singularity/releases."
    )))
  }

  if (detailed) {
    message(crayon::green(paste0("\u2714 Singularity is installed")))
    message(crayon::green(paste0("\u2714 Singularity is at correct version (>=3.0): ", gsub("\n", "", output$stdout), " is installed")))
  }

  output <- processx::run("singularity", c("exec", "docker://alpine:3.7", "echo", "hi"), error_on_status = FALSE, stderr_callback = print_processx, spinner = TRUE)
  if (output$status != 0 || output$stdout != "hi\n") {
    stop(crayon::red("\u274C Singularity is unable to run pull and run a container from Dockerhub."))
  }
  if (detailed) {
    message(crayon::green("\u2714 Singularity can pull and run a container from Dockerhub"))
  }

  # test if singularity volume can be mounted
  tryCatch({
    volume_dir <- dynutils::safe_tempdir("test")
    on.exit(unlink(volume_dir, force = TRUE, recursive = TRUE))
    write_lines("hello", paste0(volume_dir, "/test"))
  }, error = function(e) {
    folder <- file.path(tempfile()) %>% dynutils:::fix_macosx_tmp()
    stop(crayon::red(paste0("\u274C Unable to create temporary folder: ", folder, ".")))
  })

  output <- processx::run("singularity", c("exec", "-B", glue::glue("{volume_dir}:/mount"), "docker://alpine:3.7", "cat", "/mount/test"), error_on_status = FALSE, stderr_callback = print_processx)
  if (output$status != 0 || output$stdout != "hello\n") {
    stop(crayon::red(paste0("\u274C Unable to mount temporary directory: ", volume_dir, ".")))
  }

  if (detailed) {
    message(crayon::green("\u2714 Singularity can mount temporary volumes"))
    message(crayon::green(crayon::bold(stringr::str_pad("\u2714 Singularity test successful ", 90, side = "right", "-"))))
  }

  TRUE
}
