#' @title Find out if the provided param is part of public data
#' @description Figure out if the provided \code{subject_ID} or
#' \code{session_ID} belongs to a public project.
#' @param subject_ID the subject ID identifier
#' @param session_ID the session ID identifier, unique for each individual subject
#'
#' @return logical value signifying if it's part of a public project
#' @importFrom httr content GET
is_this_public = function(session_ID,
                          subject_ID = NULL) {

}
