
@Metadata.layer: #CORE
@UI.headerInfo.typeNamePlural: 'Relatório de Materiais'
@UI.presentationVariant: [{
    sortOrder: [ { by: 'lifnr'} ], 
    
    groupBy: [ 'lifnr' ]
 }]


annotate view ZC_RPM_PARTIDAS_FORNECEDOR
    with 
{
    @UI: { lineItem: [{ position: 10 }] ,
    selectionField: [{ position: 10 }] }
    bukrs;

    @UI: { lineItem: [{ position: 20 }] }
    butxt;
    
    @UI: { lineItem: [{ position: 25 }] ,
    selectionField: [{ position: 15 }] }
    lifnr;
    

    @UI: { lineItem: [{ position: 30 }] }
    name1;
    
    @UI: { lineItem: [{ position: 40 }] }
    stcd1;
    
    @UI: { lineItem: [{ position: 50 }] }
    zuonr;
    
    @UI: { lineItem: [{ position: 60 }],
    selectionField: [{ position: 20 }] }
    budat;

    @UI: { lineItem: [{ position: 70 }] }
    gjahr;

    @UI: { lineItem: [{ position: 80 }] }
    belnr;

    @UI: { lineItem: [{ position: 90 }] }
    buzei;
    
    @UI: { lineItem: [{ position: 100 }] }
    dmbtr;
}