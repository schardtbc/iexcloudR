
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
#'Data Source(s): Consolidated Tape Investors Exchange
#'
#' @param symbol a market symbol, when absent will return all market symbols
#' @return a data frame (filtered to remove symbols with no recorded sales i.e. lastSaleTime==0)
#' @export
#' @examples
#' tops('AAPL')
tops <- function(symbol ="",sector = null, securityType = null) {
  if (nchar(symbol)==0){
    endpoint = '/tops'
  } else {
  endpoint <- glue::glue('/tops?symbols={symbol}');
  }
  res = iex(endpoint);
  result <-tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest()
  if (nchar(symbol)==0) {
    result <- dplyr::filter(result,!(lastSaleTime== 0 & bidPrice == 0 & askPrice == 0 ));
  }
  return (r)
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
    tidyr::unnest();
  return (result)
}
