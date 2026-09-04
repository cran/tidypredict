## ----setup, include = FALSE---------------------------------------------------
if (requireNamespace("nnet", quietly = TRUE)) {
  library(tidypredict)
  library(nnet)
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
library(nnet)

set.seed(100)
model <- nnet(mpg ~ wt + hp, data = mtcars, size = 3, linout = TRUE, trace = FALSE)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
library(dplyr)

mtcars %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, mtcars)

## -----------------------------------------------------------------------------
set.seed(100)
cls_model <- nnet(Species ~ ., data = iris, size = 3, trace = FALSE)

fit <- tidypredict_fit(cls_model)
names(fit)

## -----------------------------------------------------------------------------
probs <- sapply(fit, \(f) rlang::eval_tidy(f, iris))
all.equal(unname(probs), unname(predict(cls_model, iris, type = "raw")))

## -----------------------------------------------------------------------------
library(parsnip)

set.seed(100)
p_model <- mlp(mode = "regression", hidden_units = 3, epochs = 100) %>%
  set_engine("nnet") %>%
  fit(mpg ~ wt + hp, data = mtcars)

## -----------------------------------------------------------------------------
tidypredict_fit(p_model)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

