[![pipeline status](https://gitlab.com/fvafrCU/fakemake/badges/master/pipeline.svg)](https://gitlab.com/fvafrCU/fakemake/commits/master)    
[![coverage report](https://gitlab.com/fvafrCU/fakemake/badges/master/coverage.svg)](https://gitlab.com/fvafrCU/fakemake/commits/master)
<!-- 
    [![Build Status](https://travis-ci.org/fvafrCU/fakemake.svg?branch=master)](https://travis-ci.org/fvafrCU/fakemake)
    [![Coverage Status](https://codecov.io/github/fvafrCU/fakemake/coverage.svg?branch=master)](https://codecov.io/github/fvafrCU/fakemake?branch=master)
-->
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/fakemake)](https://cran.r-project.org/package=fakemake)
[![RStudio_downloads_monthly](https://cranlogs.r-pkg.org/badges/fakemake)](https://cran.r-project.org/package=fakemake)
[![RStudio_downloads_total](https://cranlogs.r-pkg.org/badges/grand-total/fakemake)](https://cran.r-project.org/package=fakemake)

<!-- README.md is generated from README.Rmd. Please edit that file -->



# fakemake
## Introduction
Please read the
[vignette](https://CRAN.R-project.org/package=fakemake/vignettes/An_Introduction_to_fakemake.html).

Or, after installation, the help page:

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
remotes::install_gitlab("fvafrCU/fakemake")
```


