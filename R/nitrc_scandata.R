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
      scan_content = NULL
      if(project %in% nitrc_projects$ID){
        scan_content <- content(GET(paste0("https://www.nitrc.org/ir/data/experiments?columns=xnat:mrSessionData/ID,label,,xnat:imageScanData/type,xnat:imageScanData/ID,ID,label,subject_ID,,subject_label,xnat:mrScanData/parameters/frames,xnat:mrScanData/parameters/te,xnat:mrScanData/parameters/tr,xnat:mrScanData/parameters/flip,xnat:mrScanData/parameters/voxelRes/x,xnat:mrScanData/parameters/voxelRes/y,xnat:mrScanData/parameters/voxelRes/z,xnat:mrScanData/fieldStrength,xnat:mrScanData/parameters/matrix/x,xnat:mrScanData/parameters/matrix/y,xnat:mrScanData/parameters/partitions,xnat:mrScanData/quality,xnat:mrSessionData/age&project=",project,"&format=json")))
      }
      else{
        return(message(paste0('Could not find project ',project,' in NITRC')))
      }
    }
    else{
      scan_content <- content(GET(paste0("https://www.nitrc.org/ir/data/experiments?columns=xnat:mrSessionData/ID,label,,xnat:imageScanData/type,xnat:imageScanData/ID,ID,label,subject_ID,,subject_label,xnat:mrScanData/parameters/frames,xnat:mrScanData/parameters/te,xnat:mrScanData/parameters/tr,xnat:mrScanData/parameters/flip,xnat:mrScanData/parameters/voxelRes/x,xnat:mrScanData/parameters/voxelRes/y,xnat:mrScanData/parameters/voxelRes/z,xnat:mrScanData/fieldStrength,xnat:mrScanData/parameters/matrix/x,xnat:mrScanData/parameters/matrix/y,xnat:mrScanData/parameters/partitions,xnat:mrScanData/quality,xnat:mrSessionData/age&format=json")))
    }
    scandata = bind_rows(lapply(scan_content$ResultSet$Result, as.data.frame, stringsAsFactors = FALSE))
    return(scandata)
  }
  else{
    return(nitrc_projects)
  }
}
