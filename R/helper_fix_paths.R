fix_windows_path <- function(path) {
  path <- gsub("\\\\", "/", path)

  start <-
    gsub("^([a-zA-Z]):/.*", "/\\1", path) %>%
    tolower

  gsub("[^:/]:", start, path)
}

unfix_windows_path <- function(path) {
  gsub("^/c/", "C:/", path)
}


fix_macosx_tmp <- function (path) {
  gsub("^/var/", "/tmp/", path)
}
