## ----setup, include = FALSE---------------------------------------------------
if (requireNamespace("glmnet", quietly = TRUE)) {
  library(tidypredict)
  library(glmnet)
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
library(glmnet)

model <- glmnet::glmnet(mtcars[, -1], mtcars$mpg, lambda = 1)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
library(dplyr)

mtcars %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, mtcars[, -1])

## -----------------------------------------------------------------------------
library(parsnip)

p_model <- linear_reg(penalty = 1) %>%
  set_engine("glmnet") %>%
  fit(mpg ~ ., data = mtcars)

## -----------------------------------------------------------------------------
tidypredict_fit(p_model)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## -----------------------------------------------------------------------------
str(pm$trees[1])

