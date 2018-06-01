#' @title Read NITRC project data
#' @description Reads in all data associated with a project (demographics and scan data)
#' @param project is the project for which
#'  we request the aggregated data, if project
#'  is NULL, we return all available data for all projects
#' @param jsessionID value for the JSESSIONID cookie
#'
#' @return Dataframe of project data
#' @importFrom dplyr bind_rows
#' @importFrom httr content GET
#' @export
#' @examples
#' ## Read all data for the ixi project
#' \dontrun{ixi_data <- read_nitrc_project('ixi')}
#'
#' ## Read data for all available projects
#' \dontrun{nitrc_data <- read_nitrc_project()}
read_nitrc_project = function(project = NULL,
                              jsessionID = NULL) {
  nitrc_projects <- list_image_sets(project)
  if(!is.null(project)) {
    if(project %in% nitrc_projects$ID) {
      d <- nitrc_demographics(project, jsessionID = jsessionID)
      s <- nitrc_scandata(project, jsessionID = jsessionID)
    }
    else {
      return(message(paste0('Could not find project ',project,' in NITRC')))
    }
  }
  else {
    d <- nitrc_demographics(jsessionID = jsessionID)
    s <- nitrc_scandata(jsessionID = jsessionID)
  }
  project_data = NULL
  if(!is.null(d) && !is.null(s)){
    project_data <- merge(d,s,by="ID")
    project_data$age <- paste0(project_data$age.x,project_data$age.y)
    project_data <- project_data[c("ID","label","project","gender","handedness","session_ID","scan_ID","age")]
    return(project_data)
  }
  else {
    message("No results found")
    return(NULL)
  }
}
