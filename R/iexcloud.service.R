

readRenviron(".env")
env<-Sys.getenv();
iexcloud <- env[grep("^IEXCLOUD",names(env))];


baseURL = paste0("https://cloud.iexapis.com/",iexcloud["IEXCLOUD_API_VERSION"]);


addToken <- function(endpoint){
  ifelse(stringr::str_detect(endpoint,stringr::fixed("?")),
         paste0(endpoint, "&token=", iexcloud["IEXCLOUD_PUBLIC_KEY"]),
         paste0(endpoint, "?token=", iexcloud["IEXCLOUD_PUBLIC_KEY"])
  )
};



#' Perform a get request to an endpoint on the iexcloud server
#' @param endpoint a string which will form the variable are of the endpoint URL
#' @export
iex <- function(endpoint) {
  url <- addToken(paste0(baseURL,endpoint));
  res <- httr::GET(url);
  httr::content(res);
};


#' Perform a get request to an endpoint on the iexcloud server
#' @param endpoint a string which will form the variable are of the endpoint URL
#' @export
iexRaw <- function(endpoint) {
  url <- addToken(paste0(baseURL,endpoint));
  httr::GET(url);
};
#
