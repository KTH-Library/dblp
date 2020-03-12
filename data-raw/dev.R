# https://www.r-bloggers.com/how-to-build-an-api-wrapper-package-in-10-minutes/
# https://httr.r-lib.org/articles/api-packages.html

install.packages("devtools")
install.packages("roxygen2")
install.packages("usethis")
install.packages("curl")
install.packages("httr")
install.packages("jsonlite")
install.packages("attempt")
install.packages("purrr")
devtools::install_github("r-lib/desc")

library(devtools)
library(usethis)
library(desc)

unlink("DESCRIPTION")
my_desc <- description$new("!new")
my_desc$set("Package", "dblp")
my_desc$set("Authors@R", "person('Markus', 'Skyttner', email = 'markussk@kth.se', role = c('cre', 'aut'))")

my_desc$del("Maintainer")

my_desc$set_version("0.0.0.9000")

my_desc$set(Title = "Computer Science Bibliographic Data from the dblp.org API")
my_desc$set(Description = "The dblp computer science bibliography at dblp.org provides open bibliographic information on major computer science journals and proceedings. Originally created at the University of Trier in 1993, dblp is now operated and further developed by Schloss Dagstuhl. This R package interfaces with the API, making data available to use from R.")
my_desc$set("URL", "https://github.com/KTH-Library/dblp")
my_desc$set("BugReports", "https://github.com/KTH-Library/dblp/issues")
my_desc$set("License", "MIT")
my_desc$write(file = "DESCRIPTION")

use_mit_license(name = "Markus Skyttner")
#use_code_of_conduct()
use_news_md()
use_readme_rmd()
use_lifecycle_badge("Experimental")

use_package("httr")
use_package("jsonlite")
use_package("curl")
use_package("attempt")
use_package("purrr")
use_package("progress")
use_package("dplyr")
use_package("tibble")
use_package("rlang")
use_package("stringr")
use_tidy_description()

use_testthat()
use_vignette("dblp")
use_roxygen_md()
use_pkgdown()

document()
test()
check()
pkgdown::build_site()
