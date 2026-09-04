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

model <- multinom(Species ~ ., data = iris, trace = FALSE)

## -----------------------------------------------------------------------------
fit <- tidypredict_fit(model)
names(fit)
fit[["setosa"]]

## -----------------------------------------------------------------------------
library(dplyr)

iris %>%
  mutate(!!!tidypredict_fit(model)) %>%
  glimpse()

## -----------------------------------------------------------------------------
probs <- sapply(fit, \(f) rlang::eval_tidy(f, iris))
all.equal(unname(probs), unname(predict(model, iris, type = "probs")))

## -----------------------------------------------------------------------------
library(parsnip)

p_model <- multinom_reg() %>%
  set_engine("nnet") %>%
  fit(Species ~ ., data = iris)

## -----------------------------------------------------------------------------
tidypredict_fit(p_model)[["virginica"]]

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

