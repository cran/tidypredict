## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(dplyr)
library(tidypredict)
library(parsnip)
library(ranger)
set.seed(100)

## -----------------------------------------------------------------------------
library(dplyr)
library(tidypredict)
library(ranger)

model <- ranger(mpg ~ ., data = mtcars, num.trees = 5, max.depth = 2)

## -----------------------------------------------------------------------------
treeInfo(model) %>%
  head()

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- rand_forest(mode = "regression", trees = 5) %>%
  set_engine("ranger", max.depth = 2) %>%
  fit(mpg ~ ., data = mtcars)

tidypredict_fit(parsnip_model)

