fix_windows_path <- function(path) {
  path <- str_replace_all(path, "\\\\", "/")

  start <-
    str_replace_all(path, "^([a-zA-Z]):/.*", "/\\1") %>%
    tolower

  str_replace(path, "[^:/]:", start)
}

unfix_windows_path <- function(path) {
  str_replace_all(path, "^/c/", "C:/")
}


fix_macosx_tmp <- function (path) {
  gsub("^/var/", "/tmp/", path)
}
