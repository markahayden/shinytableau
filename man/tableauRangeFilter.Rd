% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{tableauRangeFilter}
\alias{tableauRangeFilter}
\title{Apply a range filter to a Tableau view}
\usage{
tableauRangeFilter(id, field, min = NULL, max = NULL)
}
\arguments{
\item{id}{the Tableau object id}

\item{field}{the field to filter on}

\item{min}{an int or date. Minimum value for the range (inclusive). Leave blank if you want a <= filter.}

\item{max}{an int or date. Maximum value for the range (inclusive). Leave blank if you want a >= filter.}
}
\value{
The Tableau object id is returned for use in \%>\% chains
}
\description{
Makes an asynchronous call to apply a range filter to the current Tableau view. Date filters can be applied
using either an integer timestamp or a date value. Categorical filters should be applied using
\code{\link{tableauFilter}}. If the current view is a dashboard, all worksheets within the dashboard will
be filtered. If field is already available in worksheets then the Null Controls must be set to either
\code{Values in Range} or \code{Values in Range and Null Values}. This can be done in the customize
dropdown of the quick filter.
}

