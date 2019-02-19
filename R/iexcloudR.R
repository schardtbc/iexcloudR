#' icloudR: A wrapper for the IEX Cloud API
#'
#' ##What is IEX Cloud?
#'
#' The IEXCloud is a micropayment Api for financial and stock quote data.
#' The Api is hosted by IEX Group Inc. [The Investors Exchange](https://iextrading.com/).
#' Using the Api requires [registration](https://iexcloud.io/cloud-login#/register).
#'
#' There is a free tier for use during initial api exploration and application development.

#' - [Pricing](https://iexcloud.io/pricing/)
#' - [Api Documentation](https://iexcloud.io/docs/api/)
#'
#' This is functional wrapper which returns data as tibbles, with a few exceptions.
#' See the package documentation for call signitures, parameter descriptions, and the
#' micropayment cost of each function call.
#'
#' ## Security Tokens
#'
#' During resistration at icloud.io you were given security tokens required to access this API.
#' This wrapper will read those tokens from the .env file. The .env file must include the
#' following three key pairs: note(put .env in your .gitignore file)
#'
#' ```
#' IEXCLOUD_VERSION = "BETA"
#' IEXCLOUD_PRIVATE_KEY = "pk_.........."
#' IEXCLOUD_SECRET_KEY  = "sk_.........."
#' ```
#'
#' @docType package
#' @name iexcloudR
#' @author Bruce C. Schardt, \email{schardt.bruce.curtis@@gmail.com}
NULL
