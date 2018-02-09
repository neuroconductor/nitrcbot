#' @title Download image(s)
#' @description Download entire session or just the files from a particular
#' scan type. If \code{scan_type} is NULL the function will download a zipped
#' file containing the entire resource folder for that particular \code{subject_ID}
#' or \code{session_ID}. If \code{scan_type} is specified than depending on the
#' \code{zipped} the downloaded files will be zipped or not.
#' @param subject_ID Download scan images for this particular subject ID
#' @param session_ID Downoad scan images for this particular session ID
#' @param scan_type Download scan images just for this particular type of scan
#' @param zipped Zip the downloaded files
#'
#' @return List of downloaded file(s) with full paths
download_nitrc_dir = function(subject_ID,
                              session_ID = NULL,
                              scan_type = NULL,
                              zipped = FALSE) {


}

