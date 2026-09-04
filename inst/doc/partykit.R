## ----pre, include = FALSE-----------------------------------------------------
if (!rlang::is_installed("partykit")) {
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
library(partykit)
library(parsnip)
set.seed(100)

## -----------------------------------------------------------------------------
library(dplyr)
library(tidypredict)
library(partykit)

model <- cforest(mpg ~ wt + cyl, data = mtcars, ntree = 5)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## ----eval = rlang::is_installed("bonsai")-------------------------------------
library(bonsai)
library(parsnip)

parsnip_model <- rand_forest(mode = "regression", trees = 5) %>%
  set_engine("partykit") %>%
  fit(mpg ~ wt + cyl, data = mtcars)

tidypredict_fit(parsnip_model)

