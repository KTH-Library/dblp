#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
check_internet <- function(){
  stop_if_not(.x = has_internet(), msg = "Please check your internet connexion")
}

#' @importFrom httr status_code
check_status <- function(res){
  stop_if_not(
    .x = status_code(res),
    .p = ~ .x == 200,
    msg = "The API returned an error")
}

#' dblp API configuration
#'
#' This function provides a list with settings for the base url and user agent
#' used in API calls.
#'
#' @export
config <- function() {
  list(
    url_publications = "http://dblp.org/search/publ/api",  # for publication queries
    url_authors = "http://dblp.org/search/author/api",  # for author queries
    url_venues = "http://dblp.org/search/venue/api", # for venue queries
    ua = httr::user_agent("http://github.com/hadley/httr")
  )
}

