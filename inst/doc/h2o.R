## ----include = FALSE----------------------------------------------------------
# H2O predictions require the h2o and agua packages to load and a running H2O
# cluster, so the chunks below are only evaluated when all of that is available.
h2o_available <- FALSE
if (
  requireNamespace("h2o", quietly = TRUE) &&
    requireNamespace("agua", quietly = TRUE) &&
    requireNamespace("parsnip", quietly = TRUE)
) {
  h2o_available <- tryCatch(
    {
      suppressMessages(h2o::h2o.init())
      h2o::h2o.no_progress()
      TRUE
    },
    error = function(e) FALSE
  )
}

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = h2o_available
)

library(dplyr)
library(tidypredict)
set.seed(100)

## -----------------------------------------------------------------------------
library(parsnip)
library(agua)

model <- boost_tree(mode = "regression", trees = 10) |>
  set_engine("h2o_gbm") |>
  fit(mpg ~ wt + cyl + hp, data = mtcars)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
tidypredict_sql(model, dbplyr::simulate_dbi())

## -----------------------------------------------------------------------------
mtcars2 <- mtcars
mtcars2$cyl <- factor(mtcars2$cyl)
mtcars2$gear <- factor(mtcars2$gear)

model_cat <- boost_tree(mode = "regression", trees = 10) |>
  set_engine("h2o_gbm") |>
  fit(mpg ~ cyl + gear + wt, data = mtcars2)

tidypredict_fit(model_cat)

## -----------------------------------------------------------------------------
mtcars3 <- mtcars
mtcars3$vs <- factor(mtcars3$vs)

model_bin <- boost_tree(mode = "classification", trees = 10) |>
  set_engine("h2o_gbm") |>
  fit(vs ~ wt + cyl + hp, data = mtcars3)

tidypredict_fit(model_bin)

## -----------------------------------------------------------------------------
model_multi <- boost_tree(mode = "classification", trees = 10) |>
  set_engine("h2o_gbm") |>
  fit(Species ~ ., data = iris)

names(tidypredict_fit(model_multi))

## -----------------------------------------------------------------------------
model_rules <- rule_fit(mode = "regression") |>
  set_engine("h2o") |>
  fit(mpg ~ wt + hp + disp, data = mtcars)

tidypredict_fit(model_rules)

