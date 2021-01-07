\name{NEWS}
\title{NEWS}

\section{Changes in version 1.10.0}{
\itemize{
\item Function \code{make()} now throws an error if a target's recipe fails.
\item Function \code{make()} now throws an error if a target's recipe throws a
\code{warning()} and the new argument \code{stop_on_warning} is set to \code{TRUE}.
\item Added argument \code{verbosity} to \code{make()} to set the level of verbosity triggered
my \code{verbose = TRUE}.
\item Added argument \code{unconditionally} to \code{make()}, which allows you to run a
target's code unconditionally on the target's prerequisites, mocking GNU
make's option \code{--touch}. See \code{make} examples section.
}
}

\section{Changes in version 1.9.0}{
\itemize{
\item Updated vignettes.
}
}

\section{Changes in version 1.8.1}{
\itemize{
\item Removed \code{callr} and \code{withr} from the Depends-Field in file DESCRIPTION.
}
}

\section{Changes in version 1.8.0}{
\itemize{
\item Removed deprecated functions \code{get_pkg_archive_path},
\code{check_archive} and \code{check_archive_as_cran} that are now in packager.
\item Fixed testing via gitlab-ci.
}
}

\section{Changes in version 1.7.2}{
\itemize{
\item Fix help links to package \code{callr} following request
Deepayan Sarkar (see https://deepayan.github.io/tmp/topichelp/funs.html).
}
}

\section{Changes in version 1.7.1}{
\itemize{
\item Skipping RUnit testing on non-Windows and non-Linux platforms.
CRAN reported errors in testing on MacOS X only.
}
}

\section{Changes in version 1.7.0}{
\itemize{
\item Functions \code{check_archive}, \code{check_archive_as_cran} and \code{get_pkg_archive_path}
are now deprecated: they have moved to CRAN package \code{packager}. Their
documentation is tagged as internal.
\item Tagged documentation for functions \code{read_makefile}, \code{write_makefile},
\code{sink_all} and \code{touch} as internal.
\item Changed the default to function \code{make}'s \code{verbose} option to \code{FALSE}.
\item Added arguemnt \code{dry_run} to function \code{make} that mocks make's -n option
(i.e. "Don't actually run any recipe; just print them.").
}
}

\section{Changes in version 1.6.0}{
\itemize{
\item Added  functions \code{add_target}, \code{get_target} and \code{remove_target} to facilitate
the manipulation of makelists.
}
}

\section{Changes in version 1.5.0}{
\itemize{
\item Package makelist "package" (and its alias "standard") now includes testthat
and runit.
\item Package makelist "cran" (and its alias "vignette") now excludes testthat.
\item Target "cleanr" now catches errors thrown by package cleanr.
}
}

\section{Changes in version 1.4.2}{
\itemize{
\item Changed coverage code in the package makelists to detach package after
covering.
\item Splitted the vignette into two.
\item Fixed target "build" in provide\_make\_list().
\item Fixed tryCatch-Targets to write to log-directory.
\item For verbose = TRUE, the current make target is now being reported.
\item Package make target cyclocomp now requires roxygen.
\item Added a package makelist \code{cran} that omits cyclocomp and now using it in
vignette.
}
}

\section{Changes in version 1.4.1}{
\itemize{
\item Suggest rather than import pkgbuild.
}
}

\section{Changes in version 1.4.0}{
\itemize{
\item Adjusted to devtools 2.0.0 (devtools was split into several packages).
}
}

\section{Changes in version 1.3.0}{
\itemize{
\item Added cyclocomp to the "package" makelist.
}
}

\section{Changes in version 1.2.0}{
\itemize{
\item Added make\_list "standard", enhancing "package" by adding the creation of the
log directory and using it as prerequisite.
}
}

\section{Changes in version 1.1.0}{
\itemize{
\item Fixed recursive treatment of argument \code{verbose} to function \code{make}.
\item Fixed internal function \verb{package\\_makelist} to using \code{devtools::test} instead
\code{testthat::test_package} directly (the former is a wrapper to the latter).
\item Now \verb{package\\_makelist} is printing output from roxygen2, testthat, cleanr and
devtools::build to harmonize logs.
}
}

\section{Changes in version 1.0.2}{
\itemize{
\item Disabled RUnit tests for OSX and R Versions older than 3.4.0.
}
}

\section{Changes in version 1.0.1}{
\itemize{
\item Replaced file.show(x, pager = "cat") with cat(readLines(x), sep = "\"n) in
examples as they did not pass checks on windows.
\item Fixed example path for windows.
}
}

\section{Changes in version 1.0.0}{
\itemize{
\item Added a \code{NEWS.md} file to track changes to the package.
}
}

