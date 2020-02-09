## ---- include = FALSE---------------------------------------------------------
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

model <- ranger(Species ~ .,data = iris, num.trees =  100)

## -----------------------------------------------------------------------------
treeInfo(model) %>%
  head()

## -----------------------------------------------------------------------------
tidypredict_fit(model)[1]

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- rand_forest(mode = "classification") %>%
  set_engine("ranger") %>%
  fit(Species ~ ., data = iris)

tidypredict_fit(parsnip_model)[[1]]

