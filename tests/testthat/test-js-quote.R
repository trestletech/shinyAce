context("test_js_quote")
test_that("plaintext works", {  
  string <- "text here"
  expect_match(jsQuote(string), "^['\"]text here['\"]$")  
})

test_that("newline works", {  
  string <- "text\nhere"
  expect_match(jsQuote(string), "^['\"]text\\\\nhere['\"]$")
})

context("sanitize")
test_that("sanitization works", {
  expect_equal(sanitizeId("test"), "test")
  expect_equal(sanitizeId("test--2!"), "test2")
  expect_equal(sanitizeId("!@#test"), "test")
  expect_equal(sanitizeId("t!e%s#--t3"), "test3")
})