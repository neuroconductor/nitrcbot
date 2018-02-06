#' @title Get/list project demographics
#' @description Retrieves list of all subjects
#'  demographic data
#'  @param project is the project fro which
#'  we request demographics data, if \code{project}
#'  is NULL, we return all available subjects
#'
#'  @return Dataframe of demographics data
#'  @export
nitrc_demographics = function(
  project = NULL){

  #get list of all nitrc projects
  nitrc_projects <- list_image_sets()

  if(!is.null(nitrc_projects)){
    if(!is.null(project)){
      if(project %in% nitrc_projects$ID){
        demographics_content <- content(GET(paste0("https://www.nitrc.org/ir/data/subjects?columns=label,gender,handedness,project&project=",project,"&format=json")))
        demographics = NULL
        for(i in 1:length(demographics_content$ResultSet$Result)){
          demographics = rbind(demographics,data.frame(demographics_content$ResultSet$Result[[i]]$ID,demographics_content$ResultSet$Result[[i]]$label,demographics_content$ResultSet$Result[[i]]$project,demographics_content$ResultSet$Result[[i]]$gender,demographics_content$ResultSet$Result[[i]]$handedness),stringsAsFactors = FALSE)
        }
        colnames(demographics) <- c("ID","Label","Project","Gender","Handedness")
        return(demographics)
      }
      else{
        return(message(paste0('Could not find project ',project,' in NITRC')))
      }
    }
    else{
      return(content(GET("https://www.nitrc.org/ir/data/subjects?columns=label,gender,handedness,project&format=json")))
    }
  }
  return(nitrc_projects)
}
