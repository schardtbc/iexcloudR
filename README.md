



# iexcloudR

[![CircleCI](https://circleci.com/gh/schardtbc/iexcloudR.svg?style=svg)](https://circleci.com/gh/schardtbc/iexcloud_api_wrapper)
[![tested with testthat](https://img.shields.io/badge/tested_with-testthat-99424f.svg)](https://github.com/r-lib/testthat) 


An R language wrapper for the new iexcloud market data API from IEX Group Inc. All data is returned dataframes (actually tibbles).

This package is a companion to the NodeJS package [iexcloud-api-wrapper](https://github.com/schardtbc/iexcloud_api_wrapper) 

## Usage

To install as a dependancy into your project at the R REPL command prompt

```r
install.github("git+https://git@github.com/schardtbc/iexcloudR")
```

then in your .env file add the following keys

```
IEXCLOUD_API_VERSION = "beta"
IEXCLOUD_PUBLIC_KEY = "pk_..."
IEXCLOUD_SECRET_KEY = "sk_..."

# use the pk and sk obtained from your iexcloud account
# make sure the .env file is in your .gitignore file
# do not hard code the keys into your application code
# do not upload the keys to github.
# you can easily change the keys if they become compromised
```

To test that everything installed correctly and the .env file is properly setup you can use the following or similar code

```r
library(iexcloudR)

history("AAPL")
```

## About iexcloud

iexcloud is a product of [IEX Group Inc.]( https://iextrading.com ) which operates the Investors Exchange IEX, a stock exhange for US equities which trades > 9B notational value on a daily basis.

Using iexcloud requires [registration](https://iexcloud.io/cloud-login#/register)  to obtain a unique api key which is used for all data requests.

A majority of the endpoints are charged a usage free which varies by the source and type of data returned. All IEX Group sourced data is free. 

Each endpoint is assigned a cost in terms of message units.

| Plan | Monthly Message Unit Allotment | Monthy Fee
|------|--------------------------------:|:------------|
| Free | 500,000 | Free
| Launch | 5,000,000 | $9 |
| Scale | 1,000,000,000 | $ 499 |

see https://iexcloud.io/pricing/ for current plans, rates


## Api reference documentation

https://iexcloud.io/docs/api/#introduction

## Attribution to IEX

Attribution is required of all users of iexcloud. Put “Powered by IEX Cloud” somewhere on your site or app, and link that text to https://iexcloud.io. Alternately, the attribution link can be included in your terms of service.

<a href="https://iexcloud.io">Powered by IEX Cloud</a>

## Current Implementation Status

Below is a list of the iexcloud APIs that have ([x]) and have not ([ ]) been implemented by this package.

### Account

|     | Endpoint       | Message Units | per |
|-----|----------------|---------------:|-----|
| [ ] | MetaData | 0 | as in free
| [ ] | Usage | 0 | as in free
| [ ] | Pay as you go | 0 | as in free


### Stocks
|     | Endpoint       | Message Units | per |
|-----|----------------|---------------:|-----|
| [x] | Balance Sheet |        3000 | per symbol per period |
| [ ] | Batch Requests |    varies | with data types requested |     
| [ ] | Book |                     1 |per symbol   
| [x] | Cash Flow |             1000 |per symbol per period
| [ ] | Collections  |             1 |per symbol in  collection
| [x] | Company  |                 1 |per symbol
| [x] | Delayed Quote  |           1 |per symbol
| [x] | Dividends  |              10 |per symbol
| [x] | Earnings |              1000 |per symbol per period
| [ ] | Earnings Today|         1051 |per symbol returned
| [x] | Effective Spread  |         0  |as in free
| [x] | Estimates |             10000  |per symbol per period
| [x] | Financials  |            5000 |per symbol per period
| [x] | Historical Prices | | |
| [x] | End of day |    10 |per symbol per day
| [x] | Income Statement |  1000 | per symbol per period
| [ ] | IPO Calendar upcoming-ipos | 100 | per IPO returned
| [ ] | IPO Calendar today-ipos | 500 | per iPO returned
| [x] | Key Stats | 20 | per symbol
| [ ] | Largest Trades | 1 | per trade returned
| [ ] | List | 1 | per quote returned
| [ ] | Logo | 1 | per logo
| [ ] | Market Volume (U.S.) | 1 | per call
| [ ] | News | 10 | per news item returned
| [ ] | OHLC | 2 | per symbol
| [ ] | Peers | 500 | per symbol
| [ ] | Previous Day Prices | 2 per symbol
| [ ] | Price | 1 | per symbol per call
| [ ] | Price Target | 500 per symbol
| [X] | Quote | 1 | per quote 
| [ ] | Sector Performance | 1 | per sector
| [ ] | Social Sentiment, daily | 100 | per date
| [ ] | Social Sentiment, by minute | 200 | per date
| [ ] | Splits | 10 | per symbol  per record
| [ ] | Volume by Venue | 20 | per call

### Alternative Data
|     | Endpoint       | Message Units | per |
|-----|----------------|---------------:|-----|
| [ ] | News
| [ ] | Crypto

### Reference Data
|     | Endpoint       | Message Units | per |
|-----|----------------|---------------:|-----|
| [ ] | Symbols | 100 | per call |
| [ ] | IEX Symbols | 0 | as in free
| [ ] | U.S. Exchanges | 1 | per call
| [ ] | U.S. Holidays and Trading Days | 1 | per call
| [ ] | Stock Tags
| [ ] | Stock Collections
| [ ] | Mutual Fund Symbols | 100 | per call
| [ ] | OTC Symbols | 100 | per call
| [ ] | Forex / Currency Symbols
| [ ] | Options Symbols
| [ ] | Commodities Symbols
| [ ] | Bonds Symbols
| [ ] | Crypto Symbols

### Investors Exchange Data [Free]

|     | Endpoint       |
|-----|----------------|
| [ ] | TOPS | 
| [ ] | TOPS Last | 
| [ ] | DEEP | 
| [ ] | DEEP Auction | 
| [ ] | DEEP Book |
| [ ] | DEEP Operational Halt Status |
| [ ] | DEEP Official Price | 
| [ ] | DEEP Security Event |
| [ ] | DEEP Short Sale Price Tst Status | 
| [ ] | DEEP System Event |
| [ ] | DEEP Trades |
| [ ] | DEEP Trade Break |
| [ ] | DEEP Trading Status |
| [ ] | Listed Regulation SHO Threshold Securities List |
| [ ] | Listed Short Interest List |
| [ ] | Stats Historical Daily |
| [ ] | Stats Historical Summary |
| [ ] | Stats Intraday |
| [ ] | Stats Recent | 
| [ ] | Stats Records |

### API System Metadata
|     | Endpoint       | Message Units | per |
|-----|----------------|---------------:|-----|
| [ ] | Status | 0 |

## In Development at IEX Group

- FOREX CURRANCIES
- OPTIONS
- COMMODITIES
- BONDS
- REALTME, SCALABLE NOTIFICATIONS
- EVENT DRIVEN AUTOMATED RULES FOR SERVERLESS DATA ANALYSIS
