#' List all packages in the nflverse
#'
#' @param include_self Include nflverse in the list?
#' @export
#' @examples
#' nflverse_packages()
nflverse_packages <- function(include_self = TRUE) {
  raw <- utils::packageDescription("nflverse")$Imports
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  names <- vapply(strsplit(parsed, "\\s+"), "[[", 1, FUN.VALUE = character(1))

  if (include_self) {
    names <- c(names, "nflverse")
  }

  tool_pkgs <- c("cli", "crayon", "rstudioapi", "magrittr")
  names <- names[!names %in% tool_pkgs] %>% sort()

  names
}
