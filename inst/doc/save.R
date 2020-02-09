## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(tidypredict)
library(yaml)

## -----------------------------------------------------------------------------
model <- lm(mpg ~ (wt + disp) * cyl, data = mtcars)

## -----------------------------------------------------------------------------
library(tidypredict)

parsed <- parse_model(model)
str(parsed, 2)

## -----------------------------------------------------------------------------
tidypredict_fit(parsed)

## ---- include = FALSE---------------------------------------------------------
library(yaml)
model_file <- tempfile(fileext = ".yml")
write_yaml(parsed, model_file)
loaded_model <- read_yaml(model_file)
loaded_model <- as_parsed_model(loaded_model)

## ---- eval = FALSE------------------------------------------------------------
#  library(yaml)
#  
#  write_yaml(parsed, "my_model.yml")

## ---- eval = FALSE------------------------------------------------------------
#  library(tidypredict)
#  library(yaml)
#  
#  loaded_model <- read_yaml("my_model")
#  
#  loaded_model <- as_parsed_model(loaded_model)

## -----------------------------------------------------------------------------
str(loaded_model, 2)

## -----------------------------------------------------------------------------
tidypredict_fit(loaded_model)

## -----------------------------------------------------------------------------
tidypredict_sql(loaded_model, dbplyr::simulate_odbc())

## -----------------------------------------------------------------------------
tidy(loaded_model)

