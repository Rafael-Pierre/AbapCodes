@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Consumo campos editaveis'
@Metadata.allowExtensions: true
define root view entity ZC_RPM_CUSTO_QUANTIDADE
  provider contract transactional_query
  as projection on ZI_RPM_CUSTO_QUANTIDADE2
{
      @EndUserText.label: 'Material'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATNR', element: 'Material' } }]
  key Material,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Contrato'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EBELN', element: 'Ebeln' } }]
  key Contrato,
      @EndUserText.label: 'Cod Imp'
      Codigo_imp,
      @EndUserText.label: 'Fornecedor'
      Fornecedor,
      @EndUserText.label: 'Descrição'
      Descricao,
      @UI.hidden: true
      Usuario,
      @EndUserText.label: 'Texto Breve'
      TextoBreve,
      @EndUserText.label: 'Quantidade'
      quantidade,
      @EndUserText.label: 'UN de med'
      unidade_medida,
      @EndUserText.label: 'Data validade preço planejado'
      Data_planejado,
      @EndUserText.label: 'Montante'
      montante,
      @EndUserText.label: 'Condição Frete'
      Condicao_Frete,
      @UI.hidden: true
      ConditionRateValueUnit,
      @UI.hidden: true
      DocumentCurrency,
      @EndUserText.label: 'Montante'
      ConditionRateValue,
      @EndUserText.label: 'Val. Desde'
      StartDate,
      @EndUserText.label: 'Val até'
      EndDate,
      @EndUserText.label: 'Condições'
      Condicoes,
      @EndUserText.label: 'Centro'
      Centro,
      @EndUserText.label: 'Den.Centro'
      Denominacao_centro,
      @EndUserText.label: 'Preço total'
      custo_total,
      @EndUserText.label: 'Custo Final'
      custo_final,
      @Semantics.amount.currencyCode: 'ConditionRateValueUnit'
      @EndUserText.label: '%IPI'
      ipi,
      @EndUserText.label: 'Valor IPI'
      @Semantics.amount.currencyCode: 'ConditionRateValueUnit'
      vlr_ipi,
      @EndUserText.label: '%ICMS'
      @Semantics.amount.currencyCode: 'ConditionRateValueUnit'
      icms,
      @EndUserText.label: 'Valor ICMS'
      @Semantics.amount.currencyCode: 'ConditionRateValueUnit'
      vlr_icms,
      @EndUserText.label: '%PIS'
      @Semantics.amount.currencyCode: 'ConditionRateValueUnit'
      pis,
      @EndUserText.label: 'Valor PIS'
      @Semantics.amount.currencyCode: 'ConditionRateValueUnit'
      vlr_pis,
      @EndUserText.label: '%COFINS'
      @Semantics.amount.currencyCode: 'ConditionRateValueUnit'
      cofins,
      @EndUserText.label: 'Valor COFINS'
      @Semantics.amount.currencyCode: 'ConditionRateValueUnit'
      vlr_cofins,
      @EndUserText.label: 'Denominação'
      denominacao


}
