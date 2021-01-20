#' Mock the Unix \command{touch} utility
#'
#' See \code{\link[fritools:touch]{fritools::touch}}.
#'
#' @param path Path to the file to be touched
#' @return The return value of \code{\link{file.copy}}.
#' @export
#' @keywords internal
touch <- fritools::touch
