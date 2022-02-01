library(nflplotR)
library(ggplot2)
library(showtext)
## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Kanit")
## Automatically use showtext to render text for future devices
showtext_auto()

df <- data.frame(
  a = rep(1:3, 2),
  b = sort(rep(1:2, 3), decreasing = TRUE),
  url = c(
    "https://github.com/nflverse/nflfastR/raw/master/man/figures/logo.png",
    "https://github.com/nflverse/nflseedR/raw/master/man/figures/logo.png",
    "https://github.com/nflverse/nfl4th/raw/master/man/figures/logo.png",
    "https://github.com/nflverse/nflreadr/raw/main/data-raw/logo.svg",
    "https://github.com/nflverse/nflverse/raw/main/man/figures/logo.png",
    "https://github.com/nflverse/nflplotR/raw/main/man/figures/logo.png"
  )
)

p <- ggplot(df, aes(x = a, y = b)) +
  geom_from_path(aes(path = url), width = 0.15) +
  annotate(shadowtext::GeomShadowtext, x = 2, y = 1.5, label = "The nflverse", family = "Kanit", size = 30, color = "#ffffff") +
  # annotate("text",
  #          x = 2,
  #          y = 1.5,
  #          label = "The nflverse",
  #          family = "Kanit",
  #          size = 30,
  #          color = "#ffffff",
  #          bg.color = "#161616") +
  # annotate("text", x = 8.7, y = 0.5, label = "Part of the #nflverse", hjust = 1, size = 1.2, color = "#ffffff") +
  # annotate("text", x = 6.5, y = 2, label = "by @mrcaseb ", hjust = 1, size = 1.2, color = "#ffffff") +
  theme_void() +
  coord_cartesian(xlim = c(0.5,3.5), ylim = c(0.75,2.25))

# ggpreview(p, width = 1280, height = 640, units = "px", dpi = 600,  bg = "#222222")

ggsave("man/figures/social_preview.png",
       p, width = 1280, height = 640, units = "px", dpi = 1200,
       bg = "#A0A0A0")
