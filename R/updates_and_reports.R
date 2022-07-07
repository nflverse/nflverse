#' List all packages in the nflverse
#'
#' @param include_self Include nflverse in the list?
#' @return A vector of type `"character"`.
#' @export
#' @examples
#' nflverse_packages()
nflverse_packages <- function(include_self = FALSE) {
  raw <- utils::packageDescription("nflverse")$Imports
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  names <- vapply(strsplit(parsed, "\\s+"), "[[", 1, FUN.VALUE = character(1))
  if (include_self) {
    names <- c(names, "nflverse")
  }
  exclude <- c("cli", "crayon", "rstudioapi", "magrittr", "rlang")
  names <- names[!names %in% exclude]
  sort(names)
}

#' Get a Situation Report on System, nflverse Package Versions and Dependencies
#'
#' @description This function gives a quick overview of the versions of R and
#'   the operating system as well as the versions of nflverse packages, options,
#'   and their dependencies. It's primarily designed to help you get a quick
#'   idea of what's going on when you're helping someone else debug a problem.
#' @details See [`nflreadr::nflverse_sitrep`] for details.
#' @export
#' @name nflverse_sitrep
#' @importFrom nflreadr nflverse_sitrep
NULL

#' Update nflverse Packages
#'
#' Check all nflverse packages for available cran updates.
#'
#' @param recursive If `TRUE`, will also list all strong dependencies of
#'   nflverse packages.
#' @param repos the repositories to use to check for updates.
#'   Defaults to `getOptions("repos")`.
#' @param devel If `TRUE` the function will look for prebuilt development
#'   versions on <https://nflverse.r-universe.dev/> so it is possible to install
#'   development versions without GitHub.
#' @returns Returns `NULL` invisibly. Called for side effects.
#' @export
#' @examples
#' \donttest{
#' try(
#' nflverse_update()
#' )
#' try(
#' nflverse_update(devel = TRUE)
#' )
#'}
nflverse_update <- function(recursive = FALSE,
                            repos = getOption("repos"),
                            devel = FALSE){
  opts <- NULL
  if(isTRUE(devel)){
    repos["nflverse"] <- "https://nflverse.r-universe.dev/"
    opts <-
      'options(repos = c(
        nflverse = "https://nflverse.r-universe.dev",
        getOption("repos")
      ))'
  }
  available <- utils::available.packages(repos = repos)
  packages <- nflverse_packages(include_self = TRUE)

  if(isTRUE(recursive)){
    deps <- tools::package_dependencies(packages, db = available) %>%
      unlist() %>%
      unique() %>%
      sort()
    base_pkgs <- c(
      "base", "compiler", "datasets", "graphics", "grDevices", "grid",
      "methods", "parallel", "splines", "stats", "stats4", "tools", "tcltk",
      "utils"
    )
    deps <- deps[!deps %in% packages]
    deps <- deps[!deps %in% base_pkgs]
    packages <- sort(c(packages, deps))
  }

  cran_version <- available[packages, "Version"] %>%
    base::package_version() %>%
    as.character()
  local_version <- vapply(packages, packageVersion, character(1L))
  behind <- cran_version > local_version

  df <- data.frame(
    package = packages,
    cran = cran_version,
    local = local_version,
    behind = behind,
    stringsAsFactors = FALSE
  )

  behind <- df[df$behind == TRUE, ]

  if(nrow(behind) == 0){
    cli::cli_alert_success("All {.field nflverse} packages are up-to-date!")
    return(invisible())
  }

  cli::cli_alert_info(
    "The following {cli::qty(nrow(behind))}package{?s} {?is/are} out of date:"
  )
  cli::cat_bullet(format(behind$package),
                  " (",
                  format(behind$local),
                  " -> ",
                  format(behind$cran), ")"
                  )
  pkg_str <- paste0(deparse(behind$package), collapse = "\n")
  out_string <- paste0("install.packages(", pkg_str, ')')

  cli::cli_rule(left = "{.emph Start a clean R session then run}")
  cli::cli_code(opts, out_string)
  cli::cli_rule()

  invisible()
}

packageVersion <- function(pkg) {
  if (rlang::is_installed(pkg)) {
    as.character(utils::packageVersion(pkg))
  } else {
    "0"
  }
}
