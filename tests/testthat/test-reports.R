test_that("nflverse_packages() works", {
  expect_identical(
    nflverse_packages(include_self = TRUE),
    c("nfl4th", "nflfastR", "nflplotR", "nflreadr", "nflseedR", "nflverse")
  )
  expect_identical(
    nflverse_packages(include_self = FALSE),
    c("nfl4th", "nflfastR", "nflplotR", "nflreadr", "nflseedR")
  )
})
