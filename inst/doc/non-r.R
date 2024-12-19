## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(yaml)

sklearn_model <- strsplit("general:
  is_glm: 0
  model: lm
  residual: 0
  sigma2: 0
  type: regression
  version: 2.0
terms:
- coef: 152.76430691633442
  fields:
  - col: (Intercept)
    type: ordinary
  is_intercept: 1
  label: (Intercept)
- coef: 0.3034995490660432
  fields:
  - col: age
    type: ordinary
  is_intercept: 0
  label: age
- coef: -237.63931533353403
  fields:
  - col: sex
    type: ordinary
  is_intercept: 0
  label: sex
- coef: 510.5306054362253
  fields:
  - col: bmi
    type: ordinary
  is_intercept: 0
  label: bmi
- coef: 327.7369804093466
  fields:
  - col: bp
    type: ordinary
  is_intercept: 0
  label: bp
- coef: -814.1317093725387
  fields:
  - col: s1
    type: ordinary
  is_intercept: 0
  label: s1
", split = "\n")[[1]]

## -----------------------------------------------------------------------------
sklearn_model <- yaml.load(sklearn_model)

str(sklearn_model, 2)

## -----------------------------------------------------------------------------
library(tidypredict)

spm <- as_parsed_model(sklearn_model)

class(spm)

## -----------------------------------------------------------------------------
tidypredict_fit(spm)

## -----------------------------------------------------------------------------
tidypredict_sql(spm, dbplyr::simulate_mssql())

## -----------------------------------------------------------------------------
tidy(spm)

