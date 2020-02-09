## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(dplyr)
library(tidypredict)
library(parsnip)

## -----------------------------------------------------------------------------
library(dplyr)
library(tidypredict)

df <- mtcars %>%
  mutate(char_cyl = paste0("cyl", cyl)) %>%
  select(mpg, wt, char_cyl, am) 

model <- lm(mpg ~ wt + char_cyl, offset = am, data = df)

## -----------------------------------------------------------------------------
library(tidypredict)
tidypredict_sql(model, dbplyr::simulate_mssql())

## -----------------------------------------------------------------------------
df %>%
  tidypredict_to_column(model) %>%
  head(10) 

## -----------------------------------------------------------------------------
tidypredict_sql_interval(model, dbplyr::simulate_mssql())

## -----------------------------------------------------------------------------
df %>%
  tidypredict_to_column(model, add_interval = TRUE) %>%
  head(10)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
tidypredict_interval(model)

## -----------------------------------------------------------------------------
tidypredict_test(model)

## -----------------------------------------------------------------------------
tidypredict_test(model, include_intervals = TRUE)

## -----------------------------------------------------------------------------
library(parsnip)

parsnip_model <- linear_reg() %>%
  set_engine("lm") %>%
  fit(mpg ~ wt + cyl, offset = am, data = mtcars)

tidypredict_fit(parsnip_model)

