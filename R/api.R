# Helper function
callJS <- function() {
  message <- Filter(function(x) !is.symbol(x), as.list(parent.frame(1)))
  session <- shiny::getDefaultReactiveDomain()
  method <- paste0("tableau:", message$method)
  session$sendCustomMessage(method, message)
  return(message$id)
}

#' Apply a categorical filter to a Tableau view
#'
#' Makes an asynchronous call to apply a categorical filter to the current Tableau view. Date filters should
#' only be applied using \code{\link{tableauRangeFilter}}. If the current view is a dashboard, all worksheets
#' within the dashboard will be filtered. This function works similarly to \code{\link{tableauSelect}}.
#'
#' @section Filter types:
#'
#' The Tableau API supports four filter types:
#'
#' \describe{
#'   \item{\code{ALL}}{Adds all values to the filter. Equivalent to checking the (All) value in a quick filter.}
#'
#'   \item{\code{REPLACE}}{Replaces the current filter values with new ones specified in the call.}
#'
#'   \item{\code{ADD}}{Adds the filter values as specified in the call to the current filter values.
#'   Equivalent to checking a value in a quick filter.}
#'
#'   \item{\code{REMOVE}}{Removes the filter values as specified in the call from the current filter values.
#'   Equivalent to unchecking a value in a quick filter.}
#' }
#'
#' @param id the Tableau object id
#' @param field the field to filter on
#' @param value the value or array of values to filter for
#' @param type how the criteria should be applied
#' @param exclude a logical value (\code{TRUE} or \code{FALSE}).  If \code{TRUE}
#' the filter will be applied in exclude mode.
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauFilter <- function(id, field, value, type = 'REPLACE', exclude = FALSE) {
  method <- "filter"
  callJS()
}

#' Apply a range filter to a Tableau view
#'
#' Makes an asynchronous call to apply a range filter to the current Tableau view. Date filters can be applied
#' using either an integer timestamp or a date value. Categorical filters should be applied using
#' \code{\link{tableauFilter}}. If the current view is a dashboard, all worksheets within the dashboard will
#' be filtered. If field is already available in worksheets then the Null Controls must be set to either
#' \code{Values in Range} or \code{Values in Range and Null Values}. This can be done in the customize
#' dropdown of the quick filter.
#'
#' @param id the Tableau object id
#' @param field the field to filter on
#' @param min an int or date. Minimum value for the range (inclusive). Leave blank if you want a <= filter.
#' @param max an int or date. Maximum value for the range (inclusive). Leave blank if you want a >= filter.
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauRangeFilter <- function(id, field, min = NULL, max = NULL) {
  method <- "rangeFilter"
  callJS()
}

#' Select data in a Tableau worksheet
#'
#' Makes an asynchronous call to select data in the current Tableau view. Multiple worksheetes can not be
#' selected at the same time. If the current view is a dashboard, the \code{worksheet} argument should be
#' specified, otherwise the first one alphabetically will be selected. The field must already be available in
#' the worksheet for this to be applied. This function works similarly to \code{\link{tableauFilter}}.
#'
#' @section Selection types:
#'
#' The Tableau API supports three selection types:
#'
#' \describe{
#'   \item{\code{REPLACE}}{Replaces the current marks values with new ones specified in the call.}
#'
#'   \item{\code{ADD}}{Adds the values as specified in the call to the current selection.
#'   Equivalent to control-clicking in desktop.}
#'
#'   \item{\code{REMOVE}}{Removes the values as specified in the call from the current selection.
#'   Equivalent to control-clicking an already selected mark in desktop.}
#' }
#'
#' @param id the Tableau object id
#' @param field the field to filter on
#' @param value the value or array of values to filter for
#' @param worksheet the name of the worksheet to apply the selection to
#' @param type how the criteria should be applied
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauSelect <- function(id, field, value, worksheet = NULL, type = 'REPLACE') {
  method <- "select"
  callJS()
}

#' Change a parameter in a Tableau workbook
#'
#' Makes an asynchronous call to change a parameter across the entire Tableau workbook.
#' The value should be the same data type as the parameter and within the allowable range of
#' values. It also needs to be the aliased value and not the raw value.
#'
#' @param id the Tableau object id
#' @param parameter the name of the parameter to change
#' @param value the new value for the parameter
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauChangeParameter <- function(id, parameter, value) {
  method <- "changeParameter"
  callJS()
}

#' Change the active sheet in a Tableau workbook
#'
#' Makes an asynchronous call to switch to a different sheet in the Tableau workbook.
#'
#' @param id the Tableau object id
#' @param worksheet the name or index of worksheet to switch to
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauChangeSheet <- function(id, worksheet) {
  method <- "changeSheet"
  callJS()
}

#' Revert a Tableau workbook to the original settings
#'
#' @param id the Tableau object id
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauRevert <- function(id) {
  method <- "revert"
  callJS()
}

#' Refresh the underlying data for a Tableau workbook
#' @param id the Tableau object id
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauRefresh <- function(id) {
  method <- "refresh"
  callJS()
}

#' Export a PNG
#' @param id the Tableau object id
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauExportPNG <- function(id) {
  method <- "png"
  callJS()
}

#' Export a PDF
#' @param id the Tableau object id
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauExportPDF <- function(id) {
  method <- "pdf"
  callJS()
}

#' Export Raw Data
#' @param id the Tableau object id
#' @param worksheet the worksheet to download data from, uses the active sheet if \code{NULL}
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauExportData <- function(id, worksheet = NULL) {
  method <- "data"
  callJS()
}

#' Export Crosstab
#' @param id the Tableau object id
#' @param worksheet the worksheet to download data from, uses the active sheet if \code{NULL}
#'
#' @return The Tableau object id is returned for use in \%>\% chains
#'
#' @export
tableauExportCrossTab <- function(id, worksheet = NULL) {
  method <- "crosstab"
  callJS()
}
