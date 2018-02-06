#' @title Get/list scan data
#' @description Retrieves NITRC scan data info
#' @param project is the project for which we request demographics data, if project is NULL, we return all available subjects
#'
#' @return Dataframe of scan data
#' @export
#' @examples \dontrun{nitrc_scandata('ixi')}
nitrc_scandata = function(
  project = NULL){

  #get list of all nitrc projects
  nitrc_projects <- list_image_sets()

  if(!is.null(nitrc_projects)){
    if(!is.null(project)){
      if(project %in% nitrc_projects$ID){
        scan_content <- content(GET(paste0("https://www.nitrc.org/ir/data/experiments?columns=xnat:mrSessionData/ID,label,,xnat:imageScanData/type,xnat:imageScanData/ID,ID,label,subject_ID,,subject_label,xnat:mrScanData/parameters/frames,xnat:mrScanData/parameters/te,xnat:mrScanData/parameters/tr&project=",project,"&format=json")))
        return(scan_content)
      }
      else{
        return(message(paste0('Could not find project ',project,' in NITRC')))
      }
    }
    else{
      return(message("coming soon..."))
    }
  }
  else{
    return(nitrc_projects)
  }
}
