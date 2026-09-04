## ----setup, include = FALSE---------------------------------------------------
if (
  requireNamespace("klaR", quietly = TRUE) &&
    requireNamespace("naivebayes", quietly = TRUE)
) {
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
model <- klaR::NaiveBayes(Species ~ ., data = iris)

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
all.equal(unname(probs), unname(predict(model, iris)$posterior))

## -----------------------------------------------------------------------------
outlier <- iris[1, ]
outlier$Sepal.Length <- 20

predict(model, outlier)$posterior

## -----------------------------------------------------------------------------
sapply(tidypredict_fit(model), \(f) rlang::eval_tidy(f, outlier))

## -----------------------------------------------------------------------------
library(parsnip)
library(discrim)

p_model <- naive_Bayes() %>%
  set_engine("klaR", usekernel = FALSE) %>%
  fit(Species ~ ., data = iris)

## -----------------------------------------------------------------------------
tidypredict_fit(p_model)[["virginica"]]

## -----------------------------------------------------------------------------
nb_model <- naivebayes::naive_bayes(Species ~ ., data = iris)

nb_fit <- tidypredict_fit(nb_model)
nb_fit[["setosa"]]

## -----------------------------------------------------------------------------
nb_probs <- sapply(nb_fit, \(f) rlang::eval_tidy(f, iris))
all.equal(
  unname(nb_probs),
  unname(predict(nb_model, iris[names(nb_model$tables)], type = "prob"))
)

## -----------------------------------------------------------------------------
nb_p_model <- naive_Bayes() %>%
  set_engine("naivebayes", usekernel = FALSE) %>%
  fit(Species ~ ., data = iris)

tidypredict_fit(nb_p_model)[["virginica"]]

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

