[![pipeline status](https://gitlab.com/fvafrcu/fakemake/badges/master/pipeline.svg)](https://gitlab.com/fvafrcu/fakemake/-/commits/master)    
[![coverage report](https://gitlab.com/fvafrcu/fakemake/badges/master/coverage.svg)](https://gitlab.com/fvafrcu/fakemake/-/commits/master)
<!-- 
    [![Build Status](https://travis-ci.org/fvafrcu/fakemake.svg?branch=master)](https://travis-ci.org/fvafrcu/fakemake)
    [![Coverage Status](https://codecov.io/github/fvafrcu/fakemake/coverage.svg?branch=master)](https://codecov.io/github/fvafrcu/fakemake?branch=master)
-->
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/fakemake)](https://cran.r-project.org/package=fakemake)
[![RStudio_downloads_monthly](https://cranlogs.r-pkg.org/badges/fakemake)](https://cran.r-project.org/package=fakemake)
[![RStudio_downloads_total](https://cranlogs.r-pkg.org/badges/grand-total/fakemake)](https://cran.r-project.org/package=fakemake)

<!-- README.md is generated from README.Rmd. Please edit that file -->



# fakemake
## Introduction
After installation, please read the help page:

```r
help("fakemake-package", package = "fakemake")
```

```
#> Mock the Unix Make Utility
#> 
#> Description:
#> 
#>      Use R as a minimal build system. This might come in handy if you
#>      are developing R packages and can not use a proper build system.
#>      Stay away if you can (use a proper build system).
#> 
#> Details:
#> 
#>      You will find the details in
#>      'vignette("An_Introduction_to_fakemake", package = "fakemake")'.
```

## Installation

You can install fakemake from gitlab with:


```r
if (! require("remotes")) install.packages("remotes")
remotes::install_gitlab("fvafrcu/fakemake")
```


