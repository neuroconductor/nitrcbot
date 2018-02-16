#' @title Download whole image drectory
#' @description Download entire session or just the files from a particular
#' scan type. If \code{scan_type} is NULL the function will download a zipped
#' file containing the entire resource folder for that particular \code{subject_ID}
#' or \code{session_ID}. If \code{scan_type} is specified than depending on the
#' \code{zipped} the downloaded files will be zipped or not.
#' @param subject_ID Download scan images for this particular subject ID
#' @param project The project dataset to whom \code{subject_ID} belongs to.
#' This is required if subject_ID is specified
#' @param session_ID Downoad scan images for this particular session ID
#' @param scan_type Download scan images just for this particular type of scan
#' @param zipped Zip the downloaded files
#' @param verbose Should progress be added to download?
#' @param error Should function error if download failed?
#'
#' @return List of downloaded file(s) with full paths
#' @importFrom httr stop_for_status write_disk progress GET
#' @export
download_nitrc_dir = function(session_ID = NULL,
                              subject_ID = NULL,
                              project = NULL,
                              scan_type = NULL,
                              zipped = FALSE,
                              verbose = FALSE,
                              error = FALSE) {

  subject_session_ID <- NULL
  if(!is.null(subject_ID)) {
    if(!is.null(project)) {
      nitrc_projects <- list_image_sets(project)
      if(project %in% nitrc_projects$ID){
        all_project_data <- read_nitrc_project(project)
        subject_session_ID <- unique(all_project_data[all_project_data$ID == subject_ID,]$session_ID)
      }
      else {
        message('Invalid project_ID.')
        return(NULL)
      }
    }
    else {
      message('If subject_ID is specified, project_ID cannot be missing.')
      return(NULL)
    }
  }
  if(!is.null(subject_session_ID) && !is.null(session_ID)) {
    if(subject_session_ID != session_ID) {
      message('Provided session_ID does not match the provided subject_ID session_ID.')
      return(NULL)
    }
  }
  if(is.null(session_ID)) {
    session_ID <- subject_session_ID
  }
  scan_params <- get_scan_params(session_ID, scan_type)
  if(is.null(scan_params)) {
    return(message('No images found for the provided parameters'))
  }
  if(zipped) {
    url_address <- paste0("https://www.nitrc.org/ir/data/experiments/",session_ID,"/scans/")
    if(is.null(scan_type)) {
      url_address <- paste0(url_address,"ALL")
    }
    else {
      url_address <- paste0(url_address,scan_type)
    }
    url_address <- paste0(url_address,"/files?format=zip")
    destfile = file.path(tempdir(),paste0(session_ID,".zip"))
    args = list(
      url = url_address,
      write_disk(path = destfile,
                 overwrite = TRUE)
    )
    if (verbose) {
      args = c(args, list(progress()))
    }
    ret <- do.call("GET", args)

    if (error) {
      stop_for_status(ret)
    }
    return(destfile)
  }
  else {
    scan_resources <- get_scan_resources(session_ID,scan_type)
    mapply(function(file, prefix) {
      if(verbose) {
        message(paste0("Downloading ",basename(file)))
      }
      download_nitrc_file(file_path = file, prefix = prefix)
    }, scan_resources[, "URI"], scan_resources[, "cat_ID"])
    file_list <- list(outdir = tempdir(),
        files = paste0(scan_resources[, "cat_ID"],"_",basename(scan_resources[, "URI"])))
    return(file_list)

  }

}

