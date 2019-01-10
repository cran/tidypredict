
# tidypredict <img src="man/figures/logo.png" align="right" width = "140px"/>

[![Build
Status](https://travis-ci.org/edgararuiz/tidypredict.svg?branch=master)](https://travis-ci.org/edgararuiz/tidypredict)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/tidypredict)](http://cran.r-project.org/package=tidypredict)
[![Coverage
Status](https://img.shields.io/codecov/c/github/edgararuiz/tidypredict/master.svg)](https://codecov.io/github/edgararuiz/tidypredict?branch=master)

[![Downloads](https://cranlogs.r-pkg.org/badges/tidypredict)]()

Run predictions inside the database. `tidypredict` parses a fitted R
model object, and returns a formula in ‘Tidy Eval’ code that calculates
the predictions.

<img src="man/figures/howitworks.PNG" align="right" width = "600px"/>

**It works with several databases back-ends** because it leverages
`dplyr` and `dbplyr` for the final SQL translation of the algorithm. It
currently supports `lm()`, `glm()`, `randomForest()`, `ranger()` ane
`earth()` models.

## Installation

Install `tidypredict` from CRAN using:

``` r
install.packages("tidypredict")
```

Or install the development version using `devtools` as follows:

``` r
devtools::install_github("edgararuiz/tidypredict")
```

## Intro

`tidypredict` is able to parse an R model object, such as:

``` r
model <- lm(mpg ~ wt + cyl, data = mtcars)
```

And then creates the SQL statement needed to calculate the fitted
prediction:

``` r
tidypredict_sql(model, dbplyr::simulate_mssql())
```

    ## <SQL> 39.6862614802529 + (`wt` * -3.19097213898374) + (`cyl` * -1.5077949682598)

## Supported models

The following models are supported:

  - Linear Regression - `lm()`
  - Generalized Linear model - `glm()`
  - Random Forest models - `randomForest::randomForest()`
  - Random Forest models, via `ranger` - `ranger::ranger()`
  - MARS models - `earth::earth()`
