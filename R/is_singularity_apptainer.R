is_singularity_apptainer <- function() {
  out <- tryCatch(
    processx::run("singularity", "--help", error_on_status = FALSE, stderr_callback = print_processx, timeout = 2),
    error = function(e) {
      list(status = 1, message = e$message)
    }
  )

  grepl("apptainer", out$stdout)
}