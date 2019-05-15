

addSk <- function(endpoint){
  token <- getConfig()$secretKey;
  if (!is.null(token)) {
  result <- ifelse(stringr::str_detect(endpoint,stringr::fixed("?")),
         paste0(endpoint, "&token=", token),
         paste0(endpoint, "?token=", token)
  )
  } else {
    stop("missing IEXCLOUD_SECRET_KEY value")
  }
  return (result)
};


#' Retrieve account details such as current tier, payment status, message quote usage, etc
#'
#' @param endpoint a string which will form the variable are of the endpoint URL
#' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
accountMetaData <- function() {
  url <- addSk(paste0(getConfig()$baseURL,"/account/metadata"));
  res <- httr::GET(url);
  httr::content(res);
};

#'  Retrieve current month usage for your account.
#'
#' @param endpoint a string which will form the variable are of the endpoint URL
#' @param type  "messages" | "rules" | "rule-records" | alterts" | "alert-records"
#' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
accountUsage <- function(type="") {
  url <- addSk(paste0(getConfig()$baseURL,glue::glue("/account/usage/{type}")));
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
  url <- paste0(getConfig()$baseURL,"/account/payasyougo");
  res <- httr::POST(url,config = httr::add_headers(`content-type` = 'application/json'),
                encode="json",
                body=jsonlite::toJSON(list(token = getConfig()$secretKey,
                                           allow = TRUE),auto_unbox = TRUE)
         );
  return (res)
};

#' Used to disable Pay-as-you-go on your account.
#'
#'  Note when you turn off pay-as-you-go, there is a 30 second period before you can re-enable.
#'
#' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
disablePayAsYouGo <- function() {
  url <- paste0(getConfig()$baseURL,"/account/payasyougo");
  res <- httr::POST(url,config = httr::add_headers(`content-type` = 'application/json'),
                    encode="json",
                    body=jsonlite::toJSON(list(token = getConfig()$secretKey,
                                               allow = FALSE),auto_unbox = TRUE)
  );
  return (res)
};
