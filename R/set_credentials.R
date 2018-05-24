#' @title Set NITRC credentials.
#' @description Sets and returns the NITRC credentials. Should error
#' if it cannot find the environment variables or they are not provided.
#' @param username is the NITRC login user name. If \code{NULL} this will
#' should be provided through the \code{NITRC_WEB_USER} system variable.
#' @param password is the NITRC login user password If \code{NULL} this will
#' should be provided through the \code{NITRC_WEB_PASS} system variable.
#' @param error Should this function error if variables are not specifed?
#'
#' @examples \dontrun{set_credentials(username = "user", password = "pass")}
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
#' @importFrom RCurl parseHTTPHeader
#' @export
nitrc_login = function() {
  C = set_credentials(error = FALSE)
  reader <- basicTextGatherer()
  header <- basicTextGatherer()
  curlPerform(url = paste('https://nitrc.org/ir', '/data/JSESSION', sep = ''),
              writefunction = reader$update,
              headerfunction = header$update,
              ssl.verifypeer = FALSE,
              userpwd = paste(C$form_loginname, C$form_pw, sep = ':'),
              httpauth=1L)
  status = parseHTTPHeader(header$value())['status']
  if(status == 401) {
    message('bad username/password')
    options("JSESSIONID" = "")
    return(FALSE)
  } else if(status != 200) {
    message('error authenticating')
    options("JSESSIONID" = "")
    return(FALSE)
  }
  options("JSESSIONID" = reader$value())
  return(TRUE)
}

#' @title Check if user is still logged in
#' @description Figures out if the user session
#' is still active and if not it will call
#' \code{nitrc_login()} to re-establish the session
#' @return State of current user login
#' @importFrom httr content POST
#' @export
check_user_session = function() {
  current_jsessionid = query_nitrc('https://www.nitrc.org/ir/data/JSESSION')
  if(options("JSESSIONID") == current_jsessionid) {
    return(TRUE)
  }
  else {
    return(nitrc_login())
  }
}

#' @title Perform RCurl operations
#' @description Queries NITRC website using RCurl functions
#' @importFrom RCurl basicTextGatherer curlPerform
#' @param url is the URL for the RCurl request parseHTTPHeader
#' @param jsessionID value for the JSESSIONID cookie
query_nitrc = function(url, jsessionID = NULL) {
  if(is.null(jsessionID)) {
    jsessionID = options("JSESSIONID")
  }
  reader <- basicTextGatherer()
  header <- basicTextGatherer()
  curlPerform(url = paste(url, 'GET', sep = ''),
              writefunction = reader$update,
              headerfunction = header$update,
              ssl.verifypeer = FALSE,
              cookie = paste('JSESSIONID=', jsessionID, sep = ''))
  if(parseHTTPHeader(header$value())['status'] != 200) {
    return(FALSE)
  }
  return(reader$value())
}
