test_that("all code run, even after error", {
  ev <- evaluate(file("error.R"))
  expect_length(ev, 4)
})

test_that("code aborts on error if stop_on_error == 1L", {
  ev <- evaluate(file("error.R"), stop_on_error = 1L)
  expect_length(ev, 2)
})

test_that("code errors if stop_on_error == 2L", {
  expect_error(evaluate(file("error.R"), stop_on_error = 2L), "1")
})

test_that("traceback useful if stop_on_error == 2L", {
  expect_error(evaluate(file("error-complex.R"), stop_on_error = 2L), "Error")

  ## Doesn't work because .Traceback not create when code run
  ## inside try or tryCatch. Can't figure out how to work around.
  ## tryCatch(..., error = function(e) {}) doesn't have enough info
  ## in e, or in the call stack.  options(error = function() {}) doesn't
  ## stop error propagation
  # expect_match(.Traceback[[2]], "h()")
  # expect_match(.Traceback[[3]], "g()")
  # expect_match(.Traceback[[4]], "f()")
})

test_that("capture messages in try() (#88)", {
  skip_if(getRversion() < "3.4")

  ev <- evaluate(file("try.R"))
  expect_match(ev[[length(ev)]], "Obscure error")
})
