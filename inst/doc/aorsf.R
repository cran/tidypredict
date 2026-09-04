## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(dplyr)
library(tidypredict)
library(parsnip)
library(aorsf)
set.seed(100)

## -----------------------------------------------------------------------------
library(dplyr)
library(tidypredict)
library(aorsf)

model <- orsf(mtcars, mpg ~ ., n_tree = 5)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
library(parsnip)
library(bonsai)

parsnip_model <- rand_forest(mode = "regression", trees = 5) %>%
  set_engine("aorsf") %>%
  fit(mpg ~ ., data = mtcars)

tidypredict_fit(parsnip_model)

