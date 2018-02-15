#' @title Get scan resources
#' @description Retrieves all the resources(files) associated with a session ID
#' @param session_ID the session ID identifier, unique for each individual subject
#' @param scan_type the type of scan for which we need to list the acquisition parameters
#' @param project optional, identifies the project to which the session_ID belongs
#'
#' @return Data frame containing all the resources for this particular scan session
#' @importFrom dplyr bind_rows
#' @importFrom httr content GET
#' @export
#' @examples \dontrun{get_scan_resources('NITRC_IR_E10469')}
get_scan_resources = function(session_ID = NULL,
                              scan_type = NULL,
                              project = NULL
                              ) {
  if(is_this_public(session_ID = session_ID, project = project) && !is.null(session_ID)) {
    if(!is.null(scan_type)) {
      scan_params <- get_scan_params(session_ID,scan_type)
      if(!is.null(scan_params)) {
        scan_resources = content(GET(paste0("https://www.nitrc.org/ir/data/experiments/",session_ID,"/scans/",scan_type,"/files?format=json")))
      }
      else {
        message("Invalid scan type")
        return(NULL)
      }
    }
    else {
      scan_resources = content(GET(paste0("https://www.nitrc.org/ir/data/experiments/",session_ID,"/scans/ALL/files?format=json")))
    }
    scan_resources = bind_rows(lapply(scan_resources$ResultSet$Result, as.data.frame, stringsAsFactors = FALSE))
    if(nrow(scan_resources)>0) {
      return(scan_resources)
    }
  }
  return(NULL)
}
