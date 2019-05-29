

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
  res <- iex_api(endpoint);
  data <- res$content$balancesheet
  if (!is.null(data) && length(data)>0){
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  result <- tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,period=period,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(reportDate),dplyr::funs(as.Date(.)))
  } else {
    result <- tibble::as_tibble()
  }
  return (result)
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
  res = iex_api(endpoint);
  data <- res$content$cashflow
  if (!is.null(data) && length(data)>0){
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  result <- tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,period=period,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(reportDate),dplyr::funs(as.Date(.)))
  } else {
    result <- tibble::as_tibble();
  }
  return(result)
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
  endpoint <- glue::glue('/stock/{symbol}/company')

  res = iex_api(endpoint)

  if (!res$status) {
    data <- lapply(res$content, function(x) {
      ifelse(is.null(x), NA, x)
    })

    result <-
      tibble::as_tibble(do.call(cbind, data)) %>% dplyr::select(-tags) %>% tidyr::unnest() %>% dplyr::distinct()

    if (length(res$tags) > 0) {
      result <-
        tibble::add_column(result, tags = do.call(paste, c(res$tags, sep = "; ")))

    } else {
      result <- tibble::add_column(result, tags = NA)

    }
  } else {
    return (tibble::as_tibble(list()))
  }
}


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
  res = iex_api(endpoint);
  if (!res$status) {
    tibble::as_tibble(res$content)
  } else {
    tibble::as_tibble(list())
  }
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
  res = iex_api(endpoint);
  if (!res$status) {
  data <- lapply(res$content,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest();
  } else {
    tibble::as_tibble(list());
  }
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- res$content$earnings
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
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
#' @return a dataframe
#' @export
#' @examples
#' earningsToday()
earningsToday <- function (symbol, lastN=1) {
  endpoint <- glue::glue('/stock/market/today-earnings');
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  df <-lapply(res$content,function(o) (tibble::as_tibble(do.call(rbind,lapply(o,function(x) {x[["quote"]]<-NULL; x})))))
  df <- tibble::enframe(df) %>% tidyr::unnest()
  df$consensusEPS <-as.numeric(unlist(df$consensusEPS))
  df <- df %>% tidyr::unnest() %>% dplyr::select(-name)
  return (df)
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  tibble::as_tibble(res$content)
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- res$content$estimates;
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- res$content$financials
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest();
};

#' Returns the top 10 fund holders,
#' meaning any firm not defined as buy-side or sell-side such as mutual funds,
#' pension funds, endowments, investment firms,
#' and other large entities that manage funds on behalf of others.
#'
#' Data Weighting: 10000 message units per symbol per period
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' fundOwnership("AAPL")
fundOwnership <- function (symbol, lastN=1) {
  endpoint <- glue::glue('/stock/{symbol}/fund-ownership/');
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- lapply(res$content,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate(report_date = lubridate::ymd(lubridate::as_datetime(report_date/1000)));
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
  if (class(date) == "Date") {
    date = format(date, "%Y%Om%d")

  }
  if (nchar(date) == 8 | nchar(date) == 10) {
    timePeriod = 'date'

    if (nchar(date) == 10) {
      date = format(lubridate::ymd(date), format = "%Y%Om%d")
    }
  }
  endpoint <- glue::glue('/stock/{symbol}/chart/{timePeriod}')

  if (nchar(date) == 8) {
    endpoint = paste0(endpoint, "/", date)

  }
  endpoint = paste0(endpoint, glue::glue('?chartCloseOnly={chartCloseOnly}'))

  if (chartLastN > 0) {
    endpoint <- paste0(endpoint, glue::glue('&chartLast=${chartLastN}'))

  }
  if ((timePeriod == "1d" | timePeriod == "date") & chartIEXOnly) {
    endpoint <- paste0(endpoint, '&chartIEXOnly=true')

  }
  if (chartInterval > 1) {
    endpoint <-
      paste0(endpoint, glue::glue('&chartInterval=${chartInterval}'))

  }
  if (changeFromClose) {
    endpoint <- paste0(endpoint, '&changeFromClose=true')

  }
  if (chartReset) {
    endpoint <- paste0(endpoint, '&chartReset=true')

  }
  if (chartSimplify) {
    endpoint <- paste0(endpoint, '&chartSimplify=true')

  }
  res = iex_api(endpoint)

  if (res$status)
    return (tibble::as_tibble(list()))
  data <-
    lapply(res$content, function(x) {
      lapply(x, function(y) {
        ifelse(is.null(y), NA, y)
      })
    })

  df <- tibble::as_tibble(do.call(rbind, data)) %>%
    tibble::add_column(symbol = symbol, .before = 1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(date), dplyr::funs(lubridate::ymd(.)))

  if (timePeriod == "1d" | timePeriod == 'date') {
    df <-
      dplyr::mutate(df, period = lubridate::period_to_seconds(lubridate::hm(minute))) %>%
      dplyr::mutate(dminute = (period - dplyr::first(period)) / 60) %>%
      dplyr::select(-period,-minute) %>%
      dplyr::rename(minute = dminute)

  }
  return (df)

}


#' Returns Insider Transactions
#'
#' Data Weighting: 50 message units per transaction
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' insiderTransactions("AAPL")
insiderTransactions <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/insider-transactions');
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- lapply(res$content,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate(effectiveDate = lubridate::ymd(lubridate::as_datetime(effectiveDate/1000)));
};





#' Returns Insider Roster
#'
#' Data Weighting: 5000 message units per symbol
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' insiderRoster("AAPL")
insiderRoster <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/insider-roster');
  res = iex_api(endpoint);
  data <- lapply(res$content,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest() %>%
  dplyr::mutate(reportDate = lubridate::ymd(lubridate::as_datetime(reportDate/1000)));
};

#' Returns Insider Summary
#'
#' Data Weighting: 5000 message units per symbol
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' insiderSummary("AAPL")
insiderSummary <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/insider-summary');
  res = iex_api(endpoint);
  data <- lapply(res$content,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,.before=1) %>%
    tidyr::unnest()

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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- res$content$income;
  if (!is.null(data) && length(data)>0){
  data <- lapply(data,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y)})});
  result <-tibble::as_tibble(do.call(rbind,data)) %>%
    tibble::add_column(symbol = symbol,period=period,.before=1) %>%
    tidyr::unnest() %>%
    dplyr::mutate_at(dplyr::vars(reportDate),dplyr::funs(as.Date(.)))
  } else {
    result <- tibble::as_tibble();
  }
  return (result)
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- lapply(res$content,function(y) {ifelse(is.null(y),NA,y[[1]])});
  tibble::as_tibble(data) %>%
  tibble::add_column(symbol = symbol,.before=1)
};

#' Retrieve advancedStats detail for a symbol as dataframe
#'
#' Data Weighting: 20 message units per call per symbol
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' keyStats("AAPL")
advancedStats <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/advanced-stats');
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- lapply(res$content,function(y) {ifelse(is.null(y),NA,y[[1]])});
  tibble::as_tibble(data)  %>%
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  tibble::as_tibble(do.call(rbind,res$content)) %>%
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- lapply(res$content,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y[[1]])})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tidyr::unnest();
};




#' Retrieve logo url for symbols on defined lists as string
#' @param symbol a market symbol
#' @return a string
#' @export
#' @examples
#' logo("AAPL")
logoFor <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/logo');
  res <- iex_api(endpoint);
  res <- res$content;
};

#' Retrieve real time traded volume on U.S. markets.
#' @return a dataframe
#' @export
#' @examples
#' marketVolumn()
marketVolume <- function () {
  endpoint <- '/market';
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  tibble::as_tibble(do.call(rbind,res$content)) %>%
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
newsFor <- function (subject,lastN = 5) {
  if (subject == 'market'){
    endpoint = glue::glue("/market/news/last/{lastN}")
  } else {
    endpoint = glue::glue("/stock/{subject}/news/last/{lastN}")
  }
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  tibble::as_tibble(do.call(rbind,res$content)) %>%
  tidyr::unnest() %>%
  tibble::add_column(symbol = subject,.before=1)
};

#' retrieve the official open and close for a given symbol.
#' @return  symbol a market symbol
#' @export
#' @examples
#' ohlc('AAPL')
ohlc <- function (symbol) {
  endpoint = glue::glue('/stock/{symbol}/ohlc')
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  res <- res$content;
  r <- list(open = res$open$price, openTime = res$open$time, close = res$close$price,
            closeTime = res$close$time, high=ifelse(is.null(res$high),NA,res$high),
            low = ifelse(is.null(res$low),NA,res$low));
  tibble::as_tibble(r) %>%
  dplyr::mutate(openTime = lubridate::as_datetime(openTime/1000, tz = "America/New_York"),
                closeTime = lubridate::as_datetime(closeTime/1000, tz = "America/New_York")) %>%
  tibble::add_column(symbol = symbol,.before=1)
};

#' retrieve the official open and close for all IEX symbols in the market. 15 min delayed
#' @return  df
#' @export
#' @examples
#' marketOpenClose()
marketOpenClose <- function () {
  endpoint = '/stock/market/ohlc'
  response = iex_api(endpoint);
  if (response$status) return (tibble::as_tibble(list()))
  records <- lapply(response$content,function(res) {list(open = ifelse(is.null(res$open$price),NA,res$open$price),
                                                 openTime = ifelse(is.null(res$open$time),NA,res$open$time),
                                                 close = ifelse(is.null(res$close$price),NA,res$close$price),
                                                 closeTime = ifelse(is.null(res$close$time),NA,res$close$time)
                                                 )});
  symbols <- names(records);
  tibble::as_tibble(do.call(rbind,records)) %>%
    tidyr::unnest() %>%
    dplyr::mutate(openTime = lubridate::as_datetime(openTime/1000, tz = "America/New_York"),
                  closeTime = lubridate::as_datetime(closeTime/1000, tz = "America/New_York"),
                  gain = dplyr::case_when(
                    openTime>closeTime ~ round(100*(open-close)/close,2),
                    closeTime>openTime ~ round(100*(close-open)/open,2))) %>%
    tibble::add_column(symbol = symbols,.before=1) %>%
    dplyr::arrange(symbol)
};

#' retrieves an array of peer symbols.
#'
#' Data Weighting: 500 message units per call
#'
#' @return  an array of market symbols
#' @export
#' @examples
#' peers('AAPL')
peersOf <- function (symbol) {
  endpoint = glue::glue('/stock/{symbol}/peers')
  res = iex_api(endpoint);
  if (res$status) return (list())
  res$content
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  tibble::as_tibble(res$content)
};

#' Retrieve previous day adjusted price data for one or more stocks
#'
#' Data Weighting: 2 message units per symbol
#'
#' @param df dataframe returned from previousDay call
#' @return a dataframe
#' @export
#' @examples
#' previousDay("AAPL") %>% dailyTimeSeriesAdapter()
dailyTimeSeriesAdapter <- function (df) {
    dplyr::rename(df,aOpen = open, aHigh = high, aLow = low, aClose = close, aVolume = volume,
           open = uOpen,high=uHigh,low=uLow,close=uClose, volume = uVolume) %>%
    dplyr::mutate(
           datetime = lubridate::as_datetime(paste0(date," 09:30:00"), tz = "America/New_York"),
           sequenceID = 0,
           sourceName = "IEX",
           dividendAmount=0,
           splitCoefficient = 0,
           epoch = as.numeric(lubridate::seconds(datetime))) %>%
    dplyr::select(symbol,date,sourceName,sequenceID,datetime,epoch,open,high,low,close,volume,aOpen,aHigh,aLow,aClose,aVolume,dividendAmount,splitCoefficient)
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
  res <-iex_api(endpoint);
  if (res$status) return (NA)
  res$content
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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  tibble::as_tibble(res$content)
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
  res <- iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- lapply(res$content, function(x) { ifelse( is.null(x),NA,x)})
  tibble::as_tibble(data)
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
  if (nchar(date) == 10){
    date=format(lubridate::ymd(date),format = "%Y%Om%d")
  }
  endpoint <- glue::glue('/stock/{symbol}/sentiment/{type}/{date}');
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  if (type == "daily"){
    tibble::as_tibble(res$content)
  } else {
    tibble::as_tibble(do.call(rbind,res$content)) %>%
      tidyr::unnest();
  }
};

#' Analyst Recommendation Summary
#'
#' 1000 message units per symbol
#'
#' @param symbol stock symbol
#' @return a dataframe
#' @export
#' @examples
#' recommendationTrends("AAPL")
recommendationTrend <- function (symbol) {
  endpoint <- glue::glue('/stock/{symbol}/recommendation-trends');
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- lapply(res$content,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y[[1]])})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tidyr::unnest() %>%
  dplyr::mutate(consensusEndDate = lubridate::ymd(lubridate::as_datetime(consensusEndDate/1000)),
                consensusStartDate = lubridate::ymd(lubridate::as_datetime(consensusStartDate/1000)),
                corporateActionsAppliedDate = lubridate::ymd(lubridate::as_datetime(corporateActionsAppliedDate/1000)));
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
#' @param period "next" | "1m" | "3m" | "6m" | "ytd" | "1y" | "2y" | "5y"
#' @return a dataframe
#' @export
#' @examples
#' splits("AAPL", period = "1m")
splits <- function (symbol, period = "next") {
  endpoint <- glue::glue('/stock/{symbol}/splits/{period}')

  res = iex_api(endpoint)

  if (res$status)
    return (tibble::as_tibble(list()))
  data <-
    lapply(res, function(x) {
      lapply(x, function(y) {
        ifelse(is.null(y), NA, y[[1]])
      })
    })

  tibble::as_tibble(do.call(rbind, data)) %>%
    tidyr::unnest()


}


#' returns upcoming earnings reportDates for market
#'
#' @export
upcomingEarnings<- function(symbol = "market"){
  endpoint <- glue::glue("/stock/{symbol}/upcoming-earnings")
  res = iex_api(endpoint)
  if (res$status) return (tibble::as_tibble(list()))
  tibble::as_tibble(do.call(rbind,res$content)) %>%
    tidyr::unnest() %>% dplyr::arrange(symbol)
}


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
  res = iex_api(endpoint);
  if (res$status) return (tibble::as_tibble(list()))
  data <- lapply(res$content,function(x){ lapply(x, function(y) {ifelse(is.null(y),NA,y[[1]])})});
  tibble::as_tibble(do.call(rbind,data)) %>%
    tidyr::unnest() %>%
    tibble::add_column(symbol = symbol,.before=1);
}

