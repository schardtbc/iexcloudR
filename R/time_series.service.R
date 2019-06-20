
#' return a data.frame with all the time series id and schema information
#'
#' @family time-series service
#' @export
list_all_times_series <- function(){
  res <- iex_api("/time-series")
}

#' return data for specified time series id
#'
#' @family time-series service
#' @param from	Optional
#'   Returns data on or after the given from date. Format YYYY-MM-DD. Used together with the to parameter to define a date range.
#' @param to	Optional
#'   Returns data on or before the given to date. Format YYYY-MM-DD
#' @param on	Optional
#'   Returns data on the given date. Format YYYY-MM-DD
#' @param last	Optional
#'   Returns the latest n number of records in the series
#' @param first	Optional
#'   Returns the first n number of records in the series
#' @param filter	Optional
#'   The standard filter parameter. Filters return data to the specified comma delimited list of keys (case-sensitive)
#' @export
time_series <- function(id, key = NULL, sub_key = NULL,
                        from = NULL, to = NULL, on = NULL,
                        last = NULL, first = NULL, filter = NULL){
  endpoint <- list();
  class(endpoint) <- "url"
  endpoint$path <- glue::glue("/time-series/{id}/{key}");
  if (!is.null(subkey)) {
    endpoint$path <= paste0(endpoint$path,"/",sub_key)
  }
  endpoint$query <- list(from = from,
                         to = to,
                         on = on,
                         last = last,
                         first = first,
                         filter = filter)
  res <- iex_api(endpoint)
}
