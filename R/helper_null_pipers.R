# These are helper functions to be used with the %||% notation.
# e.g.
# getOption("test") %||% get_env_or_null("test") %||% read_rds_or_null("test.rds") %||% "test"

get_env_or_null <- function(x) {
  y <- Sys.getenv(x)
  if (y == "") y <- NULL
  y
}

#' @importFrom readr read_rds
read_rds_or_null <- function(file) {
  if (file.exists(file)) {
    readr::read_rds(file)
  } else {
    NULL
  }
}
