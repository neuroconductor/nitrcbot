% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nitrc_scandata.R
\name{nitrc_scandata}
\alias{nitrc_scandata}
\title{Get/list scan data}
\usage{
nitrc_scandata(project = NULL, nitrc_projects = NULL, jsessionID = NULL)
}
\arguments{
\item{project}{is the project for which we request demographics data, if project is NULL, we return all available subjects}

\item{nitrc_projects}{data.frame with all available NITRC projects}

\item{jsessionID}{value for the JSESSIONID cookie}
}
\value{
Dataframe of scan data
}
\description{
Retrieves NITRC scan data info
}
\examples{
## Get scan data for the ixi project
\dontrun{nitrc_scandata('ixi')}

## Get scan data for all accessible NITRC projects
\dontrun{nitrc_scandata()}
}
