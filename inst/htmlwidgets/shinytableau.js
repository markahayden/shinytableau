HTMLWidgets.widget({

  name: 'shinytableau',

  type: 'output',

  factory: function(el, width, height) {

    var elementId = el.id;
    var container = document.getElementById(elementId);
    var viz;
    var loaded = false;

    return {

      renderValue: function(opts) {
        document.getElementById(elementId).widget = this;
        var url = opts.url;
        var options = {
          width: width,
          height: height,
          hideTabs: opts.hideTabs,
          hideToolbar: opts.hideToolbar,
          onFirstInteractive: function () {
            loaded = true;
            workbook = viz.getWorkbook();
            activeSheet = workbook.getActiveSheet();

            if (HTMLWidgets.shinyMode) {

              Shiny.onInputChange(
                    elementId + "_loaded",
                    loaded
              );
              // listener for selection events
              viz.addEventListener(tableau.TableauEventName.MARKS_SELECTION, function(marksEvent) {
                marksEvent.getMarksAsync().then(function(marks) {
                  var selectedMarks = [];
                  for (var markIndex = 0; markIndex < marks.length; markIndex++) {
                    var pairs = marks[markIndex].getPairs();
                    var pairData = {};
                    for (var pairIndex = 0; pairIndex < pairs.length; pairIndex++) {
                      var pair = pairs[pairIndex];
                      pairData[pair.fieldName] = pair.value;
                    }
                    selectedMarks.push(pairData);
                  }

                  Shiny.onInputChange(
                    elementId + "_selectedMarks:toDF",
                    selectedMarks
                  );
                });
              });

              // load initial parameter values
              workbook.getParametersAsync().then(function(parameters) {
                var parameterValues = [];
                for (var paramIndex = 0; paramIndex < parameters.length; paramIndex++) {
                  curParameter = {};
                  curParameter.name = parameters[paramIndex].getName();
                  curParameter.value = parameters[paramIndex].getCurrentValue().value;
                  curParameter.formatted_value = parameters[paramIndex].getCurrentValue().formattedValue;
                  curParameter.type = parameters[paramIndex].getDataType();
                  parameterValues.push(curParameter);
                }

                Shiny.onInputChange(
                  elementId + "_parameters:toDF",
                  parameterValues
                );
              });

              // listener for parameter change events
              viz.addEventListener(tableau.TableauEventName.PARAMETER_VALUE_CHANGE, function(paramEvent) {
                // just re-pull all of the parameters for now, in the future we could only update the one that changed
                workbook.getParametersAsync().then(function(parameters) {
                  var parameterValues = [];
                  for (var paramIndex = 0; paramIndex < parameters.length; paramIndex++) {
                    curParameter = {};
                    curParameter.name = parameters[paramIndex].getName();
                    curParameter.value = parameters[paramIndex].getCurrentValue().value;
                    curParameter.formatted_value = parameters[paramIndex].getCurrentValue().formattedValue;
                    curParameter.type = parameters[paramIndex].getDataType();
                    parameterValues.push(curParameter);
                  }

                  Shiny.onInputChange(
                    elementId + "_parameters:toDF",
                    parameterValues
                  );
                });
              });

              // initialize starting worksheet
              Shiny.onInputChange(
                elementId + "_worksheet",
                activeSheet.getName()
              );

              // listener for worksheet change events
              viz.addEventListener(tableau.TableauEventName.TAB_SWITCH, function(switchEvent) {
                  Shiny.onInputChange(
                    elementId + "_worksheet",
                    switchEvent.getNewSheetName()
                  );
              });
            }
          }
        };
        viz = new tableau.Viz(document.getElementById(el.id), url, options);
        container.viz = viz;
      },

      resize: function(width, height) {
      },

      // apply a categorical filter
      filter: function(params) {
        if (loaded === true) {
          var filterType;
          switch(params.type) {
            case "ALL":
              filterType = tableau.FilterUpdateType.ALL;
              break;
            case "REPLACE":
              filterType = tableau.FilterUpdateType.REPLACE;
              break;
            case "ADD":
              filterType = tableau.FilterUpdateType.ADD;
              break;
            case "REMOVE":
              filterType = tableau.FilterUpdateType.REMOVE;
              break;
            default:
              filterType = tableau.FilterUpdateType.REPLACE;
          }

          var exclude;
          if (params.exclude) {
              exclude = true;
          }

          var sheet = viz.getWorkbook().getActiveSheet();
         	if(sheet.getSheetType() === 'worksheet') {
        		sheet.applyFilterAsync(params.field, params.value, filterType, {isExcludeMode: exclude});
        	} else {
        		worksheetArray = sheet.getWorksheets();
        		for(var i = 0; i < worksheetArray.length; i++) {
        			worksheetArray[i].applyFilterAsync(params.field, params.value, filterType, {isExcludeMode: exclude});
        		}
        	}
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // apply a range filter
      rangeFilter: function(params) {
        if (loaded === true) {
          var sheet = viz.getWorkbook().getActiveSheet();
         	if(sheet.getSheetType() === 'worksheet') {
        		sheet.applyRangeFilterAsync(params.field, {min: params.min, max: params.max});
        	} else {
        		worksheetArray = sheet.getWorksheets();
        		for(var i = 0; i < worksheetArray.length; i++) {
        			worksheetArray[i].applyRangeFilterAsync(params.field, {min: params.min, max: params.max});
        		}
        	}
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // select data, similar to filtering
      select: function(params) {
        if (loaded === true) {
          var selectType;
          switch(params.type.toUpperCase()) {
            case "REPLACE":
              selectType = tableau.SelectionUpdateType.REPLACE;
              break;
            case "ADD":
              selectType = tableau.SelectionUpdateType.ADD;
              break;
            case "REMOVE":
              selectType = tableau.SelectionUpdateType.REMOVE;
              break;
            default:
              selectType = tableau.SelectionUpdateType.REPLACE;
          }

          var sheet = viz.getWorkbook().getActiveSheet();
         	if(sheet.getSheetType() === 'worksheet') {
        		sheet.selectMarksAsync(params.field, params.value, selectType);
        	} else {
        		worksheetArray = sheet.getWorksheets();
        		// select the first available worksheet in the dashboard if it's not specified
            if (params.worksheet === null) {
              worksheetArray[0].selectMarksAsync(params.field, params.value, selectType);
            } else {
                for(var i = 0; i < worksheetArray.length; i++) {
                  if(worksheetArray[i].getName() === params.worksheet) {
                    worksheetArray[i].selectMarksAsync(params.field, params.value, selectType);
                    break;
                  }
        		    }
            }
        	}
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // change a parameter
      changeParameter: function(params) {
        if (loaded === true) {
      		viz.getWorkbook().changeParameterValueAsync(params.parameter, params.value);
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // changes the active worksheet
      changeSheet: function(params) {
        if (loaded === true) {
          try {
            viz.getWorkbook().activateSheetAsync(params.worksheet);
          } catch (err) {
            console.log(err._message);
          }
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // revert
      revert: function() {
        if (loaded === true) {
          viz.revertAllAsync();
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // refresh data
      refresh: function() {
        if (loaded === true) {
          viz.refreshDataAsync();
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // export png
      png: function() {
        if (loaded === true) {
          viz.showExportImageDialog();
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // export pdf
      pdf: function() {
        if (loaded === true) {
          viz.showExportPDFDialog();
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // export underlying data
      data: function(params) {
        if (loaded === true) {
          try {
            if (params.worksheet === null) {
              viz.showExportDataDialog();
            } else {
              viz.showExportDataDialog(params.worksheet);
            }
          } catch (err) {
            console.log(err._message);
          }
        } else {
          console.log("The view is not loaded yet");
        }
      },

      // export crosstab
      crosstab: function(params) {
        if (loaded === true) {
          try {
            if (params.worksheet === null) {
              viz.showExportCrossTabDialog();
            } else {
              viz.showExportCrossTabDialog(params.worksheet);
            }
          } catch (err) {
            console.log(err._message);
          }
        } else {
          console.log("The view is not loaded yet");
        }
      },

      viz : viz
    };
  }
});

// add handlers for JS API calls
if (HTMLWidgets.shinyMode) {
  var fxns = ['filter', 'rangeFilter','select', 'changeParameter','changeSheet',
              'revert', 'refresh', 'png', 'pdf', 'data', 'crosstab'];

  var addShinyHandler = function(fxn) {
    return function() {
      Shiny.addCustomMessageHandler(
        "tableau:" + fxn, function(message) {
          var el = document.getElementById(message.id);
          if (el) {
            el.widget[fxn](message);
          }
        }
      );
    };
  };

  for (var i = 0; i < fxns.length; i++) {
    addShinyHandler(fxns[i])();
  }
}
