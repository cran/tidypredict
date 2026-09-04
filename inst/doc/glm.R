## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

source("_threads.R")
library(dplyr)
library(tidypredict)

## -----------------------------------------------------------------------------
library(tidypredict)
library(dplyr)

df <- mtcars %>%
  mutate(char_cyl = paste0("cyl", cyl)) %>%
  select(wt, char_cyl, am)

model <- glm(am ~ wt + char_cyl, data = df, family = "binomial")

## -----------------------------------------------------------------------------
library(tidypredict)
tidypredict_sql(model, dbplyr::simulate_mssql())

## -----------------------------------------------------------------------------
df %>%
  tidypredict_to_column(model) %>%
  head(10)

## -----------------------------------------------------------------------------
probit_model <- glm(
  am ~ wt + mpg,
  data = mtcars,
  family = binomial(link = "probit")
)

max(abs(
  predict(probit_model, mtcars, type = "response") -
    rlang::eval_tidy(tidypredict_fit(probit_model), mtcars)
))

## -----------------------------------------------------------------------------
tidypredict_test(probit_model)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
tidypredict_test(model)

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- linear_reg() %>%
  set_engine("glm") %>%
  fit(am ~ wt + cyl, data = mtcars)

tidypredict_fit(parsnip_model)

## ----eval = requireNamespace("LiblineaR", quietly = TRUE)---------------------
liblinear_model <- logistic_reg(penalty = 0.1) %>%
  set_engine("LiblineaR") %>%
  fit(factor(am) ~ mpg + cyl, data = mtcars)

tidypredict_fit(liblinear_model)

