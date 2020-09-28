## ----create_package, results = "hide", message = FALSE------------------------
pkg_path <- file.path(tempdir(), "fakepack")
unlink(pkg_path, force = TRUE, recursive = TRUE)
usethis::create_package(pkg_path)

## -----------------------------------------------------------------------------
file.copy(system.file("templates", "throw.R", package = "fakemake"),
          file.path(pkg_path, "R"))

## -----------------------------------------------------------------------------
ml <-  fakemake::provide_make_list("vignette")

## ----fig.width = 6.8, fig.height = 6.8----------------------------------------
withr::with_dir(pkg_path, fakemake::visualize(ml))

## ----fig.width = 6.8, fig.height = 6.8----------------------------------------
withr::with_dir(pkg_path, fakemake::visualize(ml, root = "log/check.Rout"))

## -----------------------------------------------------------------------------
index <- which(sapply(ml, function(x) x["alias"] == "build"))
ml[[index]]

## -----------------------------------------------------------------------------
index <- which(sapply(ml, function(x) x["alias"] == "roxygen2"))
ml[[index]][["prerequisites"]]

## ---- warning = FALSE, message = FALSE----------------------------------------
withr::with_dir(pkg_path, print(fakemake::make("check", ml)))


## ---- warning = FALSE, message = FALSE----------------------------------------
if ("fakepack" %in% .packages()) detach("package:fakepack", unload = TRUE)


## -----------------------------------------------------------------------------
list.files(file.path(pkg_path, "log"))

## -----------------------------------------------------------------------------
cat(readLines(file.path(pkg_path, "log", "check.Rout")), sep = "\n")

## -----------------------------------------------------------------------------
system.time(suppressMessages(withr::with_dir(pkg_path,
                                             print(fakemake::make("check",
                                                                  ml)))))

## -----------------------------------------------------------------------------
cat(readLines(file.path(pkg_path, "log", "covr.Rout")), sep = "\n")

## -----------------------------------------------------------------------------
dir.create(file.path(pkg_path, "tests", "testthat"), recursive = TRUE)
file.copy(system.file("templates", "testthat.R", package = "fakemake"),
          file.path(pkg_path, "tests"))
file.copy(system.file("templates", "test-throw.R", package = "fakemake"),
          file.path(pkg_path, "tests", "testthat"))


## ----fig.width = 6.8, fig.height = 6.8----------------------------------------
withr::with_dir(pkg_path, fakemake::visualize(ml))

## ---- warning = FALSE, message = FALSE----------------------------------------
withr::with_dir(pkg_path, print(fakemake::make("build", ml)))

## -----------------------------------------------------------------------------
cat(readLines(file.path(pkg_path, "log", "covr.Rout")), sep = "\n")

