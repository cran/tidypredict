skip_if_not_installed("randomForest")

test_that("Tester returns warning", {
  t <- tidypredict_test(
    lm(mpg ~ wt, data = mtcars),
    threshold = 1
  )
  expect_false(t$alert)
})

test_that("Intervals returns list", {
  expect_s3_class(
    tidypredict_test(lm(mpg ~ ., data = mtcars), include_intervals = TRUE),
    "tidypredict_test"
  )
})

test_that("Error is returned for tree based models", {
  expect_error(
    tidypredict_test(randomForest::randomForest(Species ~ ., data = iris), df = iris),
    "tidypredict_test does not support"
  )
  expect_error(
    tidypredict_test(ranger::ranger(Species ~ ., data = iris), df = iris),
    "tidypredict_test does not support"
  )
})
