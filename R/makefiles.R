#' Write a \code{Makelist} to File
#'
#' The \code{makelist} is parsed before writing, so all \R code which is not in
#' a "code" item will be evaluated.
#' So if any other item's string contains code allowing for a dynamic rule,
#' for example with some "dependencies" reading
#' \code{"list.files(\"R\", full.names = TRUE)"}, the \command{Makefile} will
#' have the
#' evaluated code, a static list of files in the above case.
#' @param make_list The list to write to file.
#' @param path The path to the file.
#' @param Rbin The R binary to use in the \command{Makefile}.
#' @return See
#' \code{\link[MakefileR:write_makefile]{MakefileR::write_makefile}}.
#' @export
#' @keywords internal
#' @examples
#' make_file <- file.path(tempdir(), "my_Makefile")
#' write_makefile(provide_make_list(), path = make_file)
#' cat(readLines(make_file), sep = "\n")
write_makefile <- function(make_list, path,
                           Rbin = "Rscript-devel") {
    check_makelist(make_list)
    make_list <- parse_make_list(make_list)
    m <- MakefileR::makefile() +
        MakefileR::make_comment(paste0("Modified by fakemake ",
                                       utils::packageVersion("fakemake"),
                                       ", do not edit by hand."))
    m <- m + MakefileR::make_group(MakefileR::make_comment("Ensure POSIX"),
                                   MakefileR::make_rule(".POSIX"))
    m <- m + MakefileR::make_def("R_engine", Rbin)
    R_call <- "$(R_engine) --vanilla -e "
    for (e in make_list) {
        if (isTRUE(e[[".PHONY"]]))
            m <- m + MakefileR::make_rule(".PHONY", e[["target"]])
        m <- m + MakefileR::make_rule(e[["target"]],
                                      deps = e[["prerequisites"]],
                                      script = paste0(R_call,
                                                      "'fakemake::sink_all(",
                                                      '"', (e[["sink"]]),
                                                      '",', e[["code"]], ")'"))
    }
    return(MakefileR::write_makefile(m, path))
}

#' Read a \command{Makefile} Into a \code{Makelist}
#'
#' This is experimental! See \bold{Note}.
#'
#' @param path The path to the file. 
#' @param clean_sink Remove sinks identical to corresponding targets from the
#' list? Since \code{makelists} are parsed, missing sinks are set to the
#' corresponding targets, but this makes them harder to read.
#' @return The \code{makelist}.
#' @note This function will not read arbitrary \command{Makefiles}, just those
#' created via \code{\link{write_makefile}}! If you modify such a
#' \command{Makefile}
#' make sure you only add simple rules like the ones you see in that file.
#' @export
#' @keywords internal
#' @examples
#' make_file <- file.path(tempdir(), "Makefile")
#' write_makefile(provide_make_list(), path = make_file)
#' str(make_list <- read_makefile(path = make_file))
read_makefile <- function(path, clean_sink = FALSE) {
    lines <- readLines(path)
    lines <- grep("^$", lines, value = TRUE, invert = TRUE)
    lines <- grep("^#.*$", lines, value = TRUE, invert = TRUE)
    lines <- grep("^\\.POSIX:$", lines, value = TRUE, invert = TRUE)
    lines <- grep("^R_engine.*$", lines, value = TRUE, invert = TRUE)
    phony_lines <- grep("^\\.PHONY:", lines, value = TRUE)
    lines <- grep("^\\.PHONY:", lines, value = TRUE, invert = TRUE)
    idx <- grep("R_engine", lines)
    # add `code =`
    lines[idx]  <- sub(",", ", code =", lines[idx]) 
    # remove duplicates
    lines[idx] <- sub("(, code =) *code ?=", "\\1", lines[idx]) 
    # split by `code =`
    pattern <- paste0("\\$\\(R_engine\\) --vanilla -e ",
                      "'fakemake::sink_all\\((.*), code =(.*)\\)'")
    lines <- sub(pattern, "\\1:\\2", lines)
    separator <- "@@@"
    targets <- strsplit(gsub(paste0(separator, "\t"), ":",
                             paste(lines, collapse = separator)),
                        split = separator)
    targets <- unlist(targets)
    res <- list()
    for (target in targets) {
        parts  <-  trimws(unlist(strsplit(target, split = ":")))
        prerequisites <- unlist(strsplit(parts[2], split = " "))
        if (identical(prerequisites, character(0))) prerequisites <- NULL
        # Sink needs to go last as is it may be added by parse_make_list. Unit
        # testing may fail otherwise...
        tmp <- list(target = parts[1],
                    prerequisites = prerequisites,
                    code = parts[4],
                    sink = gsub("\"", "", parts[3]))
        if (isTRUE(clean_sink) && identical(tmp[["sink"]], tmp[["target"]]))
            tmp[["sink"]] <- NULL
        res[[length(res) + 1]] <- tmp
    }
    # add phonicity to .PHONY targets. This is quite a mess.
    phony_targets <- sapply(strsplit(phony_lines, split = ": "), "[[", 2)
    for (target in phony_targets) {
        for (i in seq(along = res)) {
            if (res[[i]][["target"]] == target)
                res[[i]][[".PHONY"]] <- TRUE
        }
    }
    return(res)
}
