#' @title Get scan parameters data
#' @description Retrieves all the parameters associated with a session ID
#' @param session_ID the session ID identifier, unique for each individual subject
#' @param scan_type the type of scan for which we need to list the acquisition parameters
#'
#' @return Data frame containing all the data for this particular scan session
#' @export
#' @example \dontrun{get_scan_params('NITRC_IR_E10469')}
get_scan_params = function(
  session_ID = NULL,
  scan_type = NULL){
  scan_params <- content(GET(paste0("https://www.nitrc.org/ir/data/experiments/",session_ID,"/scans?xsiType=xnat:mrScanData&columns=xnat:imageScanData/ID,xnat:mrScanData/parameters/frames,xnat:mrScanData/parameters/te,xnat:mrScanData/parameters/tr,xnat:mrScanData/parameters/flip,xnat:mrScanData/parameters/voxelRes/x,xnat:mrScanData/parameters/voxelRes/y,xnat:mrScanData/parameters/voxelRes/z,xnat:mrScanData/fieldStrength,xnat:mrScanData/parameters/matrix/x,xnat:mrScanData/parameters/matrix/y,xnat:mrScanData/parameters/partitions,xnat:mrScanData/quality&project=kin&format=json")))
  scan_params = bind_rows(lapply(scan_params$ResultSet$Result, as.data.frame, stringsAsFactors = FALSE))
  colnames(scan_params) <- c("TE","matrix_Y","matrix_X","URI","flip","quality","imagescandata_id","frames","voxel_Z","TR","partitions","fieldStrength","ID","voxel_Y","voxel_X")
  scan_params <- scan_params[c("ID","imagescandata_id","TR","TE","flip","matrix_X","matrix_Y","voxel_X","voxel_Y","voxel_Z","frames","partitions","fieldStrength","quality")]
  return(scan_params)
}
