create_concurrent_dir <- function(
  cachedir = get_env_or_null("SINGULARITY_CACHEDIR") %||% paste0(get_env_or_null("HOME"), "/.singularity")
) {
  tempcache <- safe_tempdir("tempcache")

  walk(list.dirs(cachedir, full.names = FALSE), ~ dir.create(paste0(tempcache, "/", .), showWarnings = FALSE, recursive = TRUE))

  cached_files <- list.files(cachedir, recursive = TRUE, full.names = FALSE)
  walk(cached_files, function(file) {
    tempfile <- file.path(tempcache, file)
    cachedfile <- file.path(cachedir, file)
    file.symlink(cachedfile, tempfile)
  })

  tempcache
}

finalise_concurrent_dir <- function(
  tempcache,
  cachedir = get_env_or_null("SINGULARITY_CACHEDIR") %||% paste0(get_env_or_null("HOME"), "/.singularity")
) {
  cache_files <- list.files(cachedir, recursive = TRUE, full.names = FALSE)
  temp_files <- list.files(tempcache, recursive = TRUE, full.names = FALSE)

  new_files <- setdiff(temp_files, cache_files)
  walk(new_files, function(file) {
    tempfile <- file.path(tempcache, file)
    cachedfile <- file.path(cachedir, file)

    # just to make sure, check whether the new file is not a symbolic link
    # and whether it does not exist yet in the global cache before copying
    if (Sys.readlink(tempfile) == "" && !file.exists(cachedfile)) {
      file.copy(tempfile, cachedfile)
    }
  })

  unlink(tempcache, recursive = TRUE)
}
