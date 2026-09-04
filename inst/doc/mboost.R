## ----setup, include = FALSE---------------------------------------------------
if (rlang::is_installed("mboost")) {
  library(tidypredict)
  library(mboost)
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
set.seed(1)

## -----------------------------------------------------------------------------
library(mboost)
library(dplyr)
library(tidypredict)

model <- blackboost(
  mpg ~ wt + cyl,
  data = mtcars,
  control = boost_control(mstop = 10)
)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
mtcars %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, df = mtcars)

## -----------------------------------------------------------------------------
df <- transform(mtcars, cyl = factor(cyl))

model_cat <- blackboost(
  mpg ~ wt + cyl,
  data = df,
  control = boost_control(mstop = 10)
)

tidypredict_test(model_cat, df = df)

