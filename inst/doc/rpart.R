## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(dplyr)
library(tidypredict)
library(rpart)
set.seed(100)

## -----------------------------------------------------------------------------
library(dplyr)
library(tidypredict)
library(rpart)

model <- rpart(mpg ~ ., data = mtcars)

## -----------------------------------------------------------------------------
model$frame |>
  head()

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
model_class <- rpart(Species ~ ., data = iris)
tidypredict_fit(model_class)

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- decision_tree(mode = "regression") |>
  set_engine("rpart") |>
  fit(mpg ~ ., data = mtcars)

tidypredict_fit(parsnip_model)

## -----------------------------------------------------------------------------
mtcars2 <- mtcars
mtcars2$cyl <- factor(mtcars2$cyl)

model_cat <- rpart(mpg ~ cyl + wt + hp, data = mtcars2)
tidypredict_fit(model_cat)

