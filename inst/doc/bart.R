## ----setup, include = FALSE---------------------------------------------------
if (requireNamespace("dbarts", quietly = TRUE)) {
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
model <- dbarts::bart(
  mtcars[c("wt", "cyl", "disp")],
  mtcars$mpg,
  ntree = 5,
  ndpost = 5,
  keeptrees = TRUE,
  verbose = FALSE
)

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
library(parsnip)

set.seed(100)
model <- bart(mode = "regression", trees = 5) %>%
  set_engine("dbarts", ndpost = 5, verbose = FALSE) %>%
  fit(mpg ~ wt + cyl + disp, data = mtcars)

tidypredict_fit(model)

## -----------------------------------------------------------------------------
set.seed(100)
model <- dbarts::bart(
  data.frame(wt = mtcars$wt, cyl = factor(mtcars$cyl)),
  mtcars$mpg,
  ntree = 2,
  ndpost = 2,
  keeptrees = TRUE,
  verbose = FALSE
)

tidypredict_fit(model)

