context("test_js_quote")
test_that("plaintext works", {  
  string <- "text here"
  expect_match(jsQuote(string), "^['\"]text here['\"]$")  
})

test_that("newline works", {  
  string <- "text\nhere"
  expect_match(jsQuote(string), "^['\"]text\\\\nhere['\"]$")
})
