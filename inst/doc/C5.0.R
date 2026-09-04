## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(dplyr)
library(tidypredict)
library(C50)
set.seed(100)

## -----------------------------------------------------------------------------
library(dplyr)
library(tidypredict)
library(C50)

mtcars2 <- mtcars
mtcars2$vs <- factor(mtcars2$vs)

model <- C5.0(mtcars2[, c("wt", "cyl", "mpg")], mtcars2$vs)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
mtcars3 <- mtcars2
mtcars3$gear <- factor(mtcars3$gear)

model_cat <- C5.0(mtcars3[, c("wt", "gear", "mpg")], mtcars3$vs)
tidypredict_fit(model_cat)

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- decision_tree(mode = "classification") |>
  set_engine("C5.0") |>
  fit(vs ~ wt + cyl + mpg, data = mtcars2)

tidypredict_fit(parsnip_model)

## -----------------------------------------------------------------------------
boosted_model <- boost_tree(mode = "classification", trees = 5) |>
  set_engine("C5.0") |>
  fit(Species ~ ., data = iris)

tidypredict_fit(boosted_model)

## -----------------------------------------------------------------------------
rule_model <- C5.0(iris[, 1:4], iris$Species, rules = TRUE)

tidypredict_fit(rule_model)

