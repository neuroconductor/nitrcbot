#' @title Get NITRC image sets listing
#' @description Authenticate and retrieve a list
#' of all available datasets
#' @param project optional, called from other functions
#' in order to figure out if a project is public
#' @param error Should function error if httr::GET failed
#'
#' @return Dataframe of NITRC projects
#' @importFrom httr content GET stop_for_status
#' @export
#' @examples \dontrun{list_image_sets()}
list_image_sets = function(project = NULL,
                           error = FALSE) {
  is_this_public(project = project)
  args = list(
    url = "https://www.nitrc.org/ir/data/projects"
  )
  ret <- do.call("GET", args)

  if (error) {
    stop_for_status(ret)
  }

  nitrc_sets <- content(ret)
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
