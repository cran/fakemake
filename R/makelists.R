#' Manipulate \code{makelist} Targets
#'
#' Get, add or remove targets from/to a \code{makelist}.
#' @name makelist_targets
NULL


#' @describeIn makelist_targets Get a single target from a \code{makelist} by
#' alias.
#' @param makelist A list for
#' \code{\link[fakemake:make]{fakemake::make}}.
#' @param alias The alias of the target in question.
#' @return A list (the target requested).
#' @export
#' @examples
#' ml <- provide_make_list(type  = "cran")
#' length(ml)
#' t <- get_target(ml, "check")
#' ml <- remove_target(ml, t[["target"]])
#' length(ml)
#' ml <- add_target(ml, target = t[["target"]], code = t[["code"]],
#'                 sink = t[["sink"]])
#' all.equal(ml[[1]], provide_make_list(type  = "cran")[[1]])
get_target <- function(makelist, alias) {
    index <- which(sapply(makelist, function(x) x["alias"] == alias))
    return(makelist[[index]])
}

#' @describeIn makelist_targets Remove a target and all its appearances as
#' other targets' dependencies from a \code{makelist}.
#' @inheritParams get_target
#' @param target The target to remove from \code{makelist}.
#' @return A list for
#' \code{\link[fakemake:make]{fakemake::make}}.
#' @export
remove_target <- function(makelist, target) {
    ml <- makelist
    # remove target
    index <- which(sapply(ml, function(x) x[["target"]] == target))
    ml[[index]] <- NULL
    # remove as prerequisite
    alternative <- paste0("file.path(\"", paste(unlist(strsplit(target, "/")),
                                     collapse = "\", \""), "\")")
    index <- which(sapply(ml, function(x) target %in% x[["prerequisites"]] ||
                          alternative %in% x[["prerequisites"]] ))
    if (length(index) > 0) {
        for (i in index) {
            j <- ml[[i]][["prerequisites"]] == alternative |
                ml[[i]][["prerequisites"]] == target
            ml[[i]][["prerequisites"]] <- ml[[i]][["prerequisites"]][!j]
        }
    }
    return(ml)
}

#' @describeIn makelist_targets Add a Target to an Existing \code{makelist}.
#' @inheritParams remove_target
#' @param code The code for the new target.
#' @param prerequisites The prerequisites for the new target.
#' @param prerequisite_to The targets the new target is a prerequisite to.
#' Set to \code{\link{TRUE}} to add it as a prerequisite to all existing
#' targets.
#' @param alias The alias for the new target.
#' @param sink The sink for the new target.
#' @return A list for
#' \code{\link[fakemake:make]{fakemake::make}}.
#' @export
#' @aliases add_target
add_target <- function(makelist, target, code, prerequisites = NULL,
                       prerequisite_to = NULL,  sink = NULL,
                       alias = sub("\\.(Rout|log)$", "", basename(target))) {
    ml <- makelist
    if (!is.null(prerequisite_to)) {
        if (isTRUE(prerequisite_to)) {
            # add the target as prerequisite to all targets not having it yet.
            add_to_all_targets <- function(x) {
                if (!identical(x[["target"]], target) &&
                    !any(target == x[["prerequisites"]])) {
                    x[["prerequisites"]] <- c(x[["prerequisites"]], target)
                }
                return(x)
            }
            ml <- lapply(ml, add_to_all_targets)
        } else {
            index <- which(sapply(ml,
                                  function(x) x[["target"]] == prerequisite_to))
            ml[[index]][["prerequisites"]] <- c(ml[[index]][["prerequisites"]],
                                                target)
        }
    }
    if (!any(sapply(ml, function(x) x[["target"]] == target))) {
        a <- list(list(alias = alias,
                       target = target,
                       code = code,
                       sink = sink,
                       prerequisites = prerequisites
                       ))
    } else {
        a <- NULL
    }
    return(c(ml, a))

}
