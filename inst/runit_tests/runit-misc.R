if (interactive()) pkgload::load_all()

test_touch <- function() {
    file <- tempfile()
    touch(file)
    t1 <- file.mtime(file)
    touch(file)
    t2 <- file.mtime(file)
    RUnit::checkTrue(t1 < t2)
}
