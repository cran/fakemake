# fakemake 1.9.0

* Updated vignettes.

# fakemake 1.8.1

* Removed `callr` and `withr` from the Depends-Field in file DESCRIPTION.

# fakemake 1.8.0

* Removed deprecated functions `get_pkg_archive_path`,
    `check_archive` and `check_archive_as_cran` that are now in packager. 
* Fixed testing via gitlab-ci.

# fakemake 1.7.2

* Fix help links to package `callr` following request
  Deepayan Sarkar (see https://deepayan.github.io/tmp/topichelp/funs.html).

# fakemake 1.7.1

* Skipping RUnit testing on non-Windows and non-Linux platforms.
  CRAN reported errors in testing on MacOS X only.

# fakemake 1.7.0

* Functions `check_archive`, `check_archive_as_cran` and `get_pkg_archive_path`
  are now deprecated: they have moved to CRAN package `packager`. Their
  documentation is tagged as internal.
* Tagged documentation for functions `read_makefile`, `write_makefile`,
  `sink_all` and `touch` as internal.
* Changed the default to function `make`'s `verbose` option to `FALSE`.
* Added arguemnt `dry_run` to function `make` that mocks make's -n option 
  (i.e. "Don't actually run any recipe; just print them.").

# fakemake 1.6.0

* Added  functions `add_target`, `get_target` and `remove_target` to facilitate
  the manipulation of makelists.

# fakemake 1.5.0

* Package makelist "package" (and its alias "standard") now includes testthat 
  and runit.
* Package makelist "cran" (and its alias "vignette") now excludes testthat.
* Target "cleanr" now catches errors thrown by package cleanr.

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



