str(fakemake::provide_make_list("minimal", clean_sink = TRUE))

ml <- fakemake::provide_make_list("minimal", clean_sink = TRUE)

fakemake::visualize(ml, root = "all.Rout")

withr::with_dir(tempdir(), print(fakemake::make("all.Rout", ml)))

show_file_mtime <- function(files = list.files(tempdir(), full.names = TRUE,
                                               pattern = "^.*\\.Rout")) {
    return(file.info(files)["mtime"])
}
show_file_mtime()

# ensure the modification time would change if the files were recreated
Sys.sleep(1)
withr::with_dir(tempdir(), print(fakemake::make("all.Rout", ml)))
show_file_mtime()

fakemake::touch(file.path(tempdir(), "b1.Rout"))
withr::with_dir(tempdir(), print(fakemake::make("all.Rout", ml)))
show_file_mtime()

# touch should do the job...
Sys.sleep(1)

fakemake::touch(file.path(tempdir(), "a1.Rout"))
withr::with_dir(tempdir(), print(fakemake::make("all.Rout", ml)))
show_file_mtime()

withr::with_dir(tempdir(), print(fakemake::make("all.Rout", ml, force = TRUE)))

withr::with_dir(tempdir(), print(fakemake::make("all.Rout", ml, force = TRUE,
                                                recursive = FALSE)))

file.remove(dir(tempdir(), pattern = ".*\\.Rout", full.names = TRUE))
withr::with_dir(tempdir(), print(fakemake::make("all.Rout", ml, dry_run = TRUE)))

dir(tempdir(), pattern = ".*\\.Rout")

withr::with_dir(tempdir(), print(fakemake::make("all.Rout", ml)))
dir(tempdir(), pattern = ".*\\.Rout")

i <- which(sapply(ml, "[[", "target") == "all.Rout")
ml[[i]]["alias"] <- "all"
withr::with_dir(tempdir(), print(fakemake::make("all", ml, force = TRUE)))

cat(readLines(file.path(tempdir(), "b1.Rout")), sep = "\n")

i <- which(sapply(ml, "[[", "target") == "b1.Rout")
ml[[i]]["code"]  <- paste(ml[[i]]["code"],
                      "cat('hello, world\n', file = \"b1.Rout\")",
                      "print(\"foobar\")",
                      sep = ";")
withr::with_dir(tempdir(), print(fakemake::make("b1.Rout", ml, force = TRUE)))
cat(readLines(file.path(tempdir(), "b1.Rout")), sep = "\n")

ml[[i]]["sink"] <- "b1.txt"
withr::with_dir(tempdir(), print(fakemake::make("b1.Rout", ml, force = TRUE)))

cat(readLines(file.path(tempdir(), "b1.Rout")), sep = "\n")
cat(readLines(file.path(tempdir(), "b1.txt")), sep = "\n")

i <- which(sapply(ml, "[[", "target") == "a1.Rout")
ml[[i]]["code"]

cat(readLines(file.path(tempdir(), "a1.Rout")), sep = "\n")

ml[[i]]["code"]  <- NULL
withr::with_dir(tempdir(), print(fakemake::make("a1.Rout", ml, force = TRUE)))

file.size(file.path(tempdir(), "a1.Rout"))

ml[[i]][".PHONY"]  <- TRUE
withr::with_dir(tempdir(), print(fakemake::make("a1.Rout", ml)))
