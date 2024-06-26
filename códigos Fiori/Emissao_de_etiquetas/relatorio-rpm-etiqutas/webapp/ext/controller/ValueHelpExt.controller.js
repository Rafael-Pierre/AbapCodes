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
		onInit: function () {}, 
		valueHelpContruct: function (oEvent, context) {
			//this.that._oInputUfDestino2 = sap.ui.getCore().byId('inMotivo');
			
            this._oInputUfDestino2 = oEvent.getSource();
			this.oBindingContext = oEvent.getSource().getBindingContext();
			let bwart = this.oBindingContext.getObject().TyMove;

			let intalFilter = new Filter({
				filters: [
					new Filter("bwart", FilterOperator.EQ, bwart)
				],
				and: true
			});

			var oTextTemplate2 = new Text({ text: { path: 'motivomov' }, renderWhitespace: true });

			//sLinha = oEvent.getSource().getBindingContext().getObject();

			this._oBasicSearchField2 = new sap.m.SearchField({
				search: function () {
					this.oWhitespaceDialog2.getFilterBar().search();
				}.bind(this)
			});
			//if (!this.pWhitespaceDialog2) {  
			this.pWhitespaceDialog2 = context.loadFragment({
            	name: "br.com.simrede.mmbaseterceiro.ext.fragments.valueHelpMotivo"
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
				oFilterBar2.determineFilterItemByName("motivomov").getControl().setTextFormatter(this._inputTextFormatter);

				oWhitespaceDialog2.getTableAsync().then(function (oTable2) {
					oTable2.setModel(context.oModel);
					oTable2.setSelectionMode('Single');

					// For Desktop and tabled the default table is sap.ui.table.Table
					if (oTable2.bindRows) {
						oTable2.addColumn(new UIColumn({ label: i18nTxt.getText("Motivo"), template: oTextTemplate2 }));
						oTable2.addColumn(new UIColumn({ label: i18nTxt.getText("MotivoDesc"), template: "Grtxt" }));
						oTable2.addColumn(new UIColumn({ label: i18nTxt.getText("TyMove"), template: "bwart" }));
						oTable2.bindAggregation("rows", {
							path: "/MotivoVH",
							events: {
								dataReceived: function () {
									oWhitespaceDialog2.update();
								}
							}
						});
						oTable2.getBinding("rows").filter(intalFilter);
					}
					// For Mobile the default table is sap.m.Table
					if (oTable2.bindItems) {
						oTable2.addColumn(new MColumn({ header: new Label({ text: i18nTxt.getText("Motivo") }) }));
						oTable2.addColumn(new MColumn({ header: new Label({ text: i18nTxt.getText("MotivoDesc") }) }));
						oTable2.addColumn(new MColumn({ header: new Label({ text: i18nTxt.getText("TyMove") }) }));
						oTable2.bindItems({
							path: "/MotivoVH",
							template: new ColumnListItem({
								cells: [new Label({ text: "{motivomov}" }), new Label({ text: "{Grtxt}" })]
							}),
							events: {
								dataReceived: function () {
									oWhitespaceDialog2.update();
								}
							}
						});
						oTable2.getBinding("items").filter(intalFilter);
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
					//sap.ui.getCore().byId('inMotivoMov').setValue(aTokens[0].mAggregations.customData[0].mProperties.value.motivomov);
					//this._oInputUfDestino2.setSelectedKey(aTokens[0].getKey());

					// var value = aTokens[0].mAggregations.customData[0].mProperties.value.motivomov;

					return value;
					/* =================================================================== 
					Chama Action no Behavior da CDS 
					=================================================================== */
				};
				this.SuggestionItemSelected = function(sMotivo, sGrtxt) {
							
					let bwart = this.oBindingContext.getObject().TyMove;
					let aFilters;
		
					if (sMotivo && !sGrtxt) {
						aFilters = [
							new Filter("motivomov", FilterOperator.EQ, sMotivo),
							new Filter("bwart", FilterOperator.EQ, bwart)
						]
					}
		
					if (!sMotivo && sGrtxt) {
						aFilters = [
							new Filter("Grtxt", FilterOperator.EQ, sGrtxt),
							new Filter("bwart", FilterOperator.EQ, bwart)
						]
					}
		
					if (sMotivo && sGrtxt) {
						aFilters = [
							new Filter("motivomov", FilterOperator.EQ, sMotivo),
							new Filter("Grtxt", FilterOperator.EQ, sGrtxt),
							new Filter("bwart", FilterOperator.EQ, bwart)
						]
					}
		
					this.filterTableMotivo(new Filter({
						filters: aFilters,
						and: true
					}));
				};
				this.Search = function (oEvent) {
					let bwart = this.oBindingContext.getObject().TyMove;
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
							new Filter({ path: "bwart", operator: FilterOperator.EQ, value1: bwart }),
							new Filter({ path: "motivomov", operator: FilterOperator.Contains, value1: sSearchQuery }),
							new Filter({ path: "Grtxt", operator: FilterOperator.Contains, value1: sSearchQuery })
						],
						and: false
					}));
		
					this.filterTableMotivo(new Filter({
						filters: aFilters,
						and: true
					}));
				};
				this.filterTableMotivo = function (oFilter) {
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
            //this.Search();
		},         
		onFilterBarSearch: function (oEvent) {},
		onInputSuggestionItemSelected: function (oEvent) {},
        _filterTableMotivo: function (oFilter) {},
		onValueHelpDialogOk: function() {},
		onValueHelpDialogCancel: function() {}
    }
});