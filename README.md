
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **nflverse** <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/nflverse/nflverse/workflows/R-CMD-check/badge.svg)](https://github.com/nflverse/nflverse/actions)
<!-- badges: end -->

## Overview

The nflverse is a set of packages dedicated to data of the National
Football League. The **nflverse** package is designed to make it easy to
install and load core packages from the nflverse in a single command.

## Installation

The easiest way to get nflfastR is to install it from
[GitHub](https://github.com/nflverse/nflverse/) with:

``` r
if (!require("remotes")) install.packages("remotes")
remotes::install_github("nflverse/nflverse")
```

## Usage

`library(nflverse)` will load the core nflverse packages:

-   [nflfastR](https://www.nflfastr.com/), for play-by-play data back
    to 1999.
-   [nflseedR](https://nflseedr.com/), for season simulations.
-   [nfl4th](https://www.nfl4th.com/), for 4th down analysis.
