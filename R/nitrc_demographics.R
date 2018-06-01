#' @title Get/list project demographics
#' @description Retrieves list of all subjects demographic data
#' @param project is the project for which
#'  we request demographics data, if project
#'  is NULL, we return all available subjects
#' @param nitrc_projects data.frame with all available NITRC projects
#' @param jsessionID value for the JSESSIONID cookie
#'
#' @return Dataframe of demographics data
#' @importFrom dplyr bind_rows
#' @importFrom httr content GET
#' @importFrom jsonlite fromJSON
#' @examples
#' ## Get demographic data for the ixi project
#' \dontrun{nitrc_demographics('ixi')}
#'
#' ## Get demographic data for all accessible projects
#' \dontrun{nitrc_demographics()}
#' @export
nitrc_demographics = function(project = NULL,
                              nitrc_projects = NULL,
                              jsessionID = NULL) {

  if(is.null(nitrc_projects)) {
    nitrc_projects <- list_image_sets(project)
  }

  if(!is.null(project)){
    demographics_content = NULL
    if(project %in% nitrc_projects$ID) {
      #get age as it looks like it's kept here for some projects and in xnat:mrSessionData/age for others
      url = paste0("https://www.nitrc.org/ir/data/subjects?project=",project,"&columns=label,gender,handedness,project,age ")
      demographics_content = fromJSON(query_nitrc(url,jsessionID))
    }
    else {
      message(paste0('Could not find project ',project,' in NITRC'))
      return(NULL)
    }
  }
  else {
    url = paste0("https://www.nitrc.org/ir/data/subjects?columns=label,gender,handedness,project,age ")
    demographics_content = fromJSON(query_nitrc(url,jsessionID))
    }
  if(demographics_content$ResultSet$totalRecords > 0) {
    demographics = demographics_content$ResultSet$Result[c("ID","label","project","gender","handedness","age")]
    return(demographics)
  }
  else {
    message("No demographics results found")
    return(NULL)
  }
}
