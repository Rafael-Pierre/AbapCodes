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
		that : this,
		onInit: function () {

			// Whitespace
			// this.that._oWhiteSpacesInput = this.that.byId("Material");
			// this.that._oWhiteSpacesInput2 = '';

			//this._oInputUfDestino = this.that.byId("Partner");
			this._oInputUfDestino2 = '';

			// this.that._oInputCentro = this.that.byId("tipomov");
			// this.that._oInputCentro2 = '';

		}, 
		valueHelpContruct: function (context) {
			//this.that._oInputUfDestino2 = sap.ui.getCore().byId('inMotivo');
			
            //this._oInputUfDestino2 = oEvent.getSource();

			var oTextTemplate2 = new Text({ text: { path: 'Partner' }, renderWhitespace: true });

			//sLinha = oEvent.getSource().getBindingContext().getObject();

			this._oBasicSearchField2 = new sap.m.SearchField({
				search: function () {
					this.oWhitespaceDialog2.getFilterBar().search();
				}.bind(this)
			});
			//if (!this.pWhitespaceDialog2) {  
			this.pWhitespaceDialog2 = context.loadFragment({
            	name: "br.com.simrede.mmbaseterceiro.ext.fragments.valueHelpBpCliente"
			});
			//}
			this.pWhitespaceDialog2.then(function (oWhitespaceDialog2) {
				var oFilterBar2 = oWhitespaceDialog2.getFilterBar();
				var i18nTxt = context.getView().getModel("i18n").getResourceBundle();
				this.oWhitespaceDialog2 = oWhitespaceDialog2;
				
				if (this._bWhitespaceDialogInitialized2) {
					oWhitespaceDialog2.open();
					return;
				}
				context.getView().addDependent(oWhitespaceDialog2);

				// Set Basic Search for FilterBar
				oFilterBar2.setFilterBarExpanded(false);
				oFilterBar2.setBasicSearch(this._oBasicSearchField2);

				// Re-map whitespaces
				oFilterBar2.determineFilterItemByName("Partner").getControl().setTextFormatter(this._inputTextFormatter);

				oWhitespaceDialog2.getTableAsync().then(function (oTable2) {
					oTable2.setModel(context.oModel);
					oTable2.setSelectionMode('Single');

					// For Desktop and tabled the default table is sap.ui.table.Table
					if (oTable2.bindRows) {
						oTable2.addColumn(new UIColumn({ label: i18nTxt.getText("BpCliente"), template: oTextTemplate2 }));
						oTable2.addColumn(new UIColumn({ label: i18nTxt.getText("BpClienteDesc"), template: "PartnerName" }));
						oTable2.bindAggregation("rows", {
							path: "/BpBase",
							events: {
								dataReceived: function () {
									oWhitespaceDialog2.update();
								}
							}
						});
					}
					// For Mobile the default table is sap.m.Table
					if (oTable2.bindItems) {
						oTable2.addColumn(new MColumn({ header: new Label({ text: i18nTxt.getText("BpCliente") }) }));
						oTable2.addColumn(new MColumn({ header: new Label({ text: i18nTxt.getText("BpClienteDesc") }) }));
						oTable2.bindItems({
							path: "/BpBase",
							template: new ColumnListItem({
								cells: [new Label({ text: "{Partner}" }), new Label({ text: "{PartnerName}" })]
							}),
							events: {
								dataReceived: function () {
									oWhitespaceDialog2.update();
								}
							}
						});
					}

					oWhitespaceDialog2.update();
				}.bind(this));
				this._bWhitespaceDialogInitialized2 = true;
				this.ValueHelpDialogCancel = function () {
					// context.pWhitespaceDialog2.close();
					oWhitespaceDialog2.close();
					oWhitespaceDialog2.destroy();
				};
				this.ValueHelpDialogOk = function (oEvent) {
					var aTokens = oEvent.getParameter("tokens"); 

					var value = aTokens[0].getKey();
					
					oWhitespaceDialog2.close();
					oWhitespaceDialog2.destroy();
					//sap.ui.getCore().byId('inPartner').setValue(aTokens[0].mAggregations.customData[0].mProperties.value.Partner);
					//this._oInputUfDestino2.setSelectedKey(aTokens[0].getKey());

					// var value = aTokens[0].mAggregations.customData[0].mProperties.value.Partner;

					return value;
					/* =================================================================== 
					Chama Action no Behavior da CDS 
					=================================================================== */
				};
				this.SuggestionItemSelected = function(oEvent) {
							
					let aFilters;
					
					aFilters = [
						new Filter("Partner", FilterOperator.EQ, oEvent.mParameters.selectedItem.mProperties.key)
					]
		
					this.filterTable(new Filter({
						filters: aFilters,
						and: true
					}));
				};
				this.Search = function (oEvent) {
					//var tipomov = sap.ui.getCore().byId('inTypeMovimento').getValue();
					var sSearchQuery = `'${this._oBasicSearchField2.getValue()}'`,
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
							new Filter({ path: "Partner", operator: FilterOperator.Contains, value1: sSearchQuery }),
							new Filter({ path: "PartnerName", operator: FilterOperator.Contains, value1: sSearchQuery })
						],
						and: false
					}));
		
					this.filterTable(new Filter({
						filters: aFilters,
						and: true
					}));
				};
				this.filterTable = function (oFilter) {
					//var oValueHelpDialog = this.oWhitespaceDialog2;
					oWhitespaceDialog2.getTableAsync().then(function (oTable) {
						if (oTable.bindRows) {
							oTable.getBinding("rows").filter(oFilter);
						}
						if (oTable.bindItems) {
							oTable.getBinding("items").filter(oFilter);
						}
						oWhitespaceDialog2.update();
					});
				};

				oWhitespaceDialog2.open();
			}.bind(this));
            this.onSearchMotivo
		},         
		onFilterBarSearch: function (oEvent) {},
		onInputSuggestionItemSelected: function (oEvent) {},
        _filterTable: function (oFilter) {}, 
		onValueHelpDialogCancel: function() {},
		onValueHelpDialogPopUpRetornoRemessaOk: function(oEvent) {},

		onInputSuggestionItemSelected2: function(oEvent) {}
    }
});