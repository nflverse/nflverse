# nflverse (development version)

* Update required nflverse package versions. (#22)
* nflverse now requires R 4.1 to allow the package to use R's native pipe `|>` operator. This follows the [Tidyverse R version support rules](https://www.tidyverse.org/blog/2019/04/r-version-support/). (#22)
* `nflverse_update(devel = TRUE)` now checks if the installed R version is supported by the r-universe development repo. If not, it suggests installing dev version from GitHub using the {pak} package. (#23)

# nflverse 1.0.3

* Minor changes - requested by CRAN - related to nfl4th.

# nflverse 1.0.2

* `nflverse_update()` includes the nflverse package.
* improved installation instructions for `nflverse_update(devel = TRUE)`

# nflverse 1.0.1

* fixed output of `nflverse_update(devel = TRUE)`

# nflverse 1.0.0

* Initial release.
