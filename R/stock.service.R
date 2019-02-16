


#' retrieve balance sheet for a symbol as dataframe
#' @param symbol stock symbol
#' @param period (quarter) "annual" | "quarter"
#' @param lastN (1) number of periods to report
#' @return a dataframe
#' @export
#' @examples
#' balanceSheet("AAPL",period = "quarter", lastN =4)
balanceSheet <- function (symbol,period = "quarter",lastN=1) {
  endpoint <- glue::glue('/stock/{symbol}/balance-sheet/{lastN}?period={period}');
  res <- iex(endpoint);
  data <- res$balancesheet
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(reportDate),dplyr::funs(as.Date(.)))
};

#' retrieve cash flow statement for a symbol as dataframe
#' @param symbol stock symbol
#' @param period (quarter) "annual" | "quarter"
#' @param lastN (1) number of periods to report
#' @return a dataframe
#' @export
#' @examples
#' cashflowStatement("AAPL",period = "quarter", lastN =4)
cashflowStatement <- function (symbol,period = "quarter",lastN=1) {
  endpoint <- glue::glue('/stock/{symbol}/cash-flow/{lastN}?period={period}');
  res = iex(endpoint);
  data <- res$cashflow
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(reportDate),dplyr::funs(as.Date(.)))
};

#' retrieve company detail for a symbol as dataframe
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' company("AAPL")
company <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/company');
  res = iex(endpoint);
  #tibble::as_tibble(res)
};

#' retrieve dividends detail for a symbol as dataframe
#' @param symbol stock symbol
#' @param timePeriod is one of "next" | "1m" | "3m" | "6m" | "ytd" | "1y" | "2y" | "5y"
#' @return a dataframe
#' @export
#' @examples
#' dividends("AAPL")
dividends <- function (symbol, timePeriod = "3m") {
  endpoint <- glue::glue('/stock/{symbol}/dividends/{timePeriod}');
  res = iex(endpoint);
  data <- lapply(res,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest();
};

#' retrieve earnings statement for a symbol as dataframe
#' @param symbol stock symbol
#' @param lastN (1) number of periods to report
#' @return a dataframe
#' @export
#' @examples
#' earnings("AAPL", lastN =4)
earnings <- function (symbol, lastN=1) {
  endpoint <- glue::glue('/stock/{symbol}/earnings/{lastN}/');
  res = iex(endpoint);
  data <- res$earnings
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest();
};

#' retrieve effective spread for a symbol as dataframe
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' effectiveSpread("AAPL")
effectiveSpread <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/effective-spread');
  res = iex(endpoint);
  tibble::as_tibble(res)
};

#' retrieve estimates for a symbol as dataframe
#' @param symbol stock symbol
#' @param lastN (1) number of periods to report
#' @return a dataframe
#' @export
#' @examples
#' estimates("AAPL", lastN =4)
estimates <- function (symbol, lastN=1) {
  endpoint <- glue::glue('/stock/{symbol}/estimates/{lastN}/');
  res = iex(endpoint);
  data <- res$estimates;
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest();
};

#' retrieve financial statement for a symbol as dataframe
#' @param symbol stock symbol
#' @param lastN (1) number of periods to report
#' @return a dataframe
#' @export
#' @examples
#' financials("AAPL", lastN =4)
financials <- function (symbol, lastN=1) {
  endpoint <- glue::glue('/stock/{symbol}/financials/{lastN}/');
  res = iex(endpoint);
  data <- res$financials
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest();
};

#' retrieve history for a stock over chosen time-period as dataframe
#' @param symbol stock symbol
#' @param timePeriod is one of "dynamic" | "date" | "1d" | "1m" | "3m" | "6m" | "ytd" | "1y" | "2y" | "5y"
#' @param chartCloseOnly = FALSE,(1 mu/minute 50 max.) All ranges except 1d. Will return adjusted data only with keys date, close, and volume.
#' @param chartIEXOnly = FALSE,(free) Only for 1d. Limits the return of intraday prices to IEX only data.
#' @param chartLastN = 0, If passed, chart data will return the last N elements
#' @param chartInterval = 1,If passed, chart data will return every Nth element as defined by chartInterval
#' @param changeFromClose = FALSE,
#' @param chartReset = FALSE, If true, 1d chart will reset at midnight instead of the default behavior of 9:30am ET.
#' @param chartSimplify = FALSE, If true, runs a polyline simplification using the Douglas-Peucker algorithm. This is useful if plotting sparkline charts.
#' @return a dataframe
#' @export
#' @examples
#' history("AAPL")
historyFor <- function (symbol,
                     timePeriod = "1m",
                     chartCloseOnly = FALSE,
                     chartIEXOnly = FALSE,
                     chartLastN = 0,
                     chartInterval = 1,
                     changeFromClose = FALSE,
                     chartReset = FALSE,
                     chartSimplify = FALSE,
                     date = "") {
  if (nchar(date)>0){
    timePeriod='date'
  }
  endpoint <- glue::glue('/stock/{symbol}/chart/{timePeriod}');
  if (nchar(date)==0){
    endpoint = paste0(endpoint,"/",date);
  }
  endpoint = paste(endpoint,glue::glue('?chartCloseOnly={chartCloseOnly}'));
  if (chartLastN > 0) {
    endpoint <- paste0(endpoint,glue::glue('&chartLast=${chartLastN}'));
  }
  if (timePeriod=="1d" & chartIEXOnly){
    endpoint <- paste0(endpoint,'&charIEXOnly=true');
  }
  if (chartInterval > 1) {
    endpoint <- paste0(endpoint,glue::glue('&chartInterval=${chartInterval}'));
  }
  if (changeFromClose) {
    endpoint <- paste0(endpoint,'&changeFromClose=true');
  }
  if (chartReset) {
    endpoint <- paste0(endpoint,'&chartReset=true');
  }
  if (chartSimplify) {
    endpoint <- paste0(endpoint,'&chartSimplify=true');
  }
  res = iex(endpoint);
  data <- lapply(res,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(date),dplyr::funs(as.Date(.)))
};

#' retrieve listSymbols  as dataframe
#' @param symbolType "symbols" | "iex" | "otc" | "mutual-fund" |
#' @return a dataframe
#' @export
#' @examples
#' symbols("iex")
listSymbols <- function (symbolType) {
  if (symbolType == 'symbols') {
    endpoint = '/ref-data/symbols'
  } else {
    endpoint <- glue::glue('/ref-data/{symbolType}/symbols');
  }
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,data))
};

#' retrieve income statement for a symbol as dataframe
#' @param symbol stock
#' @param period (quarter) "annual" | "quarter"
#' @param lastN (1) number of periods to report
#' @return a dataframe
#' @export
#' @examples
#' incomeStatement("AAPL",period = "quarter", lastN =4)
incomeStatement <- function (symbol,period = "quarter",lastN=1) {
  endpoint <- glue::glue('/stock/{symbol}/income/{lastN}?period={period}');
  res = iex(endpoint);
  data <- res$income
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(reportDate),dplyr::funs(as.Date(.)))
};

#' retrieve keyStats detail for a symbol as dataframe
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' keyStats("AAPL")
keyStats <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/stats');
  res = iex(endpoint);
  tibble::as_tibble(res)
};

#' retrieve quotes for symbols on defined lists as dataframe
#' @param listType one of   | "mostactive" | "gainers" | "losers" | "iexvolume" | "iexpercent" | "infocus";
#' @return a dataframe
#' @export
#' @examples
#' listOf("mostactive")
listOf <- function (listType = "mostactive") {
  endpoint <- glue::glue('/stock/market/list/{listType}');
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,res))
};

#' retrieve logo url for symbols on defined lists as string
#' @param symbol a market symbol
#' @return a string
#' @export
#' @examples
#' logo("AAPL")
logoFor <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/logo');
  iex(endpoint);
};

#' retrieve real time traded volume on U.S. markets.
#' @return a dataframe
#' @export
#' @examples
#' marketVolumn()
marketVolume <- function () {
  endpoint <- '/market';
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest();
};

#' retrieve real time traded volume on U.S. markets.
#' @return subject "market" | symbol
#' @export
#' @examples
#' newsFor('AAPL)
newsFor <- function (subject,lastN = 10) {
  if (subject == 'market'){
    endpoint = "/market/news/last/{lastN}"
  } else {
    endpoiont = '/stock/{subject}/last/{lastN}'
  }
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest();
};

#' retrieve the official open and close for a given symbol.
#' @return  symbol a market symbol
#' @export
#' @examples
#' ohlc('AAPL')
ohlc <- function (symbol) {
  endpoint = '/stock/{symbol}/ohlc'
  res = iex(endpoint);
};

#' retrieves an array of peer symbols.
#' @return  symbol a market symbol
#' @export
#' @examples
#' peers('AAPL')
peersOf <- function (symbol) {
  endpoint = '/stock/{symbol}/peers'
  res = iex(endpoint);
};

#' retrieve previous day adjusted price data for one or more stocks
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' previousDay("AAPL")
previousDay <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/previous');
  res = iex(endpoint);
  tibble::as_tibble(res)
};

#' retrieve current adjusted price data for one or more stocks
#' @param symbol stock symbol
#' @return a number
#' @export
#' @examples
#' priceOf("AAPL")
priceOf <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/price');
  iex(endpoint);
};

#' retrieve the latest avg, high, and low analyst price target for a symbol.
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' priceTarget("AAPL")
priveTarget <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/price-target');
  res = iex(endpoint);
  tibble::as_tibble(res)
};

#' retrieve quote detail for a symbol as dataframe
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' quoteFor("AAPL")
quoteFor <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/quote');
  res = iex(endpoint);
  tibble::as_tibble(res)
};
