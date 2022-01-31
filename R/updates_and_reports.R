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

#' @inherit nflreadr::nflverse_sitrep
#' @export
#' @returns Returns `NULL` invisibly. Called for side effects.
#' @examples
#' \donttest{
#' try(
#' nflverse_sitrep()
#' )
#' }
nflverse_sitrep <- nflreadr::nflverse_sitrep

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
  devel_repo <- "https://nflverse.r-universe.dev/"
  if(isTRUE(devel)) repos["devel"] <- devel_repo
  available <- utils::available.packages(repos = repos)
  packages <- nflverse_packages(include_self = FALSE)

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
  cli::cli_alert_info("Start a clean R session then run:")
  pkg_str <- paste0(deparse(behind$package), collapse = "\n")
  if(isTRUE(devel)){
    cli::cli_text("{.code install.packages({pkg_str}, repos = {devel_repo})}")
  } else {
    cli::cli_text("{.code install.packages({pkg_str})}")
  }

  invisible()
}

packageVersion <- function(pkg) {
  if (rlang::is_installed(pkg)) {
    as.character(utils::packageVersion(pkg))
  } else {
    "0"
  }
}
