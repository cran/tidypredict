## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(tidypredict)
library(Cubist)
library(dplyr)

## -----------------------------------------------------------------------------
library(Cubist)
data("BostonHousing", package = "mlbench")

model <- Cubist::cubist(
  x = BostonHousing[, -14],
  y = BostonHousing$medv,
  committees = 3
)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
tidypredict_sql(model, dbplyr::simulate_odbc())

## -----------------------------------------------------------------------------
library(dplyr)

BostonHousing %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## -----------------------------------------------------------------------------
str(pm$terms[1:2])

