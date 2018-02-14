#' @title Get/list scan data
#' @description Retrieves NITRC scan data info
#' @param project is the project for which we request demographics data, if project is NULL, we return all available subjects
#'
#' @return Dataframe of scan data
#' @importFrom httr content GET
#' @importFrom dplyr bind_rows
#' @export
#' @examples \dontrun{nitrc_scandata('ixi')}
nitrc_scandata = function(project = NULL) {

  #get list of all nitrc projects
  nitrc_projects <- list_image_sets()

  if(!is.null(nitrc_projects)) {
    if(!is.null(project)) {
      scan_content = NULL
      if(project %in% nitrc_projects$ID){
        scan_content <- content(GET(paste0("https://www.nitrc.org/ir/data/experiments?columns=xnat:mrSessionData/ID,xnat:imageScanData/type,xnat:imageScanData/ID,subject_ID,xnat:mrSessionData/age&project=",project,"&format=json")))
      }
      else {
        message(paste0('Could not find project ',project,' in NITRC'))
        return(NULL)
      }
    }
    else {
      message('Aquiring scan data for all projects')
      scan_content <- content(GET(paste0("https://www.nitrc.org/ir/data/experiments?columns=xnat:mrSessionData/ID,xnat:imageScanData/type,xnat:imageScanData/ID,subject_ID,xnat:mrSessionData/age&format=json")))
    }
    if(scan_content$ResultSet$totalRecords > 0) {
      scandata = bind_rows(lapply(scan_content$ResultSet$Result, as.data.frame, stringsAsFactors = FALSE))
      colnames(scandata) <- c("ID","type","session_ID","age","scan_ID","URI")
      scandata = scandata[c("ID","type","session_ID","age","scan_ID")]
      return(scandata)
    }
    else {
      message("No scan data results found")
      return(NULL)
    }
  }
  else {
    return(NULL)
  }
}
