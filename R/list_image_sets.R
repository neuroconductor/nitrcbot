#' @title Get NITRC image sets listing
#' @description Authenticate and retrieve a list
#' of all available datasets
#'
#' @return Dataframe of NITRC projects
#' @importFrom httr content GET
#' @export
#' @examples \dontrun{list_image_sets()}
list_image_sets = function() {
  check_user_session()
  nitrc_sets <- content(GET("https://www.nitrc.org/ir/data/projects"))
  sets = NULL

  for(i in 1:length(nitrc_sets$ResultSet$Result)) {
    subjects = "";
    subjects = paste0("https://www.nitrc.org/ir",nitrc_sets$ResultSet$Result[[i]]$URI,"/subjects")
    subjects = content(GET(subjects))
    subjects = subjects$ResultSet$totalRecords
    sets = rbind(sets,data.frame(nitrc_sets$ResultSet$Result[[i]]$ID,nitrc_sets$ResultSet$Result[[i]]$name,nitrc_sets$ResultSet$Result[[i]]$description,nitrc_sets$ResultSet$Result[[i]]$URI,subjects))
  }
  colnames(sets) <- c("ID","Name","Description","URL","Subjects")
  return(sets)
}
