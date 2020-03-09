
#' get all data-point keys for a symbol
#'
#' @family data point service functions
#' @param symbol a market symbol
#' @export
data_point_keys <- function(symbol){
  endpoint = glue::glue("/data-points/{symbol}")
  res <-iex_api(endpoint)
  if (res$status) return (tibble::as_tibble(list()));
  tibble::as_tibble(do.call(rbind, res$content)) %>%
    tidyr::unnest_legacy();
}

#' data-point for symbol key
#'
#' @family data point service functions
#' @param symbol a market symbol
#' @param key a data-point key
#' @export
data_point <- function(symbol, key){
  endpoint = glue::glue("/data-points/{symbol}/{key}")
  res <- iex_api(endpoint)
  if (res$status) return (NA)
  res$content
}
