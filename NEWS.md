# fakemake 1.4.2

* Changed coverage code in the package makelists to detach package after
  covering.
* Splitted the vignette into two.
* Fixed target "build" in provide\_make\_list().
* Fixed tryCatch-Targets to write to log-directory.
* For verbose = TRUE, the current make target is now being reported.
* Package make target cyclocomp now requires roxygen.
* Added a package makelist `cran` that omits cyclocomp and now using it in
  vignette.

# fakemake 1.4.1

* Suggest rather than import pkgbuild.

# fakemake 1.4.0

* Adjusted to devtools 2.0.0 (devtools was split into several packages).

# fakemake 1.3.0

* Added cyclocomp to the "package" makelist.

# fakemake 1.2.0

* Added make\_list "standard", enhancing "package" by adding the creation of the
  log directory and using it as prerequisite.

# fakemake 1.1.0

* Fixed recursive treatment of argument `verbose` to function `make`.
* Fixed internal function `package\_makelist` to using `devtools::test` instead 
  `testthat::test_package` directly (the former is a wrapper to the latter).
* Now `package\_makelist` is printing output from roxygen2, testthat, cleanr and
  devtools::build to harmonize logs.

# fakemake 1.0.2

* Disabled RUnit tests for OSX and R Versions older than 3.4.0.

# fakemake 1.0.1

* Replaced file.show(x, pager = "cat") with cat(readLines(x), sep = "\"n) in
  examples as they did not pass checks on windows.
* Fixed example path for windows. 

# fakemake 1.0.0

* Added a `NEWS.md` file to track changes to the package.



