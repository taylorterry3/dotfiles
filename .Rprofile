options(
    "defaultPackages" = c(
        getOption("defaultPackages"),
        "plyr",
        "reshape2",
        "ggplot2",
        "stringr",
        "lubridate",
	"yaml",
	"htmltools",
	"caTools",
	"rmarkdown"
    ),
    "repos" = c(CRAN = "http://cran.r-project.org/"),
    "scipen" = 10
)

gimme <- function(pkg) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
}
