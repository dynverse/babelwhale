pad <- function(string, width, side = c("left", "right", "both"), pad = " ") {
  side <- match.arg(side)
  strlen <- nchar(string)

  nchars <- width - strlen

  if (side == "left") {
    ncharsl <- nchars
    ncharsr <- 0
  } else if (side == "right") {
    ncharsl <- 0
    ncharsr <- nchars
  } else {
    ncharsl <- floor(nchars / 2)
    ncharsr <- ceiling(nchars / 2)
  }

  paste0(
    paste(rep(pad, ncharsl), collapse = ""),
    string,
    paste(rep(pad, ncharsr), collapse = "")
  )
}
