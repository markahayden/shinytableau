# shinytableau
This package uses [htmlwidgets](http://www.htmlwidgets.org/) to connect R to the [Tableau Javascript API](https://onlinehelp.tableau.com/current/api/js_api/en-us/JavaScriptAPI/js_api_ref.htm). The Tableau Javascript functionalities are primarily useful for embedding views into Shiny apps 

## Filtering

Filtering is supported by two methods. The filter doesn't need to be in the view in order to be applied. Either individual values or lists of values can be passed in.

`tableauFilter()`: filtering by a categorical variable 

`tableauRangeFilter()`: filtering for a range or date 

## Selecting

Selecting works similarly to filtering.

`tableauSelect()` 

## Changing Parameters

Parameter values can be changed to anything within the allowable range of values.

`tableauChangeParameter()` 

## Workbook level actions

A variety of workbook actions can also be triggered by the API. The export actions will generate a dialog box where the user can specify download options. 

`tableauChangeSheet()` : The sheet can be changed to any published worksheets or dashboards within the workbook (these are the tab names). 

`tableauRevert()` : Revert a Tableau workbook to the original settings. 

`tableauRefresh()` : Refresh the underlying data for a Tableau workbook. 

`tableauExportPNG()` 

`tableauExportPDF()` 

`tableauExportData()` 

`tableauExportCrossTab()` 

## Listening for events

shinytableau listens for user interactions and triggers changes to shiny inputs. Programmatically changing values will also trigger these events. Three different variables are available and can be referenced or used in reactive functions.  If the tableau object is named `myviz` in shiny, these variables will be available:

`input$myviz_parameters`: a data.frame containing the parameters available in the workbook and their current raw and formatted values

`input$myviz_selectedMarks`: a data.frame containing the marks currently selected in view. Each row represents a point and the columns describe the fields that identify that point

`input$myviz_worksheet`: a string containing the name of the current active worksheet 
