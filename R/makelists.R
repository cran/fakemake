#' Load an Example \code{Makelist} Provided by \pkg{fakemake}.
#'
#' @inheritParams read_makefile
#' @param type The type of \code{makelist}.
#' package \code{makelist}.
#' @param prune Prune the \code{makelist} of \code{NULL} items?
#' @return A \code{makelist}.
#' @export
#' @examples
#' str(provide_make_list("minimal"))
#' visualize(provide_make_list("minimal"))
provide_make_list <- function(type = c("minimal", "testing", "vignette"), prune = TRUE, 
                              clean_sink = FALSE) {
    type <- match.arg(type)
    ml <- switch(type,
                 testing = ,
                 "minimal" =  {
                     name <- "Makefile"
                     if (! is.null(type)) name <- paste0(name, "_", type)
                     read_makefile(system.file("templates", name,
                                               package = "fakemake"),
                                   clean_sink)
                 },
                 "vignette" = add_log(package_makelist()),
                 throw(paste0("type ", type, " not known!"))
                 )
    if (isTRUE(prune)) ml <- prune_list(ml)
    check_makelist(ml)
    return(ml)
}

#' Get a Makelist's Target
#' 
#' Get a single target from a \code{makelist} by
#' alias.
#' @param makelist A list for
#' \code{\link[fakemake:make]{make}}.
#' @param alias The alias of the target in question.
#' @return A list (the target requested).
#' @family functions to manipulate makelists
#' @export
#' @examples
#' ml <- provide_make_list()
#' visualize(ml, root = "all.Rout")
#' i <- which(sapply(ml, "[[", "target") == "b1.Rout")
#' ml[[i]]["alias"] <- "b1"
#' t <- get_target(ml, "b1")
#' ml <- remove_target(ml, t[["target"]])
#' visualize(ml)
#' ml <- add_target(ml, target = t[["target"]], code = t[["code"]],
#'                 sink = t[["sink"]],
#'                 prerequisite_to = "a1.Rout", alias = NULL)
#' all.equal(ml, provide_make_list())
get_target <- function(makelist, alias) {
    index <- which(sapply(makelist, function(x) x["alias"] == alias))
    return(makelist[[index]])
}

#' Remove a Target From a Makelist
#'
#' Remove a target and all its appearances as
#' other targets' dependencies from a \code{makelist}.
#' @family functions to manipulate makelists
#' @param makelist A list for
#' \code{\link[fakemake:make]{make}}.
#' @param target The target to remove from \code{makelist}.
#' @return A list for
#' \code{\link[fakemake:make]{make}}.
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

#' Add a Target to a Makelist
#'
#' Add a target to an existing \code{makelist}.
#' @family functions to manipulate makelists
#' @param makelist A list for
#' \code{\link[fakemake:make]{make}}.
#' @param target The target to remove from \code{makelist}.
#' @param code The code for the new target.
#' @param prerequisites The prerequisites for the new target.
#' @param prerequisite_to The targets the new target is a prerequisite to.
#' Set to \code{\link{TRUE}} to add it as a prerequisite to all existing
#' targets.
#' @param alias The alias for the new target.
#' @param sink The sink for the new target.
#' @return A list for
#' \code{\link[fakemake:make]{make}}.
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
        a <- list(alias = alias,
                  target = target,
                  code = code,
                  sink = sink,
                  prerequisites = prerequisites
                  )
        # remove list items set to NULL
        a <- a[sapply(a, function(x) !is.null(x))]
        a <- list(a)
    } else {
        a <- NULL
    }
    return(c(ml, a))

}

#' Visualize a Makelist
#' 
#' Parse a \code{makelist}, convert it into an \code{igraph} and plot it.
#'
#' @param make_list The \code{makelist}.
#' @param root The root of a tree.
#' @return Invisibly an \pkg{igraph} representation of the \code{makelist}.
#' @export
#' @examples
#' str(ml <- provide_make_list())
#' visualize(ml)
#' visualize(ml, root = "all.Rout")
visualize <- function(make_list, root = NULL) {
    g <- makelist2igraph(make_list, root = root)
    if (! is.null(root)) {
        graphics::plot(g,
                       layout = igraph::layout.reingold.tilford(g, root = root))
    } else {
        graphics::plot(g)
    }
    return(invisible(g))
}
