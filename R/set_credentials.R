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
set_credentials = function(username = NULL,
                           password = NULL,
                           error = TRUE
                           ) {

  if(is.null(username)) {
    username = Sys.getenv("NITRC_WEB_USER")
  }
  else {
    Sys.setenv("NITRC_WEB_USER" = username)
  }

  if(is.null(password)) {
    password = Sys.getenv("NITRC_WEB_PASS")
  }
  else {
    Sys.setenv("NITRC_WEB_PASS" = password)
  }

  value_present = function(x) {
    if(x == ""){
      x = NULL
    }
    return(x)
  }

  C = list(
    form_loginname = value_present(username),
    form_pw = value_present(password),
    submit = "login"
  )

  not_null = !sapply(C, is.null)
  if(!all(not_null)) {
    missing = names(C)[!not_null]
    if(error){
      stop(paste0(missing, collapse = " and "), " are not specified")
    }
  }
  return(C)
}

#' @title Login to NITRC
#' @description Returns TRUE if NITRC credentials are valid.
#' @return boolean indicating if the login was successful
#' @importFrom httr GET POST content authenticate
#' @export
nitrc_login = function() {
  C = set_credentials(error = FALSE)
  login_form <- POST("https://www.nitrc.org/account/login.php", body = C, encode = "form")
  login_page <- content(GET("https://www.nitrc.org/account"),"text")
  if(grepl("My Personal Page",login_page)) {
    jsessionid <- content(GET("https://www.nitrc.org/ir/data/JSESSION", authenticate(C$form_loginname, C$form_pw)))
    options("JSESSIONID" = jsessionid)
    return(TRUE)
  }
  else {
    message("Invalid NITRC credentials!")
    return(FALSE)
  }
}

#' @title Check if user is still logged in
#' @description Figures out if the user session
#' is still active and if not it will call
#' \code{nitrc_login()} to re-establish the session
#' @return State of current user login
#' @importFrom httr content POST
#' @export
check_user_session = function() {
  current_jsessionid = content(POST("https://www.nitrc.org/ir/data/JSESSION"))
  if(options("JSESSIONID") == current_jsessionid) {
    return(TRUE)
  }
  else {
    return(nitrc_login())
  }
}
