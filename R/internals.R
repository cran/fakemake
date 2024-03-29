makelist2igraph <- function(make_list, root = NULL) {
    make_list <- parse_make_list(make_list)
    names(make_list) <- sapply(make_list, "[[", "target")
    make_list  <-  lapply(make_list, "[[", "prerequisites")
    stack <- utils::stack(prune_list(make_list))
    if (! is.null(root)) stack <- stack[TRUE, c(2, 1)]
    g <- igraph::graph.data.frame(stack)
    return(invisible(g))
}

is_to_be_made <- function(target, prerequisites, is_phony) {
    # This is a nesting depth of 4. But the shorter
    # is_phony || !f(target) ||
    # !null(prerequisites! & any(t(prerequisites) > t(target)
    # will fail with testing coverage. covr doesn't test for all
    # combinations of composite conditions. So I stick with it.
    if (is_phony) {
        is_to_be_made <- TRUE
    } else {
        if (! file.exists(target)) {
            is_to_be_made <- TRUE
        } else {
            if (is.null(prerequisites)) {
                is_to_be_made <- FALSE
            } else {
                if (all(file.exists(prerequisites))) {
                    if (any(file.mtime(prerequisites) > file.mtime(target))) {
                        is_to_be_made <- TRUE
                    } else {
                        is_to_be_made <- FALSE
                    }
                } else {
                    is_to_be_made <- TRUE
                }
            }
        }
    }
    return(is_to_be_made)
}

has_item <- function(l, item) {
    i <- sapply(lapply(l, function(x) names(x) == item),
                function(x) any(x))
    return(i)
}

check_makelist <- function(makelist) {
    #% is a list
    if (! is.list(makelist)) throw(paste(makelist, "is not a list."))

    #% all entries have targets
    has_target <- has_item(makelist, "target")
    if (! all(has_target)) {
        throw(paste("Items", paste(which(! has_target), collapse = ", "),
                    "of list", dQuote(deparse(substitute(makelist))),
                    "have no target entries."))
    }
    #% all entries have code or prerequisites
    pass <- has_item(makelist, "code") | has_item(makelist, "prerequisites")
    if (! all(pass)) {
        throw(paste("Items", paste(which(! pass), collapse = ", "),
                    "of list", dQuote(deparse(substitute(makelist))),
                    "have neither code entries nor prerequisites entries."))
    }

    #% all entries have valid names only
    valid_names <- c("alias", "target", "code", "sink", "prerequisites",
                     ".PHONY")
    is_valid_name <- lapply(makelist, function(x) names(x) %in% valid_names)
    if (! all(unlist(is_valid_name))) {
        all_valid_names <- sapply(is_valid_name, function(x) all(unlist(x)))
        msg <- NULL
        for (i in seq(along = makelist)) {
            if (! all_valid_names[i]) {
                invalid_names <- names(makelist[[i]][! is_valid_name[[i]]])
                msg <- paste(msg,
                             paste(paste(dQuote(invalid_names),
                                         collapse = ", "),
                                   "for make target", makelist[[i]]["target"],
                                   "(item number", i,
                                   " in list",
                                   dQuote(deparse(substitute(makelist))),
                                   ") are no valid names."), sep = "\n")
            }
        }
        throw(msg)
    }
    return(invisible(TRUE))
}

parse_make_list <- function(ml) {
    for (i in seq(along = ml)) {
        for (type in setdiff(names(ml[[i]]), c("code", "alias"))) {
            x <- ml[[i]][[type]]
            res <- NULL
            for (j in seq(along = x)) {
                y <- ml[[i]][[type]][[j]]
                res <- c(res, tryCatch(eval(parse(text = y)),
                                       error = function(e) return(y)))
            }
            ml[[i]][[type]] <- res
        }
        if (is.null(ml[[i]][["sink"]])) ml[[i]][["sink"]] <- ml[[i]][["target"]]
        # eval()uating NULL is no good.
        if (is.null(ml[[i]][["code"]])) ml[[i]][["code"]] <- ""
    }
    return(ml)
}

# Thanks to Gabor Grothendieck and Josh O'Brien on
# https://stackoverflow.com/questions/26539441
# /r-remove-null-elements-from-list-of-lists
is_null <- function(x) is.null(x) || all(sapply(x, is.null))

prune_list <- function(x) {
   x <- Filter(Negate(is_null), x)
   lapply(x, function(x) if (is.list(x)) prune_list(x) else x)
}
