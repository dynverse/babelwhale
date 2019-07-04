.default_config_file <- function() {
  if (.Platform$OS.type == "unix") {
    "~/.local/share/babelwhale/config.rds"
  } else if (.Platform$OS.type == "windows") {
    "~/../AppData/Local/babelwhale/config.rds"
  }
}

#' @rdname create_config
#'
#' @export
get_default_config <- function() {
  getOption("babelwhale_config") %||%
    read_rds_or_null(.default_config_file()) %||%
    create_config()
}

#' @rdname create_config
#'
#' @param config A config to save as default.
#' @param permanent Whether or not to save the config file permanently
#'
#' @export
set_default_config <- function(config, permanent = TRUE) {
  if (permanent) {
    config_file <- .default_config_file()

    folder <- gsub("/[^/]*$", "", config_file)

    if (!file.exists(folder)) dir.create(folder, recursive = TRUE)

    save(config, file = config_file, compress = "gz")
  } else {
    options(babelwhale_config = config)
  }
}
