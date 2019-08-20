# These are helper functions to be used with the %||% notation.
# e.g.
# getOption("test") %||% get_env_or_null("test") %||% read_rds_or_null("test.rds") %||% "test"

get_env_or_null <- function(x) {
  y <- Sys.getenv(x)
  if (y == "") y <- NULL
  y
}

read_rds_or_null <- function(file) {
  if (file.exists(file)) {
    readRDS(file)
  } else {
    NULL
  }
}
