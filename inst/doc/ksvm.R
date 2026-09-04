## ----setup, include = FALSE---------------------------------------------------
if (rlang::is_installed("kernlab")) {
  library(tidypredict)
  library(kernlab)
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
set.seed(100)

## -----------------------------------------------------------------------------
library(kernlab)
library(dplyr)
library(tidypredict)

model <- ksvm(
  mpg ~ wt + hp + disp,
  data = mtcars,
  kernel = "vanilladot",
  type = "eps-svr"
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
tidypredict_sql(model, dbplyr::simulate_mssql())

## -----------------------------------------------------------------------------
tidypredict_test(model, mtcars)

## -----------------------------------------------------------------------------
df <- mtcars
df$vs <- factor(df$vs)

model_class <- ksvm(
  vs ~ wt + mpg,
  data = df,
  kernel = "vanilladot",
  type = "C-svc",
  prob.model = TRUE
)

tidypredict_fit(model_class)

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- svm_linear(mode = "regression") |>
  set_engine("kernlab") |>
  fit(mpg ~ wt + hp, data = mtcars)

tidypredict_fit(parsnip_model)

