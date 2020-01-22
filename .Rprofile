options(
    "repos" = c(CRAN = "http://cran.r-project.org/"),
    "scipen" = 10,
    "device" = "postscript" # this makes jupyter work headless
)

gimme <- function(pkg) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
}
