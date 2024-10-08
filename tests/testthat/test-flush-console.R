test_that("flush_console() is a null op by default", {
  expect_no_error(flush_console())
})

test_that("can set and restore output handler", {
  f <- function() message("Hi")
  old <- set_console_flusher(function() message("Hi"))
  expect_equal(the$console_flusher, f)
  expect_equal(old, NULL)

  expect_message(flush_console(), "Hi")
  old2 <- set_console_flusher(old)
  expect_equal(old2, f)
})

test_that("can use flush_console() inside evaluate", {
  test <- function() {
    cat("hi")
    flush_console()
    cat("bye")
  }
  ev <- evaluate("test()")
  expect_equal(ev[[2]], "hi")
  expect_equal(ev[[3]], "bye")
})
