context("tooltips")


# library(radiant.data)
# library(ggplot2)
# diamon|  # example of conflicting datasets
test_that("Requesting tooltip for datasets attached in multiple namespaces doesn't throw a warning", {

  # Haven't really figured out a good way to test this yet. Open to suggestions!
})



test_that("Requesting tooltip for functions attached in multiple namespaces doesn't throw a warning", {
  # load two dependencies which also load masking function, validate
  library(shiny)
  library(jsonlite)

  # validate should be imported by both shiny and jsonlite
  expect_length(help("validate"), 2)

  # validate for each package should return different results
  expect_true({
    shinyAce:::get_desc_help("validate", package = "shiny") !=
      shinyAce:::get_desc_help("validate", package = "jsonlite")
  })

  # validate for each package should return different results
  expect_true({
    shinyAce:::get_desc_help("validate", package = "shiny") !=
      shinyAce:::get_desc_help("validate", package = "jsonlite")
  })

  # validate for each package should return different results
  expect_true({
    shinyAce:::build_tooltip_fields(shinyAce:::r_completions_metadata("shiny::validate")[[1]])$body !=
      shinyAce:::build_tooltip_fields(shinyAce:::r_completions_metadata("jsonlite::validate")[[1]])$body
  })

  # validate, which matches multiple attached functions, should complete silently
  expect_silent({
    shinyAce:::build_tooltip_fields(shinyAce:::r_completions_metadata("validate")[[1]])
  })

  # validate, which matches multiple attached functions, parameters should complete silently
  expect_silent({
    shinyAce:::r_completions_metadata("validate(")
  })

  # validate, which matches multiple attached functions, parameter tooltips should complete silently
  expect_silent({
    shinyAce:::build_tooltip_fields(shinyAce:::r_completions_metadata("validate(")[[1]])
  })
})



test_that("Requesting tooltip for environment variables should complete silently", {
  # validate, which matches multiple attached functions, should complete silently
  expect_silent({
    shinyAce:::build_tooltip_fields(shinyAce:::r_completions_metadata(".GlobalEnv")[[1]])
  })
})
