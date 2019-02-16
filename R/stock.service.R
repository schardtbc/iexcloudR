


#' retrieve balance sheet for a symbol as dataframe
#' @param symbol stock symbol
#' @param period (quarter) "annual" | "quarter"
#' @param lastN (1) number of periods to report
#' @return a dataframe
#' @export
#' @examples
#' balance_sheet("AAPL",period = "quarter", lastN =4)
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
history <- function (symbol,
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

#' retrieve quote detail for a symbol as dataframe
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' getQuote("AAPL")
getQuote <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/quote');
  res = iex(endpoint);
  tibble::as_tibble(res)
};


