
config <- new.env(parent = emptyenv())

#' returns package configuration
#' @export
getConfig <- function(){
  config
}

.onLoad <- function(libname, pkgname) {
    if (file.exists(".env")){
      print("reading .env file")
      readRenviron(".env");
    }

  env<-Sys.getenv();
  iexcloud <- env[grep("^IEXCLOUD",names(env))];
  config$baseURL = paste0("https://cloud.iexapis.com/",iexcloud["IEXCLOUD_API_VERSION"]);
  config$sandboxURL = paste0("https://sandbox.iexapis.com/",iexcloud["IEXCLOUD_API_VERSION"]);
  config$token <- iexcloud["IEXCLOUD_PUBLIC_KEY"]
  config$secretKey <- iexcloud["IEXCLOUD_SECRET_KEY"]
  print(config);
}
