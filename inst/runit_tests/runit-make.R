if (interactive()) pkgload::load_all()

test_make_success <- function() {
    old <- setwd(tempdir())
    on.exit(setwd(old))
    ml <- fakemake:::prune_list(fakemake::provide_make_list(type = "testing"))
    if (interactive()) visualize(ml)

    #% make the succeeding target
    unlink(list.files(tempdir(), pattern = ".*\\.Rout", full.names = TRUE))
    result <- make("all.Rout", ml)
    expectation <- c("message1.Rout", "message2.Rout", "warning2.Rout", 
                     "all.Rout")
    RUnit::checkIdentical(result, expectation)
    # check the contents
    result_files <- list.files(tempdir(), pattern = ".*\\.Rout", 
                               full.names = TRUE)
    # These files where created via
    # > make -f Makefile_testing
    expected_files <- file.path(system.file("templates", package = "fakemake"), 
                                basename(result_files))
    files <- basename(result_files)
    for (f in files) {
        result <- readLines(file.path(tempdir(), f))
        expectation <- readLines(system.file("templates", f,
                                             package = "fakemake"))
        if (grepl("warning.\\.Rout", f)) {
            expectation <- trimws(unlist(strsplit(expectation, split = ":"))[2])
        }
        RUnit::checkIdentical(result, expectation)
    }
}

notest_make_warning <- function() {
    old <- setwd(tempdir())
    on.exit(setwd(old))
    ml <- fakemake:::prune_list(fakemake::provide_make_list(type = "testing"))

    #% make the target
    unlink(list.files(tempdir(), pattern = ".*\\.Rout", full.names = TRUE))
    RUnit::checkException(make("warning2.Rout", ml, stop_on_warning = TRUE))
    #% check the contents
    result_files <- list.files(tempdir(), pattern = ".*\\.Rout", full.names = TRUE)
    # These files where created via
    # > make -f Makefile_testing
    expected_files <- file.path(system.file("templates", package = "fakemake"), 
                                basename(result_files))
    files <- basename(result_files)
    for (f in files) {
        result <- readLines(file.path(tempdir(), f))
        expectation <- readLines(system.file("templates", f,
                                             package = "fakemake"))
        if (grepl("warning.\\.Rout", f)) {
            expectation <- trimws(unlist(strsplit(expectation, split = ":"))[2])
        }
        RUnit::checkIdentical(result, expectation)
    }
}

test_make_error <- function() {
    old <- setwd(tempdir())
    on.exit(setwd(old))
    make_list <- fakemake:::prune_list(fakemake::provide_make_list(type = "testing"))

    #% make the target
    unlink(list.files(tempdir(), pattern = ".*\\.Rout", full.names = TRUE))
    RUnit::checkException(make("error2.Rout", make_list))

    #% check the contents
    result_files <- list.files(tempdir(), pattern = ".*\\.Rout", full.names = TRUE)
    # These files where created via
    # > make -f Makefile_testing error2.Rout
    expected_files <- file.path(system.file("templates", package = "fakemake"), 
                                basename(result_files))
    files <- basename(result_files)
    for (f in files) {
        result <- readLines(file.path(tempdir(), f))
        expectation <- readLines(system.file("templates", f,
                                                       package = "fakemake"))
        if (f == "all.Rout" || (grepl("message.\\.Rout", f))) {
            RUnit::checkIdentical(result, expectation)
        } else if (grepl("warning.\\.Rout", f)) {
            expectation <- trimws(unlist(strsplit(expectation, split = ":"))[2])
            RUnit::checkIdentical(result, expectation)
        } else {
            result <- trimws(unlist(strsplit(result[1], split = ":"))[2])
            expectation <- trimws(unlist(strsplit(expectation[1], 
                                                  split = ":"))[2])
            RUnit::checkIdentical(result, expectation)
        }
    }
}

if (interactive()) test_make_error()
