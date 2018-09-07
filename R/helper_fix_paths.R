fix_windows_path <- function(path) {
  path <- path %>% gsub("\\\\", "/", .)

  start <- path %>% sub("^([a-zA-Z]):/.*", "/\\1", .) %>% tolower

  path %>% sub("[^:/]:", start, .)
}

fix_macosx_tmp <- function(path) {
  gsub("^/var/", "/tmp/", path)
}

unfix_windows_path <- function(path) {
  path %>% gsub("^/c/", "C:/", .)
}
