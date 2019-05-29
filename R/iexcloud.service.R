
#' return first argument that is not null
#'
#' @export
coalesce <- function(a,b,...) {
  if (!is.null(a)){
    return(a)
  }
  if (missing(b)){
    return (NULL)
  }
  coalesce(b,...)
}


addToken <- function(endpoint){
  token <- getToken();
  if (!is.null(token)) {
    result <- ifelse(stringr::str_detect(endpoint,stringr::fixed("?")),
                      paste0(endpoint, "&token=", getToken()),
                      paste0(endpoint, "?token=", getToken())
                    )
  } else {
    stop("missing IEXCLOUD_PRIVATE_KEY value")
  }
  return (result)
};

prefix <- function() {
  ifelse(substr(getToken(),1,1) == "T", getConfig()$sandboxURL, getConfig()$baseURL)
}

#' construct the url for the api get request
#' @export
constructURL <- function(endpoint) {
  paste0(prefix(),addToken(endpoint))
}

#' Perform a get request to an endpoint on the iexcloud server
#'
#' @param endpoint a string which will form the variable are of the endpoint URL
#' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
iex <- function(endpoint) {
  url <- constructURL(endpoint);
  # show(url);
  res <- httr::GET(url);
  setMessageCount(as.numeric(res$all_headers[[1]]$headers$`iexcloud-messages-used`))
  httr::content(res);
};

#' Perform a get request to an endpoint on the iexcloud server
#'
#' @param endpoint a string which will form the variable are of the endpoint URL
#' @return iex_api class parsed response data, this will usually be a list of key:value pairs from parsed json object
#' @export
iex_api <- function(endpoint) {
  url <- constructURL(endpoint);
  # show(url);
  resp <- httr::GET(url);
  msg_count <- as.numeric(resp$all_headers[[1]]$headers$`iexcloud-messages-used`);
  setMessageCount(msg_count)
  parsed <- list()
  if (httr::http_error(resp)) {
    warning(
      sprintf(
        "IEX API request failed [%s]\n%s\n%s\n%s",
        httr::status_code(resp),
        httr::content(resp, "text"),
        "endpoint requested:",
        endpoint
      ),
      call. = FALSE
    )
  } else {

  if (httr::http_type(resp) != "application/json") {
    warning(
      sprintf(
        "IEX API did not return json\n%s",
        httr::content(resp, "text")
      ),
      call. = FALSE
    );
    parsed <- list();
  } else {
    parsed <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE)
  }
  }

  structure(
    list(
      status = httr::http_error(resp),
      iexcloud_messages_used = msg_count,
      content = parsed,
      endpoint = endpoint,
      response = resp
    ),
    class = "iex_api"
  )

};


# #' Perform a get request to an endpoint on the iexcloud server, will show the complete url
# #' including security token being sent to the server for debug
# #'
# #' @param endpoint a string which will form the variable are of the endpoint URL
# #' @return parsed response data, this will usually be a list of key:value pairs from parsed json object
# iexdebug <- function(endpoint) {
#   url <- addToken(paste0(baseURL,endpoint));
#   show(url);
#   res <- httr::GET(url);
#   httr::content(res);
# };

#' Perform a get request to an endpoint on the iexcloud server
#'
#' @param endpoint a string which will form the variable are of the endpoint URL
#' #' @return raw response object
#' @export
iexRaw <- function(endpoint) {
  url <- constructURL(endpoint);
  httr::GET(url);
};
#

#' print S3 function for iex_api class
#' @export
print.iex_api <- function(x, ...){
  cat("<IEX ", x$endpoint, " >\n", sep = "")
  if (x$status) {
    cat("IEX Failed, Encountered HTTP_ERROR")
  } else {
      str(x$content)
  }
  invisible(x)
}
