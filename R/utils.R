.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("toDF", function(data, ...) {
    jsonlite::fromJSON(toJSON(data))
  }, force = TRUE)
}
