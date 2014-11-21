options(
    "defaultPackages" = c(
        getOption("defaultPackages"),
        "plyr",
        "reshape",
        "ggplot2",
        "stringr",
        "lubridate"
    ),
    "repos" = c(CRAN = "http://cran.r-project.org/"),
    "scipen" = 10
)

gimme <- function(pkg) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
}
