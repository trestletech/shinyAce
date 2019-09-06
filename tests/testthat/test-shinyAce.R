context("shinyAce")

test_that("modes", {
  modes <- shinyAce::getAceModes()
  expect_true(is.character(modes))
  expect_true(length(modes) > 0)
  expect_true(sum(nchar(modes)) > 500)
})

test_that("themes", {
  themes <- shinyAce::getAceThemes()
  expect_true(is.character(themes))
  expect_true(length(themes) > 0)
  expect_true(sum(nchar(themes)) > 300)
})

test_that("is.empty", {
  expect_true(is.empty(NULL))
  expect_true(is.empty(NA))
  expect_true(is.empty(c()))
  expect_true(is.empty(""))
  expect_true(is.empty(" "))
  expect_true(is.empty(c(" ", " ")))
  expect_true(is.empty(list()))
  expect_true(is.empty(list(a = "", b = "")))
})
