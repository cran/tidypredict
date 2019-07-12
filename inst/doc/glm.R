## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(dplyr)
library(tidypredict)

## ------------------------------------------------------------------------
library(tidypredict)
library(dplyr)

df <- mtcars %>%
  mutate(char_cyl = paste0("cyl", cyl)) %>%
  select(wt, char_cyl, am) 

model <- glm(am ~ wt + char_cyl, data = df, family = "binomial")

## ------------------------------------------------------------------------
library(tidypredict)
tidypredict_sql(model, dbplyr::simulate_mssql())

## ------------------------------------------------------------------------
df %>%
  tidypredict_to_column(model) %>%
  head(10) 

## ------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## ------------------------------------------------------------------------
tidypredict_fit(model)

## ------------------------------------------------------------------------
tidypredict_test(model)

