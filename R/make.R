#' Mock the Unix Make Utility
#'
#' @param make_list The \code{makelist} (a listed version of a
#' \command{Makefile}).
#' @param name The name or alias of a make target.
#' @param force Force the target to be build?
#' See \emph{Details}.
#' @details 
#' \code{force, recursive}\cr
#' Forcing a target mocks adding .PHONY to a GNU \command{Makefile} if you
#' set recursive to FALSE. If recursive is TRUE, then the whole make chain will
#' be forced.
#' @param recursive Force the target to be build recursively? 
#' See \emph{Details}.
#' @param verbose Be verbose?
#' @param verbosity Give the level of verbosity.
#' @param dry_run Run dry? Mock GNU \command{make}'s -n option.
#' @param unconditionally Force the target's code to be evaluated
#' unconditionally to any prerequisites?
#' See \emph{Details}.
#' @details
#' \code{unconditionally}\cr
#' Setting \code{unconditionally} to \code{\link{TRUE}} allows you to fool
#' \code{\link{make}} similarily to using GNU \command{make}'s --touch option.
#' @param stop_on_warning \code{\link[base:stop]{Throw an error and abort}} if 
#' a recipe throws a
#' \code{\link{warning}}?
#'
#' @return \code{\link[base:invisible]{Invisibly}} a character vector
#' containing the targets made during the current run.
#' @export
#' @examples
#' str(make_list <- provide_make_list("minimal"))
#' # build all
#' withr::with_dir(tempdir(), print(make("all.Rout", make_list)))
#' # nothing to be done
#' withr::with_dir(tempdir(), print(make("all.Rout", make_list)))
#' # forcing all.Rout
#' withr::with_dir(tempdir(), print(make("all.Rout", make_list, force = TRUE,
#'                                       recursive = FALSE)))
#' # forcing all.Rout recursively
#' withr::with_dir(tempdir(), print(make("all.Rout", make_list, force = TRUE))) 
#'
#' # show files
#' dir(tempdir(), pattern = ".*\\.Rout")
#' 
#' # dry run
#' file.remove(dir(tempdir(), pattern = ".*\\.Rout", full.names = TRUE))
#' withr::with_dir(tempdir(), print(make("all.Rout", make_list,
#'                                       dry_run = TRUE)))
#' dir(tempdir(), pattern = ".*\\.Rout")
#'
#' # make unconditionally
#' dir(tempdir(), pattern = ".*\\.Rout")
#' withr::with_dir(tempdir(), print(make("all.Rout", make_list,
#'                                       unconditionally = TRUE)))
#' dir(tempdir(), pattern = ".*\\.Rout")
#' \dontshow{
#' is_wrong_os <- .Platform[["OS.type"]] == "windows" || grepl("^darwin",
#'                                                             R.version$os)
#' is_current_version <- compareVersion(paste(getRversion(), sep = "."),
#'                                      "3.4.0") >= 1
#' if (is_current_version && ! is_wrong_os) {
#' withr::with_dir(tempdir(), {
#'                 str(make_list <- provide_make_list(type = "minimal"))
#'                 make(make_list[[1]][["target"]], make_list)
#'
#' #% rerun
#' # need to sleep on fast machine as the file modification times are identical
#' # otherwise.
#' Sys.sleep(1)
#' src <- file.path(tempdir(), "src")
#' dir.create(src)
#' cat('print("foo")', file = file.path(src, "foo.R"))
#' cat('print("bar")', file = file.path(src, "bar.R"))
#' make_list[[4]]["code"] <- "lapply(list.files(src, full.names = TRUE),
#'                                   source)"
#' make_list[[4]]["prerequisites"] <- "list.files(src, full.names = TRUE)"
#'
#' #% make with updated source files
#' expectation <- make_list[[4]][["target"]]
#' result <- make(make_list[[4]][["target"]], make_list)
#' print(result)
#' RUnit::checkTrue(identical(result, expectation))
#'
#' #% rerun
#' # need to sleep on fast machine as the file modification times are identical
#' # otherwise.
#' Sys.sleep(1)
#' expectation <- NULL
#' result <- make(make_list[[4]][["target"]], make_list)
#' RUnit::checkTrue(identical(result, expectation))
#'
#' #% touch source file and rerun
#' fakemake:::touch(file.path(src, "bar.R"))
#' expectation <- make_list[[4]][["target"]]
#' result <- make(make_list[[4]][["target"]], make_list)
#' RUnit::checkTrue(identical(result, expectation))
#' }
#' )
#' }
#' }
make <- function(name, make_list, force = FALSE, recursive = force,
                 verbose = FALSE, verbosity = 2, dry_run = FALSE, 
                 unconditionally = FALSE, stop_on_warning = FALSE) {
    check_makelist(make_list)
    res <- NULL
    make_list <- parse_make_list(make_list)
    targets <- sapply(make_list, "[[", "target")
    index <- which(targets == name)
    if (identical(index, integer(0))) {
        # If name doesn't match any target, see if it matches an alias.
        index <- which(lapply(make_list, "[[", "alias") == name)
    }
    if (identical(index, integer(0))) {
        if (file.exists(name)) {
            if (isTRUE(verbose) && verbosity >= 3)
                message("Prerequisite ", name, " found.")
        } else {
            throw(paste0("There is no rule to make ", name, "."))
        }
    } else {
        target <- targets[index]
        if (isTRUE(unconditionally)) {
            message("Creating target ", target, 
                    " unconditionally on user request!")
        } else {
            prerequisites <- make_list[[index]][["prerequisites"]]
            if (! is.null(prerequisites)) {
                for (p in sort(prerequisites)) {
                    res <- c(res, make(name = p, make_list = make_list,
                                       force = force && isTRUE(recursive),
                                       recursive = recursive, verbose = verbose,
                                       verbosity = verbosity, 
                                       unconditionally = unconditionally,
                                       stop_on_warning = stop_on_warning,
                                       dry_run = dry_run))
                }
            }
        }
        is_phony <- isTRUE(make_list[[index]][[".PHONY"]]) || isTRUE(force)
        is_to_be_made <- is_to_be_made(target = target, is_phony = is_phony,
                                       prerequisites = prerequisites)
        if (is_to_be_made) {
            if (isTRUE(verbose) && verbosity >= 1)
                message("Current target is: ", target, ".")
            if (!isTRUE(dry_run)) {
                made <- tryCatch(
                                 sink_all(path = make_list[[index]][["sink"]],
                                          code = eval(parse(text = make_list[[index]][["code"]]))),
                                 warning = identity,
                                 error = identity)
                if (inherits(made, "warning")) {
                    writeLines(made[["message"]],
                               con = make_list[[index]][["sink"]])
                    if (isTRUE(stop_on_warning)) throw(made[["message"]])
                }
                if (inherits(made, "error")) {
                    writeLines(as.character(made),
                               con = make_list[[index]][["sink"]])
                    throw(made[["message"]])
                }
                # If the code does not create the target, file modification
                # times will fail. So we force the target:
                if (! file.exists(target))
                    cat("Make target auto-generated by fakemake.\n", 
                        file = target)
                if (isTRUE(verbose) && verbosity >= 2)
                    cat(readLines(make_list[[index]][["sink"]]), sep = "\n")
            }
            res <- c(res, target)
        }
    }
    return(invisible(res))
}
