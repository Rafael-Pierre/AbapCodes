@Metadata.layer: #CORE
annotate view ZC_RPM_CUSTO_QUANTIDADE with
{

  @UI.lineItem: [ {position: 50},
   {  type: #FOR_ACTION, dataAction: 'calcular', label: 'Calcular Custo Planejado' },
   {  type: #FOR_ACTION, dataAction: 'cacular_bapi', label: 'Cálculo da BAPI' },
   {  type: #FOR_ACTION, dataAction: 'limpar_campos', label: 'Limpar Campos' }]


  @UI: { selectionField: [{ position: 20 }] }
  Material;

  @UI: { lineItem: [{ position: 40 }] }
  Item;

  @UI: { lineItem: [{ position: 10 }],
  selectionField: [{ position: 10 }] }
  Contrato;

  @UI: { lineItem: [{ position: 160 }] }
  Codigo_imp;

  @UI: { lineItem: [{ position: 20 }] }
  Fornecedor;

  @UI: { lineItem: [{ position: 180 }] }
  quantidade;

  @UI: { lineItem: [{ position: 30 }] }
  Descricao;

  @UI: { lineItem: [{ position: 60 }] }
  TextoBreve;

  @UI: { lineItem: [{ position: 70 }] }
  unidade_medida;

  @UI: { lineItem: [{ position: 290 }] }
  Data_planejado;

  @UI: { lineItem: [{ position: 280 }] }
  montante;

  @UI: { lineItem: [{ position: 270 }] }
  Condicao_Frete;

  @UI: { lineItem: [{ position: 320 }] }
  DocumentCurrency;

  @UI: { lineItem: [{ position: 140 }] }
  ConditionRateValue;

  @UI: { lineItem: [{ position: 120 }] }
  StartDate;

  @UI: { lineItem: [{ position: 130 }] }
  EndDate;

  @UI: { lineItem: [{ position: 100 }] }
  Condicoes;

  @UI: { lineItem: [{ position: 80 }] }
  Centro;

  @UI: { lineItem: [{ position: 90 }] }
  Denominacao_centro;

  @UI: { lineItem: [{ position: 150 }] }
  custo_total;

  @UI: { lineItem: [{ position: 300 }] }
  custo_final;

  @UI: { lineItem: [{ position: 190 }] }
  ipi;

  @UI: { lineItem: [{ position: 200 }] }
  vlr_ipi;

  @UI: { lineItem: [{ position: 210 }] }
  icms;

  @UI: { lineItem: [{ position: 220 }] }
  vlr_icms;

  @UI: { lineItem: [{ position: 230 }] }
  pis;

  @UI: { lineItem: [{ position: 240 }] }
  vlr_pis;

  @UI: { lineItem: [{ position: 250 }] }
  cofins;

  @UI: { lineItem: [{ position: 260 }] }
  vlr_cofins;

  @UI: { lineItem: [{ position: 110 }] }
  denominacao;

}