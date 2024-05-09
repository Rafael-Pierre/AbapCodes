sap.ui.define([
	'sap/ui/comp/library',
	'sap/ui/core/mvc/Controller',
	'sap/ui/model/type/String',
	'sap/m/ColumnListItem',
	'sap/m/Label',
	'sap/m/SearchField',
	'sap/m/Token',
	'sap/ui/model/Filter',
	'sap/ui/model/FilterOperator',
	'sap/ui/model/odata/v2/ODataModel',
	'sap/ui/table/Column',
	'sap/m/Column',
	'sap/m/Text'
], function(compLibrary, Controller, TypeString, ColumnListItem, Label, SearchField, Token, Filter, FilterOperator, ODataModel, UIColumn, MColumn, Text) {
    "use strict";
    return {  
        onInit: function () {

			// Whitespace
			this._oWhiteSpacesInput = this.byId("whiteSpaces");
			this._oWhiteSpacesInput2 = '';

		},
        onWhitespaceVHRequested: function(oEvent) {
			this._oWhiteSpacesInput2 = oEvent.getSource();
			var oTextTemplate = new Text({text: {path: 'Condicao_Frete'}, renderWhitespace: true});
			
			this._oBasicSearchField = new SearchField({
				search: function() {
					this.oWhitespaceDialog.getFilterBar().search();
				}.bind(this)
			});
			if (!this.pWhitespaceDialog) {
				this.pWhitespaceDialog = this.loadFragment({
					name: "br.com.tromink.relatoriorpmcamposeditaveis.ext.fragments.ResponsiveTableCells"
				});
			}
			this.pWhitespaceDialog.then(function(oWhitespaceDialog) {
				var oFilterBar = oWhitespaceDialog.getFilterBar();
				this.oWhitespaceDialog = oWhitespaceDialog;
				if (this._bWhitespaceDialogInitialized) {
					// Re-set the tokens from the input and update the table
					// oWhitespaceDialog.setTokens([]);
					// oWhitespaceDialog.setTokens(this._oWhiteSpacesInput.getTokens());
					// oWhitespaceDialog.update();

					oWhitespaceDialog.open();
					return;
				}
				this.getView().addDependent(oWhitespaceDialog);

				// Set key fields for filtering in the Define Conditions Tab
				// oWhitespaceDialog.setRangeKeyFields([{
				// 	label: "Condicao frete",
				// 	key: "ConditionFrete",
				// 	type: "string",
				// 	typeInstance: new TypeString({}, {
				// 		maxLength: 7
				// 	})
				// }]);

				// Set Basic Search for FilterBar
				oFilterBar.setFilterBarExpanded(false);
				oFilterBar.setBasicSearch(this._oBasicSearchField);

				// Re-map whitespaces
				oFilterBar.determineFilterItemByName("Condicao_Frete").getControl().setTextFormatter(this._inputTextFormatter);

				oWhitespaceDialog.getTableAsync().then(function (oTable) {
					oTable.setModel(this.oModel);
                    oTable.setSelectionMode('Single');

					// For Desktop and tabled the default table is sap.ui.table.Table
					if (oTable.bindRows) {
						oTable.addColumn(new UIColumn({label: "Condicao frete", template: oTextTemplate}));
						oTable.addColumn(new UIColumn({label: "Descricao", template: "ConditionName"}));
						oTable.bindAggregation("rows", {
							path: "/ZI_RPM_VH_FRETE",
							events: {
								dataReceived: function() {
									oWhitespaceDialog.update();
								}
							}
						});
					}

					// For Mobile the default table is sap.m.Table
					if (oTable.bindItems) {
						oTable.addColumn(new MColumn({header: new Label({text: "Condicao frete"})}));
						oTable.addColumn(new MColumn({header: new Label({text: "Descricao"})}));
						oTable.bindItems({
							path: "/ZI_RPM_VH_FRETE",
							template: new ColumnListItem({
								cells: [new Label({text: "{Condicao_Frete}"}), new Label({text: "{ConditionName}"})]
							}),
							events: {
								dataReceived: function() {
									oWhitespaceDialog.update();
								}
							}
						});
					}

					oWhitespaceDialog.update();
				}.bind(this));

				// oWhitespaceDialog.setTokens(this._oWhiteSpacesInput.getTokens());
				this._bWhitespaceDialogInitialized = true;
				oWhitespaceDialog.open();
			}.bind(this));
		},
		_inputTextFormatter: function (oItem) {
			var sOriginalText = oItem.getText(),
				sWhitespace = " ",
				sUnicodeWhitespaceCharacter = "\u00A0"; // Non-breaking whitespace

			if (typeof sOriginalText !== "string") {
				return sOriginalText;
			}

			return sOriginalText
				.replaceAll((sWhitespace + sUnicodeWhitespaceCharacter), (sWhitespace + sWhitespace));
		},
		whitespace2Char: function (sOriginalText) {
			var sWhitespace = " ",
				sUnicodeWhitespaceCharacter = "\u00A0"; // Non-breaking whitespace

			if (typeof sOriginalText !== "string") {
				return sOriginalText;
			}

			return sOriginalText
				.replaceAll((sWhitespace + sWhitespace), (sWhitespace + sUnicodeWhitespaceCharacter)); // replace spaces
		},
		// #endregion
		onFilterBarSearch: function (oEvent) {
			var sSearchQuery = this._oBasicSearchField.getValue(),
				aSelectionSet = oEvent.getParameter("selectionSet");

			var aFilters = aSelectionSet.reduce(function (aResult, oControl) {
				if (oControl.getValue()) {
					aResult.push(new Filter({
						path: oControl.getName(),
						operator: FilterOperator.Contains,
						value1: oControl.getValue()
					}));
				}

				return aResult;
			}, []);

			aFilters.push(new Filter({
				filters: [
					new Filter({ path: "Condicao_Frete", operator: FilterOperator.Contains, value1: sSearchQuery }),
					new Filter({ path: "ConditionName", operator: FilterOperator.Contains, value1: sSearchQuery })
				],
				and: false
			}));

			this._filterTable(new Filter({
				filters: aFilters,
				and: true
			}));
		},
		onFilterBarWhitespacesSearch: function (oEvent) {
			var sSearchQuery = this._oBasicSearchField.getValue(),
				aSelectionSet = oEvent.getParameter("selectionSet");

			var aFilters = aSelectionSet.reduce(function (aResult, oControl) {
				if (oControl.getValue()) {
					aResult.push(new Filter({
						path: oControl.getName(),
						operator: FilterOperator.Contains,
						value1: oControl.getValue()
					}));
				}

				return aResult;
			}, []);

			aFilters.push(new Filter({
				filters: [
					new Filter({ path: "Condicao_Frete", operator: FilterOperator.Contains, value1: sSearchQuery }),
					new Filter({ path: "ConditionName", operator: FilterOperator.Contains, value1: sSearchQuery })
				],
				and: false
			}));

			this._filterTableWhitespace(new Filter({
				filters: aFilters,
				and: true
			}));
		},

		_filterTableWhitespace: function (oFilter) {
			var oValueHelpDialog = this.oWhitespaceDialog;
			oValueHelpDialog.getTableAsync().then(function (oTable) {
				if (oTable.bindRows) {
					oTable.getBinding("rows").filter(oFilter);
				}
				if (oTable.bindItems) {
					oTable.getBinding("items").filter(oFilter);
				}
				oValueHelpDialog.update();
			});
		},
		onWhitespaceOkPress: function (oEvent) {
			var aTokens = oEvent.getParameter("tokens");
			var vNewUsedStock;
			aTokens.forEach(function (oToken) {
				oToken.setText(this.whitespace2Char(oToken.getText()));

				vNewUsedStock = oToken.getKey();
			}.bind(this));

            this._oWhiteSpacesInput2.setSelectedKey(aTokens[0].getKey());
            this.oWhitespaceDialog.close();

			var that = this;
            var oBindingContext = this._oWhiteSpacesInput2.getBindingContext();

            var fnFunction = function () {
                return new Promise(function (fnResolve, fnReject) {

                    that.extensionAPI.invokeActions(
                        "/onFrete",
                       oBindingContext,
                       {
                            "Frete": vNewUsedStock
                        }, 
                    ).then(function (data) {
                        fnResolve();
                        that.templateBaseExtension.getExtensionAPI().refreshTable();
                        that.getView().getModel().refresh();
                    });
                });
            }

            var mParameters = {
                busy: {
                    set: true,
                    check: false
                },
                dataloss: {
                    popup: false,
                    navigation: false
                }
            };
            this.extensionAPI.securedExecution(fnFunction, mParameters);
			
			this.oWhitespaceDialog.close();

		},
		onWhitespaceCancelPress: function () {
			this.oWhitespaceDialog.close();
		}, 
        onQuantidade: function (oEvent) {

            var that = this;
            var oInput = oEvent.getSource();
            var oBindingContext = oEvent.getSource().getBindingContext();

            var vNewUsedStock = parseFloat( oInput.getValue() );

            /* =================================================================== 
            Chama Action no Behavior da CDS 
            =================================================================== */
           var fnFunction = function () {
                return new Promise(function (fnResolve, fnReject) {

                    that.extensionAPI.invokeActions(
                        "/onQuantidade",
                       oBindingContext,
                       {
                            "quantidade_total": vNewUsedStock
                        }, 
                    ).then(function (data) {
                        fnResolve();
                        that.templateBaseExtension.getExtensionAPI().refreshTable();
                        that.getView().getModel().refresh();
                    }).catch(function (data) {
                        fnReject();
                        that.templateBaseExtension.getExtensionAPI().refreshTable();
                        that.getView().getModel().refresh();
                    });
                });
            }

            var mParameters = {
                busy: {
                    set: true,
                    check: false
                },
                dataloss: {
                    popup: false,
                    navigation: false
                }
            };
            this.extensionAPI.securedExecution(fnFunction, mParameters);

        },
		onMontante: function (oEvent) {

            var that = this;
            var oInput = oEvent.getSource();
            var oBindingContext = oEvent.getSource().getBindingContext();

            var vNewUsedStock = parseFloat( oInput.getValue() );

            /* =================================================================== 
            Chama Action no Behavior da CDS 
            =================================================================== */
           var fnFunction = function () {
                return new Promise(function (fnResolve, fnReject) {

                    that.extensionAPI.invokeActions(
                        "/onMontante",
                       oBindingContext,
                       {
                            "Valor_Montante": vNewUsedStock
                        }, 
                    ).then(function (data) {
                        fnResolve();
                        that.templateBaseExtension.getExtensionAPI().refreshTable();
                        that.getView().getModel().refresh();
                    }).catch(function (data) {
                        fnReject();
                        that.templateBaseExtension.getExtensionAPI().refreshTable();
                        that.getView().getModel().refresh()});
					
                });
            }

            var mParameters = {
                busy: {
                    set: true,
                    check: false
                },
                dataloss: {
                    popup: false,
                    navigation: false
                }
            };
            this.extensionAPI.securedExecution(fnFunction, mParameters);

        },
        onDataPick: function (oEvent) {

            var that = this;
            var oInput = oEvent.getSource();
            var oBindingContext = oEvent.getSource().getBindingContext();

            /*var dateFormat = sap.ui.core.format.DateFormat.getDateInstance({pattern : "YYYY/MM/DD" });   
            var vNewUsedStock = dateFormat.format(oInput.getDateValue()); */

            var vNewUsedStock = oInput.getDateValue();

            /* =================================================================== 
            Chama Action no Behavior da CDS 
            =================================================================== */
            var fnFunction = function () {
                return new Promise(function (fnResolve, fnReject) {

                    that.extensionAPI.invokeActions(
                        "/onDataPick",
                       oBindingContext,
                       {
                            "Pricingdate": vNewUsedStock
                        }, 
                    ).then(function (data) {
                        fnResolve();
                        that.templateBaseExtension.getExtensionAPI().refreshTable();
                        that.getView().getModel().refresh();
                    });
                });
            }

            var mParameters = {
                busy: {
                    set: true,
                    check: false
                },
                dataloss: {
                    popup: false,
                    navigation: false
                }
            };
            this.extensionAPI.securedExecution(fnFunction, mParameters);

        }

    }
});