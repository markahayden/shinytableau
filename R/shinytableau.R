#' shinytableau: htmlwidget for the Tableau Javascript API
#'
#' shinytableau allows you to embed interactive Tableau workbooks into R
#' using the \href{http://www.htmlwidgets.org/}{htmlwidgets} package
#' and the \href{https://onlinehelp.tableau.com/current/api/js_api/en-us/JavaScriptAPI/js_api_ref.htm}{Tableau Javascript API}.
#' Parameter values can be modified and views can be filtered, selected,
#' and exported. The ability to run R code after actions are taken within
#' Tableau, such as selecting points or changing parameter values is
#' enabled through event listeners.
#'
#' @section Accessing Tableau data in Shiny:
#'
#' Some Tableau data is available as Shiny inputs after the initial view has finished
#' loading. These inputs can be wrapped in reactive functions for triggering R code
#' after user interactions with the Tableau view such as changing parameters,
#' selecting data, or switching tabs. These inputs are prefixed with the
#' \code{outputId} of the embedded Tableau object. For example, if the
#' \code{outputId} is \code{myviz}, then these three input variables will be generated:
#'
#' \describe{
#'   \item{\code{input$myviz_parameters}}{returns a data.frame containing
#'   the parameters available in the workbook and their current values.  Both the
#'   raw values and formatted values are available, although parameters can only
#'   be changed via \code{\link{tableauChangeParameter}} using the formatted values.
#'   Calls to \code{\link{tableauChangeParameter}} also trigger changes to this input.}
#'
#'   \item{\code{input$myviz_selectedMarks}}{returns a data.frame containing
#'   the marks currently selected in view. Each row represents a point and
#'   the columns describe the fields that identify that point. Calls to
#'   \code{\link{tableauSelect}} also trigger changes to this input.}
#'
#'   \item{\code{input$myviz_worksheet}}{returns a string containing the
#'   name of the current active worksheet. Calls to
#'   \code{\link{tableauChangeSheet}} also trigger changes to this input.}
#' }
#'
#' @param url the URL of the tableau view to embed
#' @param hideTabs a logical value (\code{TRUE} or \code{FALSE}).  If \code{TRUE}
#' tabs will not be displayed.
#' @param hideToolbar a logical value (\code{TRUE} or \code{FALSE}).  If \code{TRUE}
#' the toolbar will not be display.
#' @param width width of the embedded view (in css units)
#' @param height height of the embedded view (in css units)
#' @param elementId an explicit element ID. Ignored for Shiny apps
#'
#' @import htmlwidgets
#' @import shiny
#' @importFrom jsonlite fromJSON toJSON
#'
#' @export
shinytableau <- function(url, hideTabs = TRUE, hideToolbar = TRUE, width = NULL, height = NULL, elementId = NULL) {

  # forward options
  opts = list(
    url = url,
    hideTabs = hideTabs,
    hideToolbar = hideToolbar
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'shinyTableau',
    x = opts,
    width = width,
    height = height,
    package = 'shinytableau',
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      viewer.padding = 0,
      browser.padding = 0,
      browser.fill = TRUE
    )
  )
}

#' Shiny bindings for shinytableau
#'
#' Output and render functions for using shinytableau within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a shinytableau
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name shinytableau-shiny
#'
#' @export
shinytableauOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'shinytableau', width, height, package = 'shinytableau')
}

#' @rdname shinytableau-shiny
#' @export
renderShinytableau <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, shinytableauOutput, env, quoted = TRUE)
}
