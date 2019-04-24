
#' IEX TOP of Book Quote Feed,
#'
#' TOPS provides IEX’s aggregated best quoted bid and offer position in
#'  near real time for all securities on IEX’s displayed limit order book.
#'  TOPS is ideal for developers needing both quote and trade data.
#'
#' Data Weighting: FREE
#'
#' Data Timing: REAL TIME
#'
#' Data Schedule: Market hours 9:30am-4pm ET
#'
#' Data Source(s): Consolidated Tape Investors Exchange
#'
#' @param symbol a market symbol, when absent will return all market symbols
#' @param securityType | NULL filter
#' @param sector | NULL filter
#' @return a data frame (filtered to remove symbols with no recorded sales i.e. lastSaleTime==0)
#' @export
#' @examples
#' tops('AAPL')
tops <- function(symbol ="", securityType = null, sector = null) {
  market <- FALSE
  if (nchar(symbol)==0){
    endpoint <- '/tops'
    market <- TRUE
  } else {
  endpoint <- glue::glue('/tops?symbols={symbol}');
  }
  res = iex(endpoint);
  result <-tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest()
  if (nchar(symbol)==0) {
    result <- dplyr::filter(result,!(lastSaleTime== 0 & bidPrice == 0 & askPrice == 0 ));
  }
  result <- dplyr::mutate(result, lastSaleTime = lubridate::with_tz(lubridate::as_datetime(lastSaleTime/1000),"America/New_York"),
                          lastUpdated = lubridate::with_tz(lubridate::as_datetime(lastUpdated/1000),"America/New_York"),
                          minute = lubridate::hour(lastSaleTime)*60+lubridate::minute(lastSaleTime)-570);
  if (!is.null(sector)) {
    result <- dplyr::filter(result,sector == sector)
  }
  if (!is.null(securityType)) {
    result <- dplyr::filter(result,securityType == securityType)
  }
  if (market) {
    result <- dplyr::arrange(symbol)
  }
  return (result)
}



#' IEX last sale price
#'
#' Last provides trade data for executions on IEX.
#' It is a near real time, intraday API that provides IEX last sale price,
#' size and time. Last is ideal for developers that need a lightweight
#' stock quote.
#' Data Weighting: FREE
#'
#' Data Timing: REAL TIME
#'
#' Data Schedule: Market hours 9:30am-4pm ET
#'
#'Data Source(s): Consolidated Tape Investors Exchange
#'
#' @param symbol a market symbol, when absent returns all market symbols
#' @export
#' @examples
#' topsLast('AAPL')
topsLast <- function(symbol="") {
  if (nchar(symbol)==0) {
    endpoint = '/tops/last'
  } else {
    endpoint <- glue::glue('/tops/last?symbols={symbol}');
  }
  res = iex(endpoint);
  result <-tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest() %>%
    dplyr::mutate(
      time = lubridate::with_tz(lubridate::as_datetime(time/1000),"America/New_York"),
      minute = lubridate::hour(time)*60+lubridate::minute(time)-570) %>%
    dplyr::arrange(symbol)
  return (result)
}
