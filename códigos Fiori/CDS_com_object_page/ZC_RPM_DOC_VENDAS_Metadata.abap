@Metadata.layer: #CORE
@UI.headerInfo.typeNamePlural: 'Relatório de Partidas'
@UI.presentationVariant:[{
sortOrder: [
{ by: 'vbeln' }],
groupBy: [ 'vbeln' ],
visualizations: [{ type: #AS_LINEITEM }],
requestAtLeast: ['vbeln']
}]
annotate view ZC_RPM_DOC_VENDAS with
{
  @UI: { lineItem: [{ position: 10 }] ,
  selectionField: [{ position: 10 }] }
  bukrs_vf;

  @UI: { lineItem: [{ position: 20 }] }
  butxt;

  @UI: { lineItem: [{ position: 30 }] }
  concatenate;

  @UI: { lineItem: [{ position: 40 }],
   selectionField: [{ position: 20 }]}
  kunnr;
  @UI: { lineItem: [{ position: 50 }] }
  name1;

  @UI: { lineItem: [{ position: 60 }] ,
    selectionField: [{ position: 50 }] }
  erdat;

  @UI: { lineItem: [{ position: 70 }] }
  vbeln;

  @UI: { lineItem: [{ position: 80 }] }
  posnr;

  @UI: { lineItem: [{ position: 90 }] ,
    selectionField: [{ position: 30 }] }
  matnr;

  @UI: { lineItem: [{ position: 100 }] }
  maktx;

  @UI: { lineItem: [{ position: 110 }] ,
    selectionField: [{ position: 40 }] }
  matkl;

  @UI: { lineItem: [{ position: 120 }] }
  netwr;

}