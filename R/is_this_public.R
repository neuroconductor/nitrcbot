#' @title Find out if the provided param is part of public data
#' @description Figure out if the provided \code{subject_ID} or
#' \code{session_ID} belongs to a public project.
#' @param subject_ID the subject ID identifier
#' @param session_ID the session ID identifier, unique for each individual subject
#' @param project the NITRC project for which we try to identify if it's public
#'
#' @return logical value signifying if it's part of a public project
#' @importFrom httr content GET status_code
#' @importFrom jsonlite fromJSON
is_this_public = function(session_ID = NULL,
                          subject_ID = NULL,
                          project = NULL) {

  public_projects = c("studyforrest_rev003", "ixi", "parktdi", "cs_schizbull08", "fcon_1000")
  if(!is.null(project)) {
    if(project %in% public_projects) {
      return(TRUE)
    }
  }
  if(!is.null(subject_ID) || !is.null(session_ID)) {
    url_address = paste0("https://www.nitrc.org/ir/data/subjects/",subject_ID,"?format=json ")
    if(!is.null(session_ID)) {
      url_address = paste0("https://www.nitrc.org/ir/data/experiments/",session_ID,"?format=json ")
    }
    query_content = query_nitrc(url_address)
    if(query_content == FALSE) {return(check_user_session())}

    url_content = fromJSON(query_nitrc(url_address))

    identified_project <- url_content$items$data_fields$project
      if(!is.null(identified_project)) {
        if(identified_project %in% public_projects) {
          return(TRUE)
        }
      }
  }
  return(check_user_session())
}
