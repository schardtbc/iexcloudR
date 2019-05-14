

if (file.exists(".env")){
  print("reading .env file")
  readRenviron(".env");
}
env<-Sys.getenv();
iexcloud <- env[grep("^IEXCLOUD",names(env))];


baseURL = paste0("https://cloud.iexapis.com/",iexcloud["IEXCLOUD_API_VERSION"]);
sandboxURL = paste0("https://sandbox.iexapis.com/",iexcloud["IEXCLOUD_API_VERSION"]);

print(env);
print(baseURL);
print(sandboxURL);



addToken <- function(endpoint){
  ifelse(stringr::str_detect(endpoint,stringr::fixed("?")),
         paste0(endpoint, "&token=", iexcloud["IEXCLOUD_PUBLIC_KEY"]),
         paste0(endpoint, "?token=", iexcloud["IEXCLOUD_PUBLIC_KEY"])
  )
};

prefix <- function() {
  ifelse(substr(iexcloud["IEXCLOUD_PUBLIC_KEY"],1,1) == "T", sandboxURL, baseURL)
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
  httr::content(res);
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
