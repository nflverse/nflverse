.onAttach <- function(...) {
  needed <- core[!is_attached(core)]
  if (length(needed) == 0)
    return()

  crayon::num_colors(TRUE)
  nflverse_attach()

  # if (!"package:conflicted" %in% search()) {
  #   x <- nflverse_conflicts()
  #   msg(nflverse_conflict_message(x), startup = TRUE)
  # }

  msg(cli::rule(right = crayon::bold("Ready to go!")),startup = TRUE)

}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}
