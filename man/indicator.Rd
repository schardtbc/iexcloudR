% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stock.service.R
\name{indicator}
\alias{indicator}
\title{indicator}
\usage{
indicator(symbol, technicalIndicator, range, ...)
}
\arguments{
\item{symbol}{a stock symbol}
}
\description{
Data Weighting 50 per indicator value + weight of chart data returned
}
\examples{
indicator("AAPL","macd","6m")
}
