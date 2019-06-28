#' Talking to both Docker and Singularity containers from R
#'
#' @import dplyr
#' @import purrr
#' @importFrom glue glue
#' @importFrom processx run
#'
#' @docType package
#' @name babelwhale
NULL


# Define valid global variables
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
