if (interactive()) devtools::load_all()

test_makelist_manipulation <- function() {
    ml <- provide_make_list(type  = "cran")
    length(ml)
    t <- get_target(ml, "check")
    ml <- remove_target(ml, t[["target"]])
    length(ml)
    ml <- add_target(ml, target = t[["target"]], code = t[["code"]],
                     sink = t[["sink"]])
    RUnit::checkTrue(all.equal(ml[[1]], provide_make_list(type  = "cran")[[1]]))
}
