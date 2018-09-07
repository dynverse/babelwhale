#' Read a file from a container
#'
#' @inheritParams copy_file
#'
#' @importFrom readr read_lines
#' @importFrom dynutils safe_tempdir
#'
#' @export
read_file <- function(
  container_id,
  path_container
) {
  temp_folder <- dynutils::safe_tempdir("")
  on.exit(unlink(temp_folder, recursive = TRUE, force = TRUE))

  path_local <- paste0(temp_folder, "/tmpfile")

  copy_file(
    container_id = container_id,
    path_container = path_container,
    path_local = path_local
  )

  readr::read_lines(path_local)
}
