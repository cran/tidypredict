## ----setup, include = FALSE---------------------------------------------------
if (requireNamespace("lightgbm", quietly = TRUE)) {
  library(tidypredict)
  library(lightgbm)
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
library(lightgbm)

# Prepare data
X <- data.matrix(mtcars[, c("mpg", "cyl", "disp")])
y <- mtcars$hp

dtrain <- lgb.Dataset(X, label = y, colnames = c("mpg", "cyl", "disp"))

model <- lgb.train(
  params = list(
    num_leaves = 4L,
    learning_rate = 0.5,
    objective = "regression",
    min_data_in_leaf = 1L
  ),
  data = dtrain,
  nrounds = 10L,
  verbose = -1L
)

## -----------------------------------------------------------------------------
tidypredict_fit(model)

## -----------------------------------------------------------------------------
library(dplyr)

mtcars %>%
  tidypredict_to_column(model) %>%
  glimpse()

## -----------------------------------------------------------------------------
tidypredict_test(model, xg_df = X)

## -----------------------------------------------------------------------------
X_bin <- data.matrix(mtcars[, c("mpg", "cyl", "disp")])
y_bin <- mtcars$am

dtrain_bin <- lgb.Dataset(X_bin, label = y_bin, colnames = c("mpg", "cyl", "disp"))

model_bin <- lgb.train(
  params = list(
    num_leaves = 4L,
    learning_rate = 0.5,
    objective = "binary",
    min_data_in_leaf = 1L
  ),
  data = dtrain_bin,
  nrounds = 10L,
  verbose = -1L
)

tidypredict_test(model_bin, xg_df = X_bin)

## -----------------------------------------------------------------------------
X_iris <- data.matrix(iris[, 1:4])
colnames(X_iris) <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
y_iris <- as.integer(iris$Species) - 1L

dtrain_iris <- lgb.Dataset(X_iris, label = y_iris, colnames = colnames(X_iris))

model_multi <- lgb.train(
  params = list(
    num_leaves = 4L,
    learning_rate = 0.5,
    objective = "multiclass",
    num_class = 3L,
    min_data_in_leaf = 1L
  ),
  data = dtrain_iris,
  nrounds = 5L,
  verbose = -1L
)

fit_formulas <- tidypredict_fit(model_multi)
names(fit_formulas)

## -----------------------------------------------------------------------------
iris %>%
  mutate(
    prob_setosa = !!fit_formulas$class_0,
    prob_versicolor = !!fit_formulas$class_1,
    prob_virginica = !!fit_formulas$class_2
  ) %>%
  select(Species, starts_with("prob_")) %>%
  head()

## -----------------------------------------------------------------------------
set.seed(123)
n <- 200
cat_data <- data.frame(
  cat_feat = sample(0:3, n, replace = TRUE),
  y = NA
)
cat_data$y <- ifelse(cat_data$cat_feat %in% c(0, 1), 10, -10) + rnorm(n, sd = 2)

X_cat <- matrix(cat_data$cat_feat, ncol = 1)
colnames(X_cat) <- "cat_feat"

dtrain_cat <- lgb.Dataset(
  X_cat,
  label = cat_data$y,
  categorical_feature = "cat_feat"
)

model_cat <- lgb.train(
  params = list(
    num_leaves = 4L,
    learning_rate = 1.0,
    objective = "regression",
    min_data_in_leaf = 1L
  ),
  data = dtrain_cat,
  nrounds = 2L,
  verbose = -1L
)

tidypredict_fit(model_cat)

## ----eval = requireNamespace("parsnip", quietly = TRUE) && requireNamespace("bonsai", quietly = TRUE)----
library(parsnip)
library(bonsai)

p_model <- boost_tree(
  trees = 10,
  tree_depth = 3,
  min_n = 1
) %>%
  set_engine("lightgbm") %>%
  set_mode("regression") %>%
  fit(hp ~ mpg + cyl + disp, data = mtcars)

# Extract the underlying lgb.Booster
lgb_model <- p_model$fit

tidypredict_test(lgb_model, xg_df = X)

## -----------------------------------------------------------------------------
pm <- parse_model(model)
str(pm, 2)

## -----------------------------------------------------------------------------
str(pm$trees[1])

