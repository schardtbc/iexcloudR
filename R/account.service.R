

readRenviron(".env")
env<-Sys.getenv();
iexcloud <- env[grep("^IEXCLOUD",names(env))];


baseURL = paste0("https://cloud.iexapis.com/",iexcloud["IEXCLOUD_API_VERSION"]);


addSk <- function(endpoint){
  ifelse(stringr::str_detect(endpoint,stringr::fixed("?")),
         paste0(endpoint, "&token=", iexcloud["IEXCLOUD_SECRET_KEY"]),
         paste0(endpoint, "?token=", iexcloud["IEXCLOUD_SECRET_KEY"])
  )
};


#' Retrieve account details such as current tier, payment status, message quote usage, etc
#'
#' @param endpoint a string which will form the variable are of the endpoint URL
#' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
accountMetaData <- function() {
  url <- addSk(paste0(baseURL,"/account/metadata"));
  show(url)
  res <- httr::GET(url);
  httr::content(res);
};

#'  Retrieve current month usage for your account.
#'
#' @param endpoint a string which will form the variable are of the endpoint URL
#' @param type  "messages" | "rules" | "rule-records" | alterts" | "alert-records"
#' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
accountUsage <- function(type) {
  url <- addSk(paste0(baseURL,glue::glue("/account/usage/{type}")));
  res <- httr::GET(url);
  httr::content(res);
};

#' Used to enable Pay-as-you-go on your account.
#'
#'  Note when you turn off pay-as-you-go, there is a 30 second period before you can re-enable.
#'
#' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
enablePayAsYouGo <- function() {
  url <- paste0(baseURL,glue::glue("/account/usage/payasyougo"));
                  res <- httr::PUT(url,encode="raw",
                                   body=jsonlite::toJSON(list(token = iexcloud["IEXCLOUD_SECRET_KEY"],
                                             allow = TRUE),auto_unbox = TRUE),httr::add_headers(Accept = 'application/json', Impersonate = ImpersonateKey));
                  httr::content(res);
};

#' Used to disable Pay-as-you-go on your account.
#'
#'  Note when you turn off pay-as-you-go, there is a 30 second period before you can re-enable.
#'
#' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
disablePayAsYouGo <- function() {
  url <- paste0(baseURL,glue::glue("/account/payasyougo"));
                  res <- httr::PUT(url,encode="raw",
                                   body=jsonlite::toJSON(list(token = iexcloud["IEXCLOUD_SECRET_KEY"],
                                             allow = FALSE),auto_unbox = TRUE),httr::add_headers(Accept = 'application/json', Impersonate = ImpersonateKey));
                  httr::content(res);
};
