#' @title Set NITRC credentials.
#' @description Sets and returns the NITRC credentials. Should error
#' if it cannot find the environment variables or they are not provided.
#' @param username is the NITRC login user name. If \code{NULL} this will
#' should be provided through the \code{NITRC_WEB_USER} system variable.
#' @param password is the NITRC login user password If \code{NULL} this will
#' should be provided through the \code{NITRC_WEB_PASS} system variable.
#' @param error Should this function error if variables are not specifed?
#'
#' @return List of \code{username} and \code{password}
#' @export
set_credentials = function(
  username = NULL,
  password = NULL,
  error = TRUE) {

  if(is.null(username)){
    username = Sys.getenv("NITRC_WEB_USER")
  }
  else {
    Sys.setenv("NITRC_WEB_USER" = username)
  }

  if(is.null(password)){
    password = Sys.getenv("NITRC_WEB_PASS")
  }
  else {
    Sys.setenv("NITRC_WEB_PASS" = password)
  }

  value_present = function(x){
    if(is.null(x)) {
      return(x)
    }
    if(x == ""){
      x = NULL
    }
    return(x)
  }

  C = list(
    username = value_present(username),
    password = value_present(password)
  )

  not_null = !sapply(C, is.null)
  if(!all(not_null)){
    missing = names(C)[!not_null]
    if(error){
      stop(paste0(missing, collapse = " and "), " are not specified")
    }
  }
  return(C)
}

#' @title Login to NITRC
#' Returns TRUE is NITRC credentials are valid.
#' @export
#' @importFrom RCurl getCurlHandle, postForm, getURL
nitrc_login = function(){
  C = set_credentials(error = FALSE)
  curl <- getCurlHandle()
  curlSetOpt(cookiejar="cookies.txt", curl=curl)
  postForm("https://www.nitrc.org/account/login.php", form_loginname=C$username, form_pw=C$password, curl=curl)
  result <- getURL("https://www.nitrc.org/account/", curl=curl)
  if(result == ""){
    return(FALSE)
  }
  return(TRUE)
}
