

#' Pulls balance sheet data. Available quarterly (4 quarters) and annually (4 years)
#'
#' Data Weighting: 3000 message units per symbol per period
#'
#' Data Schedule: Updates at 8am, 9am UTC daily
#'
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

#' Pulls cash flow data. Available quarterly (4 quarters) and annually (4 years)
#'
#' Data Weighting: 1000 message units per symbol per period
#'
#' Data Schedule: Updates at 8am, 9am UTC daily
#'
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
#'
#'  Data Weighting: 1 message unit per symbol
#'
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

#' Retrieve delayed quote for a symbol as dataframe
#'
#' Data Weighting: 1 per quote called
#'
#' Data Timing: 15min delayed
#'
#' Data Schedule: 4:30am - 8pm ET M-F when market is open
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' delayedQuote("AAPL")
delayedQuote <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/quote');
  res = iex(endpoint);
  tibble::as_tibble(res)
};

#' Retrieve dividends detail for a symbol as dataframe
#'
#' Data Weighting: 10 message unit per period returned
#'
#' Data Schedule: Updated at 9am UTC every day
#'
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

#' Retrieve Earnings data for a given company including the actual EPS, consensus, and fiscal period.
#'  Earnings are available quarterly (last 4 quarters) and annually (last 4 years).
#'
#' Data Weighting: 1000 mesaage units per symbol per period
#'
#' Data Schedule: Updates at 9am, 11am, 12pm UTC every da
#'
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
#'
#' This returns an array of effective spread, eligible volume, and price improvement of a stock, by market.
#'  Unlike volume-by-venue, this will only return a venue if effective spread is not ‘N/A’.
#'  Values are sorted in descending order by effectiveSpread.
#'  Lower effectiveSpread and higher priceImprovement values are generally considered optimal.
#'
#' Effective spread is designed to measure marketable orders executed in relation to the market center’s
#'  quoted spread and takes into account hidden and midpoint liquidity available at each market center.
#'  Effective Spread is calculated by using eligible trade prices recorded to the consolidated tape
#'  and comparing those trade prices to the National Best Bid and Offer (“NBBO”) at the time of the execution.
#'
#'  Data Weighting: 0 message units (as in free)
#'
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

#' Provides the latest consensus estimate for the next fiscal period
#'
#' Data Weighting: 10000 message units per symbol per period
#'
#' Data Schedule: Updates at 9am, 11am, 12pm UTC every day
#'
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

#' Pulls income statement, balance sheet, and cash flow data from the most recent reported quarter.
#'
#' Data Weighting: 5000 message units per symbol per period
#'
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

#' Retrieve history for a stock over chosen time-period as dataframe
#'
#' Data Weighting:
#'
#' - Adjusted + Unadjusted data: 10 message units per symbol per time interval returned (Excluding 1d)
#'   Example: If you query for AAPL 5 day, it will return 5 days of prices for AAPL for a total of 50.
#' - Adjusted close only data (chartCloseOnly=TRUE) 2 mu per symbol per time interval returned (Excluding 1d)
#' - Intraday minute bar data: 1 mu per symbol per time interval for 1d range up to a max of 50
#'   Example: If you query for AAPL 1d at 11:00am, it will return 90 minutes of data for a total of 50.
#' - IEX Only intraday minute bar data (chartIEXOnly=TRUE): 0 mu (as in free)
#'   This will only return IEX data with keys minute, high, low, average, volume, notional, and numberOfTrades
#'
#' @param symbol stock symbol
#' @param timePeriod is one of "dynamic" | "date" | "1d" | "1m" | "3m" | "6m" | "ytd" | "1y" | "2y" | "5y"
#' @param chartCloseOnly = FALSE,(1 mu/minute 50 max.) All ranges except 1d. Will return adjusted data only with keys date, close, and volume.
#' @param chartIEXOnly = FALSE,(free) Only for 1d. Limits the return of intraday prices to IEX only data.
#' @param chartLastN = 0, If passed, chart data will return the last N elements
#' @param chartInterval = 1,If passed, chart data will return every Nth element as defined by chartInterval
#' @param changeFromClose = FALSE, If true, changeOverTime and marketChangeOverTime will be relative to previous day close instead of the first value.
#' @param chartReset = FALSE, If true, 1d chart will reset at midnight instead of the default behavior of 9:30am ET.
#' @param chartSimplify = FALSE, If true, runs a polyline simplification using the Douglas-Peucker algorithm. This is useful if plotting sparkline charts.
#' @param date as "YYYY-MM-DD"| "YYYYMMDD" | class(date) == "Date"
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
  if (class(date)=="Date"){
    date=format(date,"%Y%Om%d");
  }
  if (nchar(date)==8 | nchar(date)==10){
    timePeriod='date';
    if (nchar(date) == 10){
    date=format(lubridate::ymd(date),format = "%Y%Om%d")
    }
  }
  endpoint <- glue::glue('/stock/{symbol}/chart/{timePeriod}');
  if (nchar(date)==8){
    endpoint = paste0(endpoint,"/",date);
  }
  endpoint = paste0(endpoint,glue::glue('?chartCloseOnly={chartCloseOnly}'));
  if (chartLastN > 0) {
    endpoint <- paste0(endpoint,glue::glue('&chartLast=${chartLastN}'));
  }
  if ((timePeriod=="1d" | timePeriod=="date" ) & chartIEXOnly){
    endpoint <- paste0(endpoint,'&chartIEXOnly=true');
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
  df <- tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(date),dplyr::funs( lubridate::ymd(.)));
  if (timePeriod == "1d" | timePeriod == 'date') {
  df <- dplyr::mutate(df, period = lubridate::hm(minute)) %>%
    dplyr::mutate(dminute = lubridate::period_to_seconds(period - period[1])/60) %>%
    dplyr::select(-period,-minute) %>%
    dplyr::rename(minute = dminute);
  }
  return (df);
};

#' This call returns an array of symbols that IEX Cloud supports for API calls.
#'
#' Data Weighting:
#' - symbols, otc, mutual-fund: 100 message units per call
#' - iex: free;
#'   This call returns an array of symbols the Investors Exchange supports for trading.
#'    This list is updated daily as of 7:45 a.m. ET. Symbols may be added or removed by
#'    the Investors Exchange after the list was produced.
#'
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

#' Retrieve income statement data. Available quarterly (4 quarters) or annually (4 years).
#'
#' Data Weighting: 1000 message units per symbol per period
#'
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

#' Retrieve keyStats detail for a symbol as dataframe
#'
#' Data Weighting: 20 message units per call per symbol
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' keyStats("AAPL")
keyStats <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/stats');
  res = iex(endpoint);
  tibble::as_tibble(res) %>%
  tibble::add_column(symbol = symbol,.before=1)
};

#' Retrieve 15 minute delayed, last sale eligible trades.
#'
#' Data Weight: 1 message unit per trade returned
#'
#' @param symbol a market symbol
#' @return a dataframe
#' @export
#' @examples
#' largestTrades("mostactive")
largestTrades <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol/largest-trades');
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,res)) %>%
  tibble::add_column(symbol = symbol,.before=1)
};


#' Retrieve quotes for symbols on defined lists as dataframe
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




#' Retrieve logo url for symbols on defined lists as string
#' @param symbol a market symbol
#' @return a string
#' @export
#' @examples
#' logo("AAPL")
logoFor <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/logo');
  iex(endpoint);
};

#' Retrieve real time traded volume on U.S. markets.
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

#' Retrieve real time traded volume on U.S. markets.
#'
#' Data Weight: 1 message unit per call
#'
#' @return subject "market" | symbol
#' @export
#' @examples
#' newsFor('AAPL')
newsFor <- function (subject,lastN = 10) {
  if (subject == 'market'){
    endpoint = "/market/news/last/{lastN}"
  } else {
    endpoiont = '/stock/{subject}/last/{lastN}'
  }
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest() %>%
    tibble::add_column(symbol = symbol,.before=1)
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
#'
#' Data Weighting: 500 message units per call
#'
#' @return  symbol a market symbol
#' @export
#' @examples
#' peers('AAPL')
peersOf <- function (symbol) {
  endpoint = '/stock/{symbol}/peers'
  res = iex(endpoint);
};

#' Retrieve previous day adjusted price data for one or more stocks
#'
#' Data Weighting: 2 message units per symbol
#'
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

#' Retrieve A single number, being the IEX real time price, the 15 minute delayed market price, or the previous close price, is returned.
#'
#' Data Weighting: 1 message unit per symbol
#'
#' @param symbol stock symbol
#' @return a number
#' @export
#' @examples
#' priceOf("AAPL")
priceOf <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/price');
  iex(endpoint);
};

#' Retrieve the latest avg, high, and low analyst price target for a symbol.
#'
#' Data Weighting: 500 message units per symbol
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' priceTarget("AAPL")
priceTarget <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/price-target');
  res = iex(endpoint);
  tibble::as_tibble(res)
};

#' retrieve quote detail for a symbol as dataframe
#'
#' Data Weighting: 1 per quote called or streamed
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' quoteFor("AAPL")
quoteFor <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/quote');
  res <- iex(endpoint);
  res <- lapply(res, function(x) { ifelse( is.null(x),NA,x)})
  tibble::as_tibble(res)
};

#' Retrieve Social Sentiment Data from StockTwits. Data can be viewed as a daily value, or by minute for a given date.
#'
#' Data Weighting:
#' - 100 per symbol per date for daily sentiment
#' - 200 per symbol per date for by minute sentiment
#'
#' Data Timing: Realtime
#'
#' Data Schedule: Continuous
#'
#' Data Source(s): StockTwits
#'
#' @param symbol stock symbol
#' @param date as string YYYYMMDD, supposed to be optional, but is required at this time
#' @param type "daily" | "minute"
#' @return a dataframe
#' @export
#' @examples
#' socialSentiment("AAPL", "20190206","daily")
socialSentiment <- function (symbol, date, type="daily") {
  endpoint <- glue::glue('/stock/{symbol}/sentiment/{type}/{date}');
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest();
};

#' Retrieve splits for a symbol
#'
#' Data Weighting: 10 per symbol per record
#'
#' Data Schedule: Updated at 9am UTC every day
#'
#' Data Source(s): EventVestor
#'
#' @param symbol stock symbol
#' @param date as string YYYYMMDD, supposed to be optional, but is required at this time
#' @param period "next" | "1m" | "3m" | "6m" | "ytd" | "1y" | "2y" | "5y"
#' @return a dataframe
#' @export
#' @examples
#' splits("AAPL", period = "1m")
splits <- function (symbol, date, type="daily") {
  endpoint <- glue::glue('/stock/{symbol}/sentiment/{type}/{date}');
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest();
};

#' Returns 15 minute delayed and 30 day average consolidated volume percentage of a stock, by market.
#'  This call will always return 13 values, and will be sorted in ascending order by current day trading volume percentage.
#'
#' Data Weighting: 20 message units per call
#'
#' Data Timing: 15 min delayed
#'
#' Data Schedule: Updated during regular market hours 9:30am-4pm ET
#'
#'Data Source(s): Consolidated Tape Investors Exchange
#'
#' @param symbol a market symbol
#' @export
#' @examples
#' volumeByVenue('AAPL')
volumeByVenue <- function(symbol) {
  endpoint <- glue::glue('/stock/{symbol}/volume-by-venue');
  res = iex(endpoint);
  tibble::as_tibble(do.call(rbind,res)) %>%
    tidyr::unnest() %>%
    tibble::add_column(symbol = symbol,.before=1);
}

