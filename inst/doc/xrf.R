## ----setup, include = FALSE---------------------------------------------------
if (rlang::is_installed("xrf")) {
  library(tidypredict)
  library(xrf)
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
set.seed(7)

## -----------------------------------------------------------------------------
library(xrf)
library(dplyr)
library(tidypredict)

df <- mtcars
df$cyl <- factor(df$cyl)

model <- xrf(
  mpg ~ wt + hp + cyl,
  df,
  family = "gaussian",
  xgb_control = list(nrounds = 5, max_depth = 3)
)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
df %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, df)

## -----------------------------------------------------------------------------
df_bin <- mtcars
df_bin$vs <- factor(df_bin$vs)

model_bin <- xrf(
  vs ~ wt + mpg,
  df_bin,
  family = "binomial",
  xgb_control = list(nrounds = 5, max_depth = 3)
)

tidypredict_test(model_bin, df_bin)

## ----eval = eval_code && rlang::is_installed(c("parsnip", "rules"))-----------
library(parsnip)
library(rules)

parsnip_model <- rule_fit(
  mode = "regression",
  trees = 5,
  tree_depth = 3,
  penalty = 0.1
) |>
  set_engine("xrf") |>
  fit(mpg ~ wt + hp + cyl, data = df)

tidypredict_test(parsnip_model, df)

