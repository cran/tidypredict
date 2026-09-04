## ----setup, include = FALSE---------------------------------------------------
if (requireNamespace("sparsediscrim", quietly = TRUE)) {
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
model <- sparsediscrim::lda_diag(Species ~ ., data = iris)

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
posterior <- predict(model, iris, type = "prob")
all.equal(unname(probs), unname(as.matrix(posterior)))

## -----------------------------------------------------------------------------
library(parsnip)
library(discrim)

p_model <- discrim_linear(regularization_method = "shrink_mean") %>%
  set_engine("sparsediscrim") %>%
  fit(Species ~ ., data = iris)

## -----------------------------------------------------------------------------
tidypredict_fit(p_model)[["virginica"]]

## -----------------------------------------------------------------------------
cars <- transform(mtcars, vs = factor(vs), gear = factor(gear))

c_model <- discrim_linear() %>%
  set_engine("sparsediscrim") %>%
  fit(vs ~ mpg + gear + disp, data = cars)

tidypredict_fit(c_model)[["1"]]

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

