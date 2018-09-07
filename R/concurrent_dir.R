create_concurrent_dir <- function(dest_dir) {
  temp_dir <- safe_tempdir("temp_dir")

  walk(
    list.dirs(dest_dir, full.names = FALSE),
    function(subdir) {
      path <- paste0(temp_dir, "/", subdir)
      if (!file.exists(path)) dir.create(path, recursive = TRUE)
    }
  )

  dest_files <- list.files(dest_dir, recursive = TRUE, full.names = FALSE)
  walk(dest_files, function(file) {
    temp_file <- file.path(temp_dir, file)
    dest_file <- file.path(dest_dir, file)
    file.symlink(dest_file, temp_file)
  })

  temp_dir
}

finalise_concurrent_dir <- function(
  temp_dir,
  dest_dir
) {
  dest_files <- list.files(dest_dir, recursive = TRUE, full.names = FALSE)
  temp_files <- list.files(temp_dir, recursive = TRUE, full.names = FALSE)

  new_files <- setdiff(temp_files, dest_files)
  walk(new_files, function(file) {
    temp_file <- file.path(temp_dir, file)
    dest_file <- file.path(dest_dir, file)

    # just to make sure, check whether the new file is not a symbolic link
    # and whether it does not exist yet in the global cache before copying
    if (Sys.readlink(temp_file) == "" && !file.exists(dest_file)) {
      file.copy(temp_file, dest_file)
    }
  })

  unlink(temp_dir, recursive = TRUE)
}
