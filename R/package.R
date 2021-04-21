#' Talking to both Docker and Singularity containers from R
#'
#' Provides a unified interface to interact with
#' docker' and 'singularity' containers.  You can execute a command
#' inside a container, mount a volume or copy a file.
#'
#' @import dplyr
#' @import purrr
#' @importFrom processx run
#'
#' @docType package
#' @name babelwhale
NULL


# Define valid global variables
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
