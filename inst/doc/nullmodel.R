## ----setup, include = FALSE---------------------------------------------------
library(tidypredict)
library(dplyr)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
model <- parsnip::nullmodel(mtcars[-1], mtcars$mpg)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
mtcars %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, mtcars)

## -----------------------------------------------------------------------------
c_model <- parsnip::nullmodel(iris[-5], iris$Species)

tidypredict_fit(c_model)

## -----------------------------------------------------------------------------
library(parsnip)

p_model <- null_model(mode = "regression") %>%
  set_engine("parsnip") %>%
  fit(mpg ~ ., data = mtcars)

## -----------------------------------------------------------------------------
tidypredict_fit(p_model)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

