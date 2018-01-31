#' @title Get NITRC image sets listing
#' @description Authenticate and retrieve a list
#' of all available datasets
#'
#' @return Dataframe of \code{nitrc_sets}
#' @export
list_image_sets = function(){
  return(content(GET("https://www.nitrc.org/ir/data/projects")))
}
