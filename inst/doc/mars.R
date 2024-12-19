## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(tidypredict)
library(earth)
library(dplyr)

## -----------------------------------------------------------------------------
library(earth)
data("etitanic", package = "earth")

model <- earth(age ~ sibsp + parch, data = etitanic, degree = 3)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
tidypredict_sql(model, dbplyr::simulate_odbc())

## -----------------------------------------------------------------------------
library(dplyr)

etitanic %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, etitanic)

## -----------------------------------------------------------------------------
model <- earth(survived ~ .,
  data = etitanic,
  glm = list(family = binomial), degree = 2
)

tidypredict_fit(model)

## -----------------------------------------------------------------------------
str(parse_model(model), 2)

## -----------------------------------------------------------------------------
library(parsnip)

p_model <- mars(mode = "regression", prod_degree = 3) %>%
  set_engine("earth") %>%
  fit(age ~ sibsp + parch, data = etitanic)

tidypredict_fit(p_model)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## -----------------------------------------------------------------------------
str(pm$terms[1:2])

