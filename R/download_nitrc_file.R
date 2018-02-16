#' @title Download NITRC file
#' @description Download a single file from NITRC
#' @param file_path Path to the file to be dowloaded
#' @param destfile Destination filename
#' @param prefix Prefix the file name with this (prevents
#' overwritting of same name files in case function is
#' used to download multiple scan types at once)
#' @param verbose Should progress be added to download?
#' @param error Should function error if download failed?
#'
#' @return Display path to the downloaded file
#' @importFrom httr stop_for_status write_disk progress GET
#' @export
download_nitrc_file = function(file_path,
                               destfile = NULL,
                               prefix = NULL,
                               verbose = FALSE,
                               error = FALSE
                               ) {
  if (is.null(destfile)) {
      if(!is.null(prefix)) {
        prefix <- paste0(prefix,"_")
      }
      destfile = file.path(tempdir(),paste0(prefix,basename(file_path)))
  }
  args = list(
    url = paste0("https://www.nitrc.org/ir",file_path),
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
  if(ret$status_code == "200") {
    return(destfile)
  }
  else {
    message("File not found")
    return(NULL)
  }
}
