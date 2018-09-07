# get mountable temporary directory
# on osx, the R temporary directory is placed in the /var folder, but this is not standard accessibale for docker
# in that case, we put it in /tmp
safe_tempdir <- function(subfolder) {
  dir <- file.path(tempfile(), subfolder) %>%
    fix_macosx_tmp()

  if (dir.exists(dir)) {
    unlink(dir, recursive = TRUE, force = TRUE)
  }

  dir.create(dir, recursive = TRUE)

  dir
}
