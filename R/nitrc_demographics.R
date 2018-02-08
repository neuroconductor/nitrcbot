#' @title Get/list project demographics
#' @description Retrieves list of all subjects demographic data
#' @param project is the project for which
#'  we request demographics data, if project
#'  is NULL, we return all available subjects
#'
#' @importFrom dplyr bind_rows
#' @return Dataframe of demographics data
#' @export
#' @examples \dontrun{nitrc_demographics('ixi')}
nitrc_demographics = function(
  project = NULL){

  #get list of all nitrc projects
  nitrc_projects <- list_image_sets()

  if(!is.null(nitrc_projects)){
    if(!is.null(project)){
      demographics_content = NULL
      if(project %in% nitrc_projects$ID){
        #get age as it looks like it's kept here for some projects and in xnat:mrSessionData/age for others
        demographics_content = content(GET(paste0("https://www.nitrc.org/ir/data/subjects?columns=label,gender,handedness,project,age&project=",project,"&format=json")))
      }
      else{
        return(message(paste0('Could not find project ',project,' in NITRC')))
      }
    }
    else{
      demographics_content = content(GET("https://www.nitrc.org/ir/data/subjects?columns=label,gender,handedness,project&format=json"))
    }
    demographics = bind_rows(lapply(demographics_content$ResultSet$Result, as.data.frame, stringsAsFactors = FALSE))
    demographics = demographics[c("ID","label","project","gender","handedness","age")]
    return(demographics)
  }
  return(nitrc_projects)
}
