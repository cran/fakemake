#' Mock the Unix \command{touch} utility
#'
#' See \code{\link[fritools:touch]{fritools::touch}}.
#'
#' @param ... Arguments passed to \code{\link[fritools:touch]{fritools::touch}}.
#' @return The return value of \code{\link[fritools:touch]{fritools::touch}}.
#' @export
#' @keywords internal
touch <- function(...) return(fritools::touch(...))
