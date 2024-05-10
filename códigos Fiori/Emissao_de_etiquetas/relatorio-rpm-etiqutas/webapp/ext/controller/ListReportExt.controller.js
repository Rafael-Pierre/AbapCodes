var sLinha = {};
sap.ui.define([
    './ValueHelpExt.controller',
    './ValueHelpBpClienteExt.controller',
    './ValueHelpBpClienteExt2.controller',
    './ValueHelpModalidaFreteExt.controller',
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
    'sap/m/Text',
    "sap/m/MessageToast",
    "sap/m/PDFViewer"
], function (ValueHelpExt, ValueHelpBpClienteExt, ValueHelpBpClienteExt2, ValueHelpModalidaFreteExt,
    compLibrary, Controller, TypeString, ColumnListItem, Label, SearchField, Token, Filter, FilterOperator, ODataModel, UIColumn, MColumn, Text,
    TextMessageToast,
    PDFViewer
) {
    "use strict";
    return {
        onInit: function () {

            // Whitespace
            // this._oWhiteSpacesInput = this.byId("Material");
            // this._oWhiteSpacesInput2 = '';

            this._oInputUfDestino2 = '';

        },
        getPDFData: function (oEvent) {

            // var that = this;
            // let oExtApi = this.templateBaseExtension.getExtensionAPI();
            // let oBindingContext = oEvent.getSource().getBindingContext();

            // var oContent = new sap.ui.layout.VerticalLayout({
            //     width: '100%',
            //     content: [
            //         new sap.m.Label({ text: "Quantidade" }),
            //         new sap.m.Input('inVolume', {
            //             width: '100%',
            //             showValueHelp: false,
            //             type: "Number"
            //         })
            //     ]
            // })

            // var pressDialog = new sap.m.Dialog({
            //     type: 'Message',
            //     title: "Volume",
            //     resizable: false,
            //     draggable: true,
            //     titleAlignment: sap.m.TitleAlignment.Left,
            //     content: oContent,
            //     beginButton: new sap.m.Button({
            //         type: sap.m.ButtonType.Emphasized,
            //         text: "Quantidade",
            //         press: function () {
            // get the Model reference
            var oModel = this.getView().getModel();

            let oCtx = this.templateBaseExtension.getExtensionAPI().getSelectedContexts();
            return new Promise((resolve, reject) => {

                var cod_embalagem = sap.ui.getCore().byId("packingtype").getValue();
                var peso_embalagem = sap.ui.getCore().byId("peso_embalagem").getValue();
                var quantidade = sap.ui.getCore().byId("quantidade").getValue();
                var peso_liquido = sap.ui.getCore().byId("peso_liquido").getValue();
                var codido_remessa = sap.ui.getCore().byId("codigo_remessa").getValue();

                if (cod_embalagem === "" || peso_embalagem === "" || quantidade === "" || peso_liquido === "" || codigo_remessa === "") {
                    // Alguma das variáveis está vazia, exibe uma mensagem de erro na tela
                    sap.m.MessageToast.show("Por favor, preencha todos os campos obrigatórios.", {
                        duration: 3000, // Duração da mensagem em milissegundos (3 segundos)
                        width: "15em", // Largura da mensagem
                        my: "center top", // Posição da mensagem
                        at: "center top", // Posição da mensagem
                        of: window, // Elemento de referência para a posição da mensagem
                        offset: "0 0" // Deslocamento em relação ao elemento de referência
                    });

                    return;
                }

                var checkBox = sap.ui.getCore().byId("inChex");
                var isChecked = checkBox.getSelected();

                if (isChecked == true) {

                    // Perform Read operation and pass billingdoc as parameter to URL
                    oModel.read(`/ZC_RPM_ETIQUETA_CE(packingtype='${cod_embalagem}',peso_embalagem='${peso_embalagem}',quantidade='${quantidade}',peso_liquido='${peso_liquido}',codigo_remessa='${codido_remessa}',checkbox=true)/Set`, {
                        success: function (oData, oResponse) {
                            resolve(oData);
                        },
                        error: function (oError) {
                            reject(oError);
                        }
                    });

                } else {

                    // Perform Read operation and pass billingdoc as parameter to URL
                    oModel.read(`/ZC_RPM_ETIQUETA_CE(packingtype='${cod_embalagem}',peso_embalagem='${peso_embalagem}',quantidade='${quantidade}',peso_liquido='${peso_liquido}',codigo_remessa='${codido_remessa}',checkbox=false)/Set`, {
                        success: function (oData, oResponse) {
                            resolve(oData);
                        },
                        error: function (oError) {
                            reject(oError);
                        }
                    });
                }
            })
            //         }.bind(this)
            //     }),
            //     endButton: new sap.m.Button({
            //         text: "Cancelar",
            //         press: function () {
            //             pressDialog.close();
            //         }
            //     }),
            //     afterClose: function () {
            //         pressDialog.destroy();
            //     },
            //     contentWidth: "20%",

            // });
            // pressDialog.open();

        },
        onPopup: async function (oEvent) {
            var opdfViewer = new PDFViewer();
            this.getView().addDependent(opdfViewer);
            // var oBusyDialog = new sap.m.BusyDialog({
            //     title: 'Gerando PDF...'
            // });
            // oBusyDialog.open();

            // Get the PDF data 
            var vPDF = await this.getPDFData();

            if (vPDF === '') {
                sap.m.MessageBox.error("Erro ao gerar PDF")
                return;
            }

            if (typeof vPDF !== 'undefined') {
                let base64EncodedPDF = vPDF.results[0].stream_data;
                let decodedPdfContent = atob(base64EncodedPDF);
                let byteArray = new Uint8Array(decodedPdfContent.length);
                for (var i = 0; i < decodedPdfContent.length; i++) {
                    byteArray[i] = decodedPdfContent.charCodeAt(i);
                }
                var blob = new Blob([byteArray.buffer], {
                    type: 'application/pdf'
                });
                var pdfurl = URL.createObjectURL(blob);
                jQuery.sap.addUrlWhitelist("blob"); // register blob url as whitelist
                opdfViewer.setSource(pdfurl);
                opdfViewer.setVisible(true);

                opdfViewer.setTitle("ND");
                opdfViewer.open();
                // oBusyDialog.close();
            }
        },
        onPDF: async function (oEvent) {

            // let oCtx = this.templateBaseExtension.getExtensionAPI().getSelectedContexts();

            // if ((oCtx.length > 1)) {
            //     sap.m.MessageBox.error("Selecionar apenas uma linha")
            //     return;
            // }
            // if ((oCtx[0].getObject().semaforo === 3)) {
            //     sap.m.MessageBox.error("Impossível selecionar linha de ganho")
            //     return;
            // }


            var oContent = new sap.ui.layout.VerticalLayout({
                width: '80%',
                content: [
                    new sap.m.Label({ text: "Packing Type" }),
                    new sap.m.Input('packingtype', {
                        // width: '100%',
                        required: true,
                        showValueHelp: false,
                        type: "Number"
                    }),
                    new sap.m.Label({ text: "Peso da embalagem" }),
                    new sap.m.Input('peso_embalagem', {
                        // width: '100%',
                        required: true,
                        showValueHelp: false,
                        type: "Number",
                    }),

                    new sap.m.Label({ text: "Peso liquido" }),
                    new sap.m.Input('peso_liquido', {
                        // width: '100%',
                        showValueHelp: false,
                        type: "Number"
                    }),

                    new sap.m.Label({ text: "Quantidade" }),
                    new sap.m.Input('quantidade', {
                        //width: '100%',
                        required: true,
                        showValueHelp: false,
                        type: "Number"
                    }),

                    new sap.m.Label({ text: "Código da Remessa" }),
                    new sap.m.Input('codigo_remessa', {
                        //width: '100%',
                        required: true,
                        showValueHelp: true,
                        valueHelpRequest: () => { that.valueHelpBpCliente2(that) },
                        type: "Number",

                    }),

                    new sap.m.CheckBox('inChex', {
                        selected: false,
                    }),
                ]
            })

            var pressDialog = new sap.m.Dialog({
                type: 'Message',
                title: "Gerar Etiqueta",
                resizable: false,
                draggable: true,
                titleAlignment: sap.m.TitleAlignment.Left,
                content: oContent,
                beginButton: new sap.m.Button({
                    type: sap.m.ButtonType.Emphasized,
                    text: "Gerar Etiqueta",
                    press: function () {
                        this.onPopup();
                    }.bind(this)
                }),
                endButton: new sap.m.Button({
                    text: "Cancelar",
                    press: function () {
                        pressDialog.close();
                    }
                }),
                afterClose: function () {
                    pressDialog.destroy();
                },
                contentWidth: "20%",

            });
            pressDialog.open();

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
        valueHelpMotivo: function (oEvent, context) {
            this._oInputUfDestino2 = oEvent.getSource();
            var oTextTemplate2 = new Text({ text: { path: 'motivomov' }, renderWhitespace: true });

            sLinha = oEvent.getSource().getBindingContext().getObject();

            this._oBasicSearchField2 = new SearchField({
                search: function () {
                    this.oWhitespaceDialog2.getFilterBar().search();
                }.bind(this)
            });
            if (!this.pWhitespaceDialog2) {
                this.pWhitespaceDialog2 = this.loadFragment({
                    name: "br.com.tromink.relatoriorpmetiqutas.ext.fragments.valueHelpMotivo"
                });
            }
            this.pWhitespaceDialog2.then(function (oWhitespaceDialog2) {
                var oFilterBar2 = oWhitespaceDialog2.getFilterBar();
                this.oWhitespaceDialog2 = oWhitespaceDialog2;
                if (this._bWhitespaceDialogInitialized2) {
                    oWhitespaceDialog2.open();
                    return;
                }
                this.getView().addDependent(oWhitespaceDialog2);

                // Set Basic Search for FilterBar
                oFilterBar2.setFilterBarExpanded(false);
                oFilterBar2.setBasicSearch(this._oBasicSearchField2);

                // Re-map whitespaces
                oFilterBar2.determineFilterItemByName("motivomov").getControl().setTextFormatter(this._inputTextFormatter);

                oWhitespaceDialog2.getTableAsync().then(function (oTable2) {
                    oTable2.setModel(this.oModel);
                    oTable2.setSelectionMode('Single');

                    // For Desktop and tabled the default table is sap.ui.table.Table
                    if (oTable2.bindRows) {
                        oTable2.addColumn(new UIColumn({ label: "Motivo", template: oTextTemplate2 }));
                        oTable2.addColumn(new UIColumn({ label: "Descrição", template: "Grtxt" }));
                        oTable2.bindAggregation("rows", {
                            path: "/ZI_MM_VH_GRUND",
                            events: {
                                dataReceived: function () {
                                    oWhitespaceDialog2.update();
                                }
                            }
                        });
                    }

                    // For Mobile the default table is sap.m.Table
                    if (oTable2.bindItems) {
                        oTable2.addColumn(new MColumn({ header: new Label({ text: "Motivo" }) }));
                        oTable2.addColumn(new MColumn({ header: new Label({ text: "Descricao" }) }));
                        oTable2.bindItems({
                            path: "/ZI_MM_VH_GRUND",
                            template: new ColumnListItem({
                                cells: [new Label({ text: "{motivomov}" }), new Label({ text: "{Grtxt}" })]
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
                oWhitespaceDialog2.open();
            }.bind(this));
        },
        onSearchMotivo: function (oEvent) {
            var sSearchQuery = this._oBasicSearchField2.getValue(),
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
                    new Filter({ path: "motivomov", operator: FilterOperator.Contains, value1: sSearchQuery }),
                    new Filter({ path: "Grtxt", operator: FilterOperator.Contains, value1: sSearchQuery })
                ],
                and: false
            }));

            this._filterTableMotivo(new Filter({
                filters: aFilters,
                and: true
            }));
        },
        onSuggestionItemSelectedMotivo: function (oEvent) {
            var sRegion = this.byId("inRegion").getValue();
            var sRegionName = this.byId("inRegionName").getValue();

            let aFilters;

            if (sRegion && !sRegionName) {
                aFilters = [
                    new Filter("motivomov", FilterOperator.EQ, sRegion)
                ]
            }

            if (!sRegion && sRegionName) {
                aFilters = [
                    new Filter("Grtxt", FilterOperator.EQ, sRegionName)
                ]
            }

            if (sRegion && sRegionName) {
                aFilters = [
                    new Filter("motivomov", FilterOperator.EQ, sRegion),
                    new Filter("Grtxt", FilterOperator.EQ, sRegionName)
                ]
            }

            this._filterTableMotivo(new Filter({
                filters: aFilters,
                and: true
            }));
        },
        onCancelPressMotivo: function (oEvent) {
            this.oWhitespaceDialog2.close();
        },
        onOkPressMotivo: function (oEvent) {
            var aTokens = oEvent.getParameter("tokens");
            var vNewUsedStock;
            aTokens.forEach(function (oToken) {
                oToken.setText(this.whitespace2Char(oToken.getText()));

                vNewUsedStock = oToken.getKey();
            }.bind(this));

            this._oInputUfDestino2.setValue(aTokens[0].getKey());
            this.oWhitespaceDialog2.close();

            var that = this;

            var oBindingContext = this._oInputUfDestino2.getBindingContext();

            /* =================================================================== 
            Chama Action no Behavior da CDS 
            =================================================================== */
            var fnFunction = function () {
                return new Promise(function (fnResolve, fnReject) {

                    that.extensionAPI.invokeActions(
                        "/motivo",
                        oBindingContext,
                        {
                            "motivoparam": vNewUsedStock
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
            var teste = this.extensionAPI.securedExecution(fnFunction, mParameters);
        },
        onSubmitMotivo: function (oEvent) {
            let vUfDestino = oEvent.getParameters().value;
            var that = this;
            var vIdRow = oEvent.getSource().getParent().sId
            var oBindingContext = oEvent.getSource().getBindingContext();

            let oModel = this.getView().getModel();
            /* =================================================================== 
            Faz a leitura na CDS para validar se existe o registro 
            =================================================================== */
            var fnFunction = function () {
                return new Promise(function (fnResolve, fnReject) {

                    that.extensionAPI.invokeActions(
                        "motivo",
                        oBindingContext,
                        {
                            "motivomov": vNewUsedStock
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
        },
        onliveChangeMotivo: function (oEvent) {
            var input = oEvent.getSource();

            input.setValue(input.getValue().toUpperCase());
        },
        _filterTableMotivo: function (oFilter) {
            var oValueHelpDialog = this.oWhitespaceDialog2;
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
        onDescarga: function (oEvent) {

            var that = this;
            var oInput = oEvent.getSource();
            var oBindingContext = oEvent.getSource().getBindingContext();

            var vNewUsedStock = parseFloat(oInput.getValue());

            /* =================================================================== 
            Chama Action no Behavior da CDS 
            =================================================================== */
            var fnFunction = function () {
                return new Promise(function (fnResolve, fnReject) {

                    that.extensionAPI.invokeActions(
                        "/descarga",
                        oBindingContext,
                        {
                            "descarga": vNewUsedStock
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

        },
        GerarRetornoArm: function (oEvent) {

            var that = this;
            var oInput = oEvent.getSource();
            var oBindingContext = oEvent.getSource().getBindingContext();

            var BpCliente = sap.ui.getCore().byId('inBpCliente').getValue();
            var ModalidadeFrete = sap.ui.getCore().byId('inModalidadeFrete').getValue();
            var Agente = sap.ui.getCore().byId('inAgente').getValue();
            var Placa = sap.ui.getCore().byId('inPlaca').getValue();
            var InfoDanfe = sap.ui.getCore().byId('inInfoDanfe').getValue();

            let oExtApi = this.templateBaseExtension.getExtensionAPI();
            let oCtx = this.templateBaseExtension.getExtensionAPI().getSelectedContexts();



            /* =================================================================== 
            Chama Action no Behavior da CDS 
            =================================================================== */
            var fnFunction = function () {
                return new Promise(function (fnResolve, fnReject) {
                    for (let oCtx of oExtApi.getSelectedContexts()) {
                        var promises = [];
                        var promise = new Promise(function (fnRes, fnRej) {
                            that.extensionAPI.invokeActions(
                                "/gerar_retorno",
                                oCtx,
                                {
                                    InfoDanfe,
                                    Placa,
                                    Agente,
                                    ModalidadeFrete,
                                    BpCliente
                                },
                            ).then(
                                function (data) {
                                    fnRes();
                                    fnRej();
                                    that.templateBaseExtension.getExtensionAPI().refreshTable();
                                    that.getView().getModel().refresh();
                                }).catch(
                                    function (oError) {
                                        fnRej();
                                    }
                                );
                        });
                        promises.push(promise);
                    }
                    Promise.all(promises)
                        .then(function (data) {
                            fnResolve();
                            fnReject();
                            that.templateBaseExtension.getExtensionAPI().refreshTable();
                            that.getView().getModel().refresh();
                        })
                        .catch(function (oError) {
                            fnReject();
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
        onGerarRetornoArm: function (oEvent) {
            var that = this;
            // var bwart = 'Z12';
            /// Textos i18n //////////////////////////////////////////////////////////////////////////////
            var i18nTxt = that.getView().getModel("i18n").getResourceBundle();
            //////////////////////////////////////////////////////////////////////////////////////////////

            let oExtApi = this.templateBaseExtension.getExtensionAPI();
            // get the Model reference
            var oModel = this.getView().getModel();

            let oCtx = this.templateBaseExtension.getExtensionAPI().getSelectedContexts();

            // var soma = 0;

            // for (let oCtx of oExtApi.getSelectedContexts()){
            //  soma = parseFloat(soma) + parseFloat(oCtx.getObject().PerdaGanho);    
            // }
            // if(soma < 0){
            //     bwart = 'ZZ1';
            // }

            ///// Inicio da criação do POP UP
            // var oContent = new sap.ui.layout.VerticalLayout({
            //     width: '100%',
            //     content: [
            //         new sap.m.Label({ text: i18nTxt.getText("LblBpCliente") }),
            //         new sap.m.Input('inBpCliente', {
            //             width: '100%',
            //             showValueHelp: true,
            //             valueHelpRequest: () => { that.valueHelpBpCliente(that) }
            //         }),
            //         new sap.m.Label({ text: i18nTxt.getText("LblModalidadeFrete") }),
            //         new sap.m.Input('inModalidadeFrete', {
            //             width: '100%',
            //             showValueHelp: true,
            //             valueHelpRequest: () => { that.ValueHelpModalidaFrete(that) }
            //         }),
            //         new sap.m.Label({ text: i18nTxt.getText("LblAgente") }),
            //         new sap.m.Input('inAgente', {
            //             width: '100%',
            //             showValueHelp: true,
            //             valueHelpRequest: () => { that.valueHelpBpCliente2(that) }
            //         }),
            //         new sap.m.Label({ text: i18nTxt.getText("LblPlaca") }),
            //         new sap.m.Input('inPlaca', {
            //             width: '100%',
            //             showValueHelp: false
            //         })
            //     ]
            // })

            var oContent = new sap.ui.layout.VerticalLayout({
                width: '80%',
                content: [
                    new sap.m.Label({ text: "Packing Type", required: true }),
                    new sap.m.Input('packingtype', {
                        //width: '100%',
                        required: true,
                        showValueHelp: false,
                        type: "Number"
                    }),
                    new sap.m.Label({ text: "Peso da embalagem", required: true }),
                    new sap.m.Input('peso_embalagem', {
                        // width: '100%',
                        required: true,
                        showValueHelp: false,
                        type: "Number",
                    }),

                    new sap.m.Label({ text: "Peso liquido", required: true }),
                    new sap.m.Input('peso_liquido', {
                        // width: '100%',
                        showValueHelp: false,
                        type: "Number"
                    }),

                    new sap.m.Label({ text: "Quantidade", required: true }),
                    new sap.m.Input('quantidade', {
                        //width: '100%',
                        required: true,
                        showValueHelp: false,
                        type: "Number"
                    }),

                    new sap.m.Label({ text: "Código da Remessa", required: true }),
                    new sap.m.Input('codigo_remessa', {
                        //width: '100%',
                        showValueHelp: true,
                        valueHelpRequest: () => { that.ValueHelpModalidaFrete(that) },
                        type: "Text",

                    }),

                    new sap.m.CheckBox('inChex', {
                        selected: false,
                    }),

                ]
            })

            // Criar a tabela
            // var oTable = new sap.m.Table({
            //     inset: false,
            //     headerToolbar: new sap.m.Toolbar({
            //         content: [
            //             new sap.m.Title({ text: i18nTxt.getText("LblTitulo") })
            //         ]
            //     }),
            //     columns: [
            //         new sap.m.Column({
            //             header: new sap.m.Label({ text: i18nTxt.getText("LblMaterial") })
            //         }),
            //         new sap.m.Column({
            //             header: new sap.m.Label({ text: i18nTxt.getText("LblQuantidade") })
            //         }),
            //         new sap.m.Column({
            //             header: new sap.m.Label({ text: i18nTxt.getText("LblAviso") })
            //         })
            //     ]
            // });


            // Criar os itens da tabela e vincular os dados
            // var oColumnListItem = new sap.m.ColumnListItem({
            //     cells: [
            //         new sap.m.ObjectStatus({
            //             text: "{Material} - {MaterialName}",
            //             state: "{= ${PerdaGanho} < 0 ? 'Error' : 'Success' }"
            //         }),
            //         // new sap.m.Text({ text: "{MaterialName}" }),
            //         new sap.m.ObjectStatus({
            //             text: "{descarga}",
            //             state: "{= ${PerdaGanho} < 0 ? 'Error' : 'Success' }"
            //         }),
            //         // new sap.m.Text({ text: "{MaterialName}" }),
            //         new sap.m.ObjectStatus({
            //             text: "{DeliveryDocument}",
            //             state: "{= ${PerdaGanho} < 0 ? 'Error' : 'Success' }"
            //         })
            //     ]
            // });

            // oTable.bindAggregation("items", {
            //     path: "/",
            //     template: oColumnListItem
            // });

            // // Definir o modelo de dados da tabela com os dados obtidos de oCtx
            // oTable.setModel(new sap.ui.model.json.JSONModel(oCtx.map(ctx => ctx.getObject())));

            // // Envolver a tabela em um ScrollContainer para adicionar uma barra de rolagem
            // var oScrollContainer = new sap.m.ScrollContainer({
            //     vertical: true,
            //     height: "300px",
            //     content: oTable
            // });

            // oContent.addContent(oScrollContainer);
            // oContent.addContent(new sap.m.Label({ text: i18nTxt.getText("LblInfoDanfe") }));
            // oContent.addContent(new sap.m.TextArea('inInfoDanfe', {
            //     width: '100%',
            //     rows: 5, // Define a quantidade de linhas do campo de texto 
            // }));

            var pressDialog = new sap.m.Dialog({
                type: 'Message',
                title: "Gerar Etiqueta",
                resizable: false,
                draggable: true,
                titleAlignment: sap.m.TitleAlignment.Left,
                content: oContent,
                beginButton: new sap.m.Button({
                    type: sap.m.ButtonType.Emphasized,
                    text: "Gerar Etiqueta",
                    press: function () {
                        this.onPopup();
                    }.bind(this)
                }),
                endButton: new sap.m.Button({
                    text: "Cancelar",
                    press: function () {
                        pressDialog.close();
                    }
                }),
                afterClose: function () {
                    pressDialog.destroy();
                },
                contentWidth: "10%",

            });
            pressDialog.open();


            //         press: async function () {

            //             // var opdfViewer = new PDFViewer();
            //             //that.getView().addDependent(opdfViewer);
            //             // var oBusyDialog = new sap.m.BusyDialog({
            //             //     title: 'Gerando PDF...'
            //             // });
            //             // oBusyDialog.open();

            //             // Get the PDF data 
            //             var res = await that.GerarRetornoArm(oEvent);

            //             pressDialog.close();
            //             pressDialog.destroy();
            //         }
            //     }),
            //     endButton: new sap.m.Button({
            //         text: i18nTxt.getText("LblCancelar"),
            //         press: function () {
            //             pressDialog.close();
            //         }
            //     }),
            //     afterClose: function () {
            //         pressDialog.destroy();
            //     },
            //     contentWidth: "60%",

            // });
            // pressDialog.open();
        },
        Estorno: function (oEvent) {

            let oExtApi = this.templateBaseExtension.getExtensionAPI();

            let oCtx = this.templateBaseExtension.getExtensionAPI().getSelectedContexts();

            if ((oCtx.length > 1)) {
                sap.m.MessageBox.error("Selecionar apenas uma linha")
                return;
            }

            var Docnum, Bukrs, DataDocInicio, DataDocFim;

            for (let oCtx of oExtApi.getSelectedContexts()) {
                Docnum = oCtx.getObject().BR_NotaFiscal;
                Bukrs = '2000'
                DataDocInicio = "01.01.1900" //+oCtx.getObject().Ano_Material_Entrada;
                DataDocFim = "31.12.2077" //+oCtx.getObject().Ano_Material_Entrada;
            }

            var SemanticObject = "NotaFiscal";
            var Action = "monitor";
            var params = {
                Docnum,
                Bukrs,
                DataDocInicio,
                DataDocFim
            };
            this.navigateTo(SemanticObject, Action, params);
        },
        navigateTo: function (SemanticObject, Action, params) {

            /* =================================================================== 
            Verifica se usuário tem permissão para navegação 
            =================================================================== */

            sap.ushell.Container.getService("CrossApplicationNavigation").isNavigationSupported([
                { target: { shellHash: SemanticObject + "-" + Action } }
            ])
                .done(function (aResponse) {
                    aResponse.map(function (elem, index) {
                        if (elem.supported === true) {

                            /* =================================================================== 
                            Chama outro aplicativo 
                            =================================================================== */
                            var href_parameters = (sap.ushell && sap.ushell.Container &&
                                sap.ushell.Container.getService("CrossApplicationNavigation").hrefForExternal({
                                    target: { semanticObject: SemanticObject, action: Action },
                                    params: params
                                }));
                            sap.m.URLHelper.redirect(href_parameters, false);
                        }
                        else {
                            sap.m.MessageBox.warning('Usuário sem permissão para acessar o link');
                        }
                    })
                })
                .fail(function () {
                    sap.m.MessageBox.error('Falha ao acessar o link');
                });
        },
        // valueHelpMotivo: function (oEvent) {
        //     this._oInputUfDestino = oEvent;
        //     this.pWhitespaceDialog = new ValueHelpExt.valueHelpContruct(oEvent, this);
        // },
        valueHelpBpCliente: function (that) {
            this._oInputUfDestino = sap.ui.getCore().byId('inBpCliente');
            this.pWhitespaceDialog = new ValueHelpBpClienteExt.valueHelpContruct(that);
        },
        ValueHelpModalidaFrete: function (that) {
            this._oInputUfDestino = sap.ui.getCore().byId('inModalidadeFrete');
            this.pWhitespaceDialog = new ValueHelpModalidaFreteExt.valueHelpContruct(that);
        },
        valueHelpBpCliente2: function (that) {
            this._oInputUfDestino = sap.ui.getCore().byId('inAgente');
            this.pWhitespaceDialog = new ValueHelpBpClienteExt2.valueHelpContruct(that);
        },
        onValueHelpDialogOk: function (oEvent) {
            var value = this.pWhitespaceDialog.ValueHelpDialogOk(oEvent);
            this._oInputUfDestino.getSource().setValue(value);

            this.onChangeMotivo(this._oInputUfDestino);
        },
        onValueHelpDialogPopUpRetornoRemessaOk: function (oEvent) {
            var value = this.pWhitespaceDialog.ValueHelpDialogOk(oEvent);
            this._oInputUfDestino.setValue(value);
        },
        onValueHelpDialogCancel: function (oEvent) {
            this.pWhitespaceDialog.ValueHelpDialogCancel();
        },
        onFilterBarSearch: function (oEvent) {
            this.pWhitespaceDialog.Search(oEvent);
        },
        onInputSuggestionItemSelected: function (oEvent) {
            this.pWhitespaceDialog.SuggestionItemSelected(oEvent);
        },
        onInputSuggestionItemSelected2: function (oEvent) {
            this.pWhitespaceDialog.SuggestionItemSelected(oEvent);
        },
        onInputSuggestionItemSelected3: function (oEvent) {
            this.pWhitespaceDialog.SuggestionItemSelected(oEvent);
        }

    }
});