if (interactive()) pkgload::load_all()

test_package_path <- function() {
    old <- setwd(tempdir())
    on.exit(setwd(old))
    package_path <- file.path(tempdir(), "anRpackage")
    usethis::create_package(path = package_path)
    result <- packager::get_pkg_archive_path(package_path)
    expectation <- file.path(tempdir(),
                             "anRpackage", "anRpackage_0.0.0.9000.tar.gz")
    if (identical(.Platform[["OS.type"]], "unix")) {
        # on windows, tempdir() might be long and get abbreviated with a tilde,
        # making this test fail. Works on unix though (where dirname(tempdir())
        # is usually just "/tmp"
        RUnit::checkIdentical(result, expectation)
    }
}

if (Sys.info()["nodename"] == "h6") {
test_check_archive <- function() {
    old <- setwd(tempdir())
    on.exit(setwd(old))
    package_path <- file.path(tempdir(), "fakepack")
    usethis::create_package(path = package_path)
    file.copy(system.file("templates", "throw.R", package = "fakemake"),
              file.path(package_path, "R"))
    roxygen2::roxygenize(package_path)
    tarball <- packager::get_pkg_archive_path(package_path)
    devtools::build(pkg = package_path, path = package_path)
    result <- packager::check_archive(tarball)
    RUnit::checkTrue(result[["status"]] == 0)
    result <- packager::check_archive_as_cran(tarball)
    RUnit::checkTrue(result[["status"]] == 0)
}
}

test_touch <- function() {
    file <- tempfile()
    touch(file)
    t1 <- file.mtime(file)
    touch(file)
    t2 <- file.mtime(file)
    RUnit::checkTrue(t1 < t2)
}
