## ----setup, include = FALSE---------------------------------------------------
if (requireNamespace("baguette", quietly = TRUE)) {
  library(tidypredict)
  library(dplyr)
  eval_code <- TRUE
} else {
  eval_code <- FALSE
}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = eval_code
)

## -----------------------------------------------------------------------------
set.seed(100)
model <- baguette::bagger(mpg ~ wt + cyl + disp, data = mtcars, times = 5)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
mtcars %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, mtcars)

## -----------------------------------------------------------------------------
tidypredict_sql(model, dbplyr::simulate_mssql())

## -----------------------------------------------------------------------------
set.seed(100)
model <- baguette::bagger(Species ~ ., data = iris, times = 3)

tidypredict_test(model, iris)

## -----------------------------------------------------------------------------
set.seed(100)
model <- baguette::bagger(
  Species ~ .,
  data = iris,
  base_model = "C5.0",
  times = 3
)

tidypredict_test(model, iris)

## -----------------------------------------------------------------------------
library(parsnip)

set.seed(100)
model <- bag_tree(mode = "regression") %>%
  set_engine("rpart", times = 5) %>%
  fit(mpg ~ wt + cyl + disp, data = mtcars)

tidypredict_fit(model)

