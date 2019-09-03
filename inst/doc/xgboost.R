## ----setup, include = FALSE----------------------------------------------

if (requireNamespace("xgboost", quietly = TRUE)) {
  library(tidypredict)
  library(xgboost)
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


## ------------------------------------------------------------------------
library(xgboost)

logregobj <- function(preds, dtrain) {
  labels <- xgboost::getinfo(dtrain, "label")
  preds <- 1 / (1 + exp(-preds))
  grad <- preds - labels
  hess <- preds * (1 - preds)
  return(list(grad = grad, hess = hess))
}

xgb_bin_data <- xgboost::xgb.DMatrix(as.matrix(mtcars[, -9]), label = mtcars$am)
model <- xgboost::xgb.train(
  params = list(max_depth = 2, silent = 1, objective = "binary:logistic", base_score = 0.5),
  data = xgb_bin_data, nrounds = 50
)

## ------------------------------------------------------------------------
tidypredict_fit(model)

## ------------------------------------------------------------------------
library(dplyr)

mtcars %>%
  tidypredict_to_column(model) %>%
  glimpse()

## ------------------------------------------------------------------------
tidypredict_test(model, mtcars, xg_df = xgb_bin_data)

## ------------------------------------------------------------------------
library(parsnip)

p_model <- boost_tree(mode = "regression") %>%
  set_engine("xgboost") %>%
  fit(am ~ ., data = mtcars)

## ------------------------------------------------------------------------
tidypredict_test(p_model, mtcars, xg_df = xgb_bin_data)

## ------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## ------------------------------------------------------------------------
str(pm$trees[1])

