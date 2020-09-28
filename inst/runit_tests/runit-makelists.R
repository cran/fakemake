if (interactive()) pkgload::load_all()

test_makelist_manipulation <- function() {
    ml <- provide_make_list(type  = "minimal")
    length(ml)
    i <- which(sapply(ml, "[[", "target") == "b1.Rout")
    ml[[i]]["alias"] <- "b1"
    t <- get_target(ml, "b1")
    ml <- remove_target(ml, t[["target"]])
    length(ml)
    ml <- add_target(ml, target = t[["target"]], code = t[["code"]],
                     sink = t[["sink"]])
    RUnit::checkTrue(all.equal(ml[[1]], provide_make_list(type  = "minimal")[[1]]))
}
