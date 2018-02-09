#' @title Read NITRC project data
#' @description Reads in all data associated with a project (demographics and scan data)
#' @param project is the project for which
#'  we request the aggregated data, if project
#'  is NULL, we return all available data for all projects
#'
#' @return Dataframe of project data
#' @importFrom dplyr bind_rows
#' @importFrom httr content GET
#' @export
#' @examples \dontrun{read_nitrc_project('ixi')}
read_nitrc_project = function(project = NULL) {
  nitrc_projects <- list_image_sets()
  if(!is.null(nitrc_projects)) {
    if(!is.null(project)) {
      project_data = NULL
      if(project %in% nitrc_projects$ID) {
        d <- nitrc_demographics(project)
        s <- nitrc_scandata(project)
        project_data <- merge(d,s,by="ID")
      }
      else {
        return(message(paste0('Could not find project ',project,' in NITRC')))
      }
    }
    else {
      d <- nitrc_demographics()
      s <- nitrc_scandata()
      project_data <- merge(d,s,by="ID")
    }
    project_data$age <- paste0(project_data$age.x,project_data$age.y)
    project_data <- project_data[c("ID","label","project","gender","handedness","session_ID","scan_ID","age")]
    return(project_data)
  }
  else {
    return(NULL)
  }
}
