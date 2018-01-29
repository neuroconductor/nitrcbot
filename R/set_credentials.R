#' @title Set NITRC credentials
#' @description Sets and returns the NITRC credentials. Should error
#' if it cannot find the environment variables
#'
set_credentials = function(
  username = NULL,
  password = NULL,
  error = TRUE) {

  if(is.null(username)) {
    username = Sys.getenv("NITRC_USER")

  }
}
