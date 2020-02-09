## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(dplyr)
library(tidypredict)
library(randomForest)
library(parsnip)
set.seed(100)

## -----------------------------------------------------------------------------
library(dplyr)
library(tidypredict)
library(randomForest)

model <- randomForest(Species ~ .,data = iris ,ntree = 100, proximity = TRUE)

## -----------------------------------------------------------------------------
getTree(model, labelVar = TRUE) %>%
  head()

## -----------------------------------------------------------------------------
tidypredict_fit(model)[1]

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- rand_forest(mode = "classification") %>%
  set_engine("randomForest") %>%
  fit(Species ~ ., data = iris)

tidypredict_fit(parsnip_model)[[1]]

