## ----setup, include = FALSE---------------------------------------------------
if (
  requireNamespace("mixOmics", quietly = TRUE) &&
    requireNamespace("plsmod", quietly = TRUE)
) {
  library(tidypredict)
  library(dplyr)
  eval_code <- TRUE
} else {
  eval_code <- FALSE
}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = eval_code
)

## -----------------------------------------------------------------------------
x <- as.matrix(mtcars[c("cyl", "disp", "hp", "drat")])
model <- mixOmics::pls(x, mtcars$mpg, ncomp = 2)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
library(dplyr)

mtcars %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, mtcars)

## -----------------------------------------------------------------------------
da_model <- mixOmics::splsda(as.matrix(iris[1:4]), iris$Species, ncomp = 2)

fit <- tidypredict_fit(da_model)
names(fit)
fit[["setosa"]]

## -----------------------------------------------------------------------------
library(parsnip)
library(plsmod)

p_model <- pls(num_comp = 2) %>%
  set_engine("mixOmics") %>%
  set_mode("regression") %>%
  fit(mpg ~ disp + hp + drat, data = mtcars)

tidypredict_fit(p_model)

## -----------------------------------------------------------------------------
cars <- transform(mtcars, gear = factor(gear))

c_model <- pls(num_comp = 2) %>%
  set_engine("mixOmics") %>%
  set_mode("regression") %>%
  fit(mpg ~ disp + hp + gear, data = cars)

tidypredict_fit(c_model)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

