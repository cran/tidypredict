## ----setup, include = FALSE---------------------------------------------------
if (requireNamespace("mda", quietly = TRUE)) {
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
model <- mda::fda(Species ~ ., data = iris)

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
all.equal(unname(probs), unname(predict(model, iris, type = "posterior")))

## -----------------------------------------------------------------------------
library(parsnip)
library(discrim)

p_model <- discrim_linear(penalty = 1) %>%
  set_engine("mda") %>%
  fit(Species ~ ., data = iris)

## -----------------------------------------------------------------------------
tidypredict_fit(p_model)[["virginica"]]

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

