#' Object class tests
#'
#' @usage 
#'   is.error(x)
#'   is.message(x)
#'   is.source(x)
#'   is.value(x)
#'   is.warning(x)
#'   is.recordedplot(x)
#' @export is.message is.warning is.error is.value is.source is.recordedplot
#' @aliases is.message is.warning is.error is.value is.source is.recordedplot
#' @keywords internal
is.message <- function(x) inherits(x, "message")
is.warning <- function(x) inherits(x, "warning")
is.error <- function(x) inherits(x, "error")
is.value <- function(x) inherits(x, "value")
is.source <- function(x) inherits(x, "source")
is.recordedplot <- function(x) inherits(x, "recordedplot")

new_value <- function(value, visible = TRUE) {
  structure(list(value = value, visible = visible), class = "value")
}

new_source <- function(src) {
  structure(list(src = src), class = "source")
}
