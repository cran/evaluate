#" Capture snapshot of current device.
#"
#" There's currently no way to capture when a graphics device changes,
#" except to check its contents after the evaluation of every expression.
#" This means that only the last plot of a series will be captured.
#"
#" @return \code{NULL} if plot is blank or unchanged, otherwise the output of
#"   \code{\link[grDevices]{recordPlot}}.
plot_snapshot <- local({
  last_plot <- NULL

  function(incomplete = FALSE) {
    if (is.null(dev.list())) return(NULL)

    pos <- par("mfg")[1:2]
    size <- par("mfg")[3:4]
    if (!incomplete && !identical(pos, size)) return(NULL)

    plot <- recordPlot()
    if (is_par_change(last_plot, plot) || identical(last_plot, plot)) {
      return(NULL)
    }

    if (is.empty(plot)) return(NULL)
    last_plot <<- plot
    plot
  }
})

is_par_change <- function(p1, p2) {
  calls1 <- plot_calls(p1)
  calls2 <- plot_calls(p2)

  n1 <- length(calls1)
  n2 <- length(calls2)

  if (n2 <= n1) return(FALSE)
  if (!identical(calls1, calls2[1:n1])) return(FALSE)

  last <- calls2[(n1 + 1):n2]
  all(last %in% empty_calls)
}

# R 3.0 has significant changes in display lists
isR3 <- getRversion() >= "3.0.0"

# if all calls are in these elements, the plot is basically empty
empty_calls <- if (isR3) c("C_par", "C_layout", "palette", "palette2") else
  c("layout", "par")

is.empty <- function(x) {
  if(is.null(x)) return(TRUE)

  pc <- plot_calls(x)
  if (length(pc) == 0) return(TRUE)

  if (isR3) all(pc %in% empty_calls) else {
    !identical(pc, "recordGraphics") && !identical(pc, "persp") &&
      !identical(pc, "plot.new") &&
      (length(pc) <= 1L || all(pc %in% empty_calls))
  }
}


plot_calls <- if (isR3) {
  function(plot) {
    el <- lapply(plot[[1]], "[[", 2)
    if (length(el) == 0) return()
    sapply(el, function(x) {
      x <- x[[1]]
      # grid graphics do not have x$name
      if (is.null(x[["name"]])) deparse(x) else x[["name"]]
    })
  }
} else function(plot) {
  prims <- lapply(plot[[1]], "[[", 1)
  if (length(prims) == 0) return()

  chars <- sapply(prims, deparse)
  str_replace_all(chars, ".Primitive\\(\"|\"\\)", "")
}
