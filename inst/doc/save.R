## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(tidypredict)

## -----------------------------------------------------------------------------
model <- lm(mpg ~ (wt + disp) * cyl, data = mtcars)

## -----------------------------------------------------------------------------
library(tidypredict)

parsed <- parse_model(model)
str(parsed, 2)

## -----------------------------------------------------------------------------
tidypredict_fit(parsed)

## ----include = FALSE----------------------------------------------------------
model_file <- tempfile(fileext = ".yml")
tidypredict_save(parsed, model_file)
loaded_model <- tidypredict_load(model_file)

## ----eval = FALSE-------------------------------------------------------------
# tidypredict_save(parsed, "my_model.yml")

## ----eval = FALSE-------------------------------------------------------------
# tidypredict_save(model, "my_model.yml")

## ----eval = FALSE-------------------------------------------------------------
# library(tidypredict)
# 
# loaded_model <- tidypredict_load("my_model.yml")

## -----------------------------------------------------------------------------
str(loaded_model, 2)

## -----------------------------------------------------------------------------
tidypredict_fit(loaded_model)

## -----------------------------------------------------------------------------
tidypredict_sql(loaded_model, dbplyr::simulate_odbc())

## -----------------------------------------------------------------------------
tidy(loaded_model)

