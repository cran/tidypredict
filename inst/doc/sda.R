## ----setup, include = FALSE---------------------------------------------------
if (requireNamespace("sda", quietly = TRUE)) {
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
model <- sda::sda(as.matrix(iris[1:4]), iris$Species, verbose = FALSE)

## -----------------------------------------------------------------------------
fit <- tidypredict_fit(model)
names(fit)
fit[["setosa"]]

## -----------------------------------------------------------------------------
library(dplyr)

iris %>%
  mutate(!!!tidypredict_fit(model)) %>%
  glimpse()

## -----------------------------------------------------------------------------
probs <- sapply(fit, \(f) rlang::eval_tidy(f, iris))
posterior <- predict(model, as.matrix(iris[1:4]), verbose = FALSE)
all.equal(unname(probs), unname(posterior$posterior))

## -----------------------------------------------------------------------------
library(parsnip)
library(discrim)

p_model <- discrim_linear() %>%
  set_engine("sda") %>%
  fit(Species ~ ., data = iris)

## -----------------------------------------------------------------------------
tidypredict_fit(p_model)[["virginica"]]

## -----------------------------------------------------------------------------
cars <- transform(mtcars, cyl = factor(cyl), gear = factor(gear))

c_model <- discrim_linear() %>%
  set_engine("sda") %>%
  fit(cyl ~ mpg + gear + disp, data = cars)

tidypredict_fit(c_model)[["8"]]

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

