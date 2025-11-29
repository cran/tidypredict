## ----pre, include = FALSE-----------------------------------------------------
if (!rlang::is_installed("randomForest")) {
  knitr::opts_chunk$set(
    eval = FALSE
  )
}

## ----include = FALSE----------------------------------------------------------
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

model <- randomForest(mpg ~ ., data = mtcars, ntree = 5, proximity = TRUE)

## -----------------------------------------------------------------------------
getTree(model, labelVar = TRUE) %>%
  head()

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- rand_forest(mode = "regression", trees = 5) %>%
  set_engine("randomForest") %>%
  fit(mpg ~ ., data = mtcars)

tidypredict_fit(parsnip_model)

