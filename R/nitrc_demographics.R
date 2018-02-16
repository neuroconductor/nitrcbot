#' @title Get/list project demographics
#' @description Retrieves list of all subjects demographic data
#' @param project is the project for which
#'  we request demographics data, if project
#'  is NULL, we return all available subjects
#' @param nitrc_projects data.frame with all available NITRC projects
#'
#' @return Dataframe of demographics data
#' @importFrom dplyr bind_rows
#' @importFrom httr content GET
#' @export
#' @examples \dontrun{nitrc_demographics('ixi')}
nitrc_demographics = function(project = NULL, nitrc_projects = NULL) {

  if(is.null(nitrc_projects)) {
    nitrc_projects <- list_image_sets(project)
  }

  if(!is.null(project)){
    demographics_content = NULL
    if(project %in% nitrc_projects$ID) {
      #get age as it looks like it's kept here for some projects and in xnat:mrSessionData/age for others
      demographics_content = content(GET(paste0("https://www.nitrc.org/ir/data/subjects?columns=label,gender,handedness,project,age&project=",project,"&format=json")))
    }
    else {
      message(paste0('Could not find project ',project,' in NITRC'))
      return(NULL)
    }
  }
  else {
    demographics_content = content(GET("https://www.nitrc.org/ir/data/subjects?columns=label,gender,handedness,project,age&format=json"))
  }
  if(demographics_content$ResultSet$totalRecords > 0) {
    demographics = bind_rows(lapply(demographics_content$ResultSet$Result, as.data.frame, stringsAsFactors = FALSE))
    demographics = demographics[c("ID","label","project","gender","handedness","age")]
    return(demographics)
  }
  else {
    message("No demographics results found")
    return(NULL)
  }
}
