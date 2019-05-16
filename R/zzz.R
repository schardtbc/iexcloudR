
config <- new.env(parent = emptyenv())

#' returns package configuration
#' @export
getConfig <- function(){
  config
}

#' set the IEX API token
#' @param token iex cloud token
#' @export
setToken <- function(token){
  config$token <- token;
}

#' retrieve the IEX API token
#' @param token iex cloud token
#' @export
getToken <- function(){
  config$token;
}

#' set the IEX API Key
#' @param secretKey iex cloud secret key
#' @export
setSecretKey <- function(secretKey){
  config$secretKey <- secretKey;
}

#' log the last messageCount
#' @param mc the message count
#' @export
setMessageCount <- function(mc){
  config$messageCount <-mc;
}

#' get the message count for the last api request
#' @export
getMessageCount <- function(){
  config$messageCount
}

.onLoad <- function(libname, pkgname) {
    if (file.exists(".env")){
      readRenviron(".env");
    }

  env<-Sys.getenv();
  iexcloud <- as.list(env[grep("^IEXCLOUD",names(env))]);
  config$apiVersion <- coalesce(iexcloud$IEXCLOUD_API_VERSION,"v1")
  config$baseURL <- paste0("https://cloud.iexapis.com/",iexcloud$IEXCLOUD_API_VERSION);
  config$sandboxURL <- paste0("https://sandbox.iexapis.com/",iexcloud$IEXCLOUD_API_VERSION);
  token = iexcloud$IEXCLOUD_PUBLIC_KEY;
  if (is.null(token)) {
    warning('IEXCLOUD_PUBLIC_KEY must be provided in environment file to access IEX Cloud API')
  }
  secret_key = iexcloud$IEXCLOUD_SECRET_KEY;
  if (is.null(secret_key)){
    warning('IEXCLOUD_SECRET_KEY must be must be provided in environment file to access IEX Cloud API')
  }
  config$token <- token
  config$secretKey <- secret_key
  invisible(config)
}
