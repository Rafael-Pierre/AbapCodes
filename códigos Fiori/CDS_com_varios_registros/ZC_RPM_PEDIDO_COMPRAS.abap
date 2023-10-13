@AbapCatalog.sqlViewName: 'ZC_RPM_PEDIDO_C'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de Consumo - Pedidos de Compras'
@Metadata.allowExtensions: true
@OData.publish: true
define view ZC_RPM_PEDIDO_COMPRAS
  as select from ZI_RPM_PEDIDO_COMPRAS
{
      @EndUserText.label: 'Doc. Compras'
  key PurchaseOrder,
      @EndUserText.label: 'Empresa'
      CompanyCode,
      @EndUserText.label: 'Ctg. Doc'
      PurchaseOrderCategory,
      @EndUserText.label: 'Tp. Doc.'
      PurchaseOrderType,
      @EndUserText.label: 'Dt. Criação'
      PurchaseOrderDate,
      @EndUserText.label: 'Criado Por'
      CreatedByUser,
      @EndUserText.label: 'Fornecedor'
      Supplier,
      @EndUserText.label: 'Org. Compras'
      PurchasingOrganization,
      @EndUserText.label: 'Grp. Compra'
      PurchasingGroup,
      @EndUserText.label: 'Comprador'
      SupplierRespSalesPersonName,
      @EndUserText.label: 'Cód. Liberação'
      ReleaseCode,
      @EndUserText.label: 'Incompleto'
      ReleaseIsNotCompleted,
      @EndUserText.label: 'Documento Memorizado'
      PurchasingCompletenessStatus,
      @UI.hidden: true
      DocumentCurrency,
      @EndUserText.label: 'Valor Total Dur. Liberação'
      PurgReleaseTimeTotalAmount,
      @EndUserText.label: 'Cond. Pgto.'
      PaymentTerms,
      @EndUserText.label: 'Estrat. Lib.'
      PurchasingReleaseStrategy,
      @EndUserText.label: 'Estado de Liberação'
      PurgReleaseSequenceStatus,
      @EndUserText.label: 'Item'
      PurchaseOrderItem,
      @EndUserText.label: 'Código IVA'
      TaxCode,
      @EndUserText.label: 'Val. Pedido Bruto'
      ConditionRateValue,
      @EndUserText.label: 'Texto Breve'
      PurchaseOrderItemText,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Centro'
      Plant,
      @EndUserText.label: 'Depósito'
      StorageLocation,
      @EndUserText.label: 'N° Acomp.'
      RequirementTracking,
      @EndUserText.label: 'Quantidade'
      OrderQuantity,
      @EndUserText.label: 'Um Pedido'
      PurchaseOrderQuantityUnit,
      @EndUserText.label: 'Remessa Final'
      IsCompletelyDelivered,
      @EndUserText.label: 'Fatura Final'
      IsFinallyInvoiced,
      @EndUserText.label: 'Requisitante'
      RequisitionerName,
      @EndUserText.label: 'Prz. Ent. Prev.'
      PlannedDeliveryDurationInDays,
      @EndUserText.label: 'Preço Líquido'
      PurchaseOrderNetAmount,
      @EndUserText.label: 'Data de Remessa'
      ScheduleLineDeliveryDate,
      @EndUserText.label: 'Tipo Condição'
      ConditionType,
      @EndUserText.label: 'Moeda (valor bruto)'
      ConditionCurrency,
      @EndUserText.label: 'Região'
      Region,
      @EndUserText.label: 'Data Fatura'
      DocumentDate,
      @EndUserText.label: 'Data Lançamento'
      @Consumption.filter.selectionType: #INTERVAL
      maxDate,
      @EndUserText.label: 'Referência'
      SupplierInvoiceIDByInvcgParty,
      @EndUserText.label: 'Qtd'
      QuantityInPurchaseOrderUnit,
      @UI.hidden: true
      MaterialBaseUnit,
      @EndUserText.label: 'Qtd Migo'
      QuantityInBaseUnit,
      @EndUserText.label: 'Um Pedido'
      SuplierPedido,
      @UI.hidden: true
      TransactionCurrency,
      @EndUserText.label: 'Vlr. Bruto'
      valorBruto,
      @EndUserText.label: 'Grp. Mercadorias'
      MaterialGroup,
      @EndUserText.label: 'Denom. Grp. Mercad.'
      MaterialGroupName,
      @EndUserText.label: 'Incoterms'
      IncotermsClassification
}
