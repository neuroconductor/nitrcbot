#' @title Get scan resources
#' @description Retrieves all the resources(files) associated with a session ID
#' @param session_ID the session ID identifier, unique for each individual subject
#' @param scan_type the type of scan for which we need to list the acquisition parameters
#' @param project optional, identifies the project to which the session_ID belongs
#' @param jsessionID value for the JSESSIONID cookie
#'
#' @return Data frame containing all the resources for this particular scan session
#' @importFrom dplyr bind_rows
#' @importFrom httr content GET
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' ## Get all scan resources for a specific session_ID
#' \dontrun{get_scan_resources('NITRC_IR_E10469')}
get_scan_resources = function(session_ID = NULL,
                              scan_type = NULL,
                              project = NULL,
                              jsessionID = NULL
                              ) {
  scan_resources <- NULL
  if(is_this_public(session_ID = session_ID, project = project) && !is.null(session_ID)) {
    if(!is.null(scan_type)) {
      scan_params <- get_scan_params(session_ID,scan_type)
      if(!is.null(scan_params)) {
        url = paste0("https://www.nitrc.org/ir/data/experiments/",session_ID,"/scans/",scan_type,"/files ")
        scan_resources = fromJSON(query_nitrc(url,jsessionID))
      }
      else {
        message("Invalid scan type")
        return(NULL)
      }
    }
    else {
      url = paste0("https://www.nitrc.org/ir/data/experiments/",session_ID,"/scans/ALL/files ")
      scan_resources = fromJSON(query_nitrc(url,jsessionID))
    }
    scan_resources = scan_resources$ResultSet$Result

    if(length(scan_resources)>0) {
        return(scan_resources)
    }
  }
  return(NULL)
}
