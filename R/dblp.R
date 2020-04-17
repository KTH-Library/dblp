

#' Retrieve records from dblp API
#'
#' @param query the query string to search for, as described in \url{https://dblp.org/faq/13501473.html}, for example q=test+search
#' @param start the "f"irst hit in the numbered sequence of search results to return. In combination with the h parameter, this parameter can be used for pagination of search results
#' @param n maximum number of search results ("h"its) to return. For bandwidth reasons, this number is capped at 1000
#' @param c maximum number of completion terms to return. For bandwidth reasons, this number is capped at 1000
#' @param api_config a configuration setting for the API including base URL etc, by default from config()
#' @param entity one of "publications", "authors" or "venues" where "publications" is default
#' @importFrom attempt stop_if_all stop_if_not
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET http_type status_code
#' @importFrom progress progress_bar
#' @import tibble dplyr
#' @export
#'
#' @return results records returned from the search
#' @examples
#' \dontrun{
#' dblp_search()
#' }
#'
#'
dblp_search <- function(
  query = NULL, start = 1, n = 10, c = NULL,
  api_config = NULL, entity = c("publications", "authors", "venues"))
{
  query_args <- list(
    q = query, format = "json", f = start, h = n
  )

  check_internet()
  stop_if_all(args, is.null, "You need to specify at least one argument")

  stop_if_not(is.character(query) && nchar(query) > 0,
              msg = "Please provide a query")
  stop_if_not(n <= 1000, msg = "Maximum is 1000 for number of returned records")

  if (any(missing(api_config), is.null(api_config)))
    api_config <- config()

  path <- switch(match.arg(entity),
    "publications" = api_config$url_publications,
    "authors" = api_config$url_authors,
    "venues" = api_config$url_venues
  )

  resp <- GET(path, query = compact(query_args), api_config$ua)
  check_status(resp)
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  parsed <- fromJSON(rawToChar(resp$content))

  if (status_code(resp) != 200) {
    stop(
      sprintf(
        "API request failed [%s]\n%s\n<%s>",
        status_code(resp),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }

  # TODO - parse nested json into tabular format, for now just remove compound values
  parse_publications <- function(x) {
    tryCatch(
      x$result$hits$hit %>%
      jsonlite::flatten() %>%
      as_tibble(), #as_tibble(.name_repair = "universal")
      error = function(e) as_tibble(NULL)
    )
  }

  parse_authors <- parse_publications
  parse_venues <- parse_publications

  content <- switch(match.arg(entity),
    "publications" = parse_publications(parsed),
    "authors" = parse_authors(parsed),
    "venues" = parse_venues(parsed)
  )

  structure(
    list(
      content = content,
      query = query,
      from = parsed$result$hits$`@first` %>% as.integer(),
      to = parsed$result$hits$`@sent` %>% as.integer(),
      count = parsed$result$hits$`@total` %>% as.integer()
    ),
    class = "dblp"
  )
}

#' Retrieve more records from dblp in batches
#'
#' This function retrieves batches of record (paging through results)
#' @inheritDotParams dblp_search
#' @export
#' @return results records returned from the search
#' @importFrom rlang eval_tidy parse_quo current_env
#' @examples
#' \dontrun{
#' dblp_crawl(query = "chip")
#' }
dblp_crawl <- function(...) {
  res <- dblp_search(...)
  n <- res$count

  if (n <= 10)
    return (res)

  batch <- 1000L

  if (n > 10 & n < batch) {
    res <- dblp_search(..., n = n)
    return (res)
  }

  if (n >= batch & n < 10000) {
    # nr of pages to fetch
    n_pages <- (n %/% batch) + ifelse(n %% batch > 0, 1, 0)

    i <- c(0, (1:(n_pages - 1)) * batch)

    calls <- sprintf("dblp_search(start = %s, n = %s, ...)$content", i, batch)
    message(sprintf("Fetching %s hits in %s batches of %s records", n, n_pages, batch))

    pb <- progress::progress_bar$new(
      format = "  downloading [:bar] :percent in :elapsed",
      total = n_pages, clear = FALSE, width= 60)

    call2df <- function(x) {
      pb$tick()
      Sys.sleep(0.01)
      force(rlang::eval_tidy(rlang::parse_quo(x, env = rlang::current_env()))) #%>%
      #as.data.frame() %>%
      #tibble::as_tibble() %>%
      #dplyr::select_if(function(y) !is.list(y))
    }

    batch <- calls %>% purrr::map_df(call2df)

    res <- structure(
      list(
        content = batch,
        query = sprintf("%s pages of data", n_pages),
        from = 1,
        to = n + 1,
        count = n
      ),
      class = "dblp"
    )
  } else {
    stop(sprintf("Too big batch, %s records, stopping", n), call. = FALSE)
  }

  return(res)
}

#' @export
print.dblp <- function(x, ...) {
  stopifnot(inherits(x, 'dblp'))
  cat(sprintf("<dblp.org search for '%s' (n_hits=%s, showing %s..%s)>\n",
              x$query, x$count, x$from, x$to))
  print(tibble::as_tibble(x$content))
  invisible(x)
}
