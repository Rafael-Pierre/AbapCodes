@AbapCatalog.sqlViewName: 'ZRPMR_PEDIDO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de Interface - Pedido de compras'
define root view ZI_RPM_PEDIDO_COMPRAS
  as select from    I_PurchaseOrder                as _PurchaseOrder
    left outer join I_PurchaseOrderItem            as _Item         on _PurchaseOrder.PurchaseOrder = _Item.PurchaseOrder
    left outer join I_PurchaseOrderPricingElement  as _Pricing      on _PurchaseOrder.PurchaseOrder = _Pricing.PurchaseOrder
    left outer join I_CentralPurchaseOrder         as _Central      on _PurchaseOrder.PurchaseOrder = _Central.PurchaseOrder
    left outer join I_PurOrdScheduleLineAPI01      as _Schedule     on _PurchaseOrder.PurchaseOrder = _Schedule.PurchaseOrder
    left outer join I_BusinessPartnerAddress       as _Partner      on _PurchaseOrder.Supplier = _Partner.BusinessPartner
    left outer join I_SupplierInvoice              as _Supplier     on _PurchaseOrder.Supplier = _Supplier.InvoicingParty
    left outer join I_SupplierInvoiceItemPurOrdRef as _Supplieritem on _PurchaseOrder.PurchaseOrder = _Supplieritem.PurchaseOrder
    left outer join C_PurchaseOrderGoodsReceipt    as _Order        on _PurchaseOrder.PurchaseOrder = _Order.PurchaseOrder
    left outer join I_MaterialGroupText            as _Material     on _PurchaseOrder.Language = _Material.Language
{
  key _PurchaseOrder.PurchaseOrder,
      _PurchaseOrder.CompanyCode,
      _Item.PurchaseOrderCategory,
      _PurchaseOrder.PurchaseOrderType,
      _PurchaseOrder.PurchaseOrderDate,
      _PurchaseOrder.CreatedByUser,
      _PurchaseOrder.Supplier,
      _PurchaseOrder.PurchasingOrganization,
      _PurchaseOrder.PurchasingGroup,
      _PurchaseOrder.SupplierRespSalesPersonName,
      _PurchaseOrder.ReleaseCode,
      _PurchaseOrder.ReleaseIsNotCompleted,
      _PurchaseOrder.PurchasingCompletenessStatus,
      @Semantics.currencyCode:true
      _PurchaseOrder.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      _PurchaseOrder.PurgReleaseTimeTotalAmount,
      _PurchaseOrder.PaymentTerms,
      _PurchaseOrder.PurchasingReleaseStrategy,
      _PurchaseOrder.PurgReleaseSequenceStatus,
      _Item.PurchaseOrderItem,
      _Item.TaxCode,
      _Pricing.ConditionRateValue,
      _Item.PurchaseOrderItemText,
      _Item.Material,
      _Item.Plant,
      _Item.StorageLocation,
      _Item.RequirementTracking,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      _Item.OrderQuantity,
      _Item.PurchaseOrderQuantityUnit,
      _Item.IsCompletelyDelivered,
      _Item.IsFinallyInvoiced,
      _Item.RequisitionerName,
      _Item.PlannedDeliveryDurationInDays,
      _Central.PurchaseOrderNetAmount,
      _Schedule.ScheduleLineDeliveryDate,
      _Pricing.ConditionType,
      _Pricing.ConditionCurrency,
      //  _Pricing.ConditionAmount,
      _Partner.Region,
      _Supplier.DocumentDate,
      max(_Supplier.PostingDate)              as maxDate,
      _Supplier.SupplierInvoiceIDByInvcgParty,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      _Supplieritem.QuantityInPurchaseOrderUnit,
      @Semantics.unitOfMeasure: true
      _Order.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation: #NONE
      _Order.QuantityInBaseUnit,
      _Supplieritem.PurchaseOrderQuantityUnit as SuplierPedido,
      @Semantics.unitOfMeasure: true
      _Pricing.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _Pricing.ConditionAmount                as valorBruto,
      _Item.MaterialGroup,
      _Material.MaterialGroupName,
      _Item.IncotermsClassification
}
group by
  _PurchaseOrder.PurchaseOrder,
  _PurchaseOrder.CompanyCode,
  _Item.PurchaseOrderCategory,
  _PurchaseOrder.PurchaseOrderType,
  _PurchaseOrder.CreatedByUser,
  _PurchaseOrder.Supplier,
  _PurchaseOrder.PurchasingOrganization,
  _PurchaseOrder.PurchasingGroup,
  _PurchaseOrder.SupplierRespSalesPersonName,
  _PurchaseOrder.ReleaseCode,
  _PurchaseOrder.ReleaseIsNotCompleted,
  _PurchaseOrder.PurchasingCompletenessStatus,
  _PurchaseOrder.DocumentCurrency,
  _PurchaseOrder.PurgReleaseTimeTotalAmount,
  _PurchaseOrder.PaymentTerms,
  _PurchaseOrder.PurchasingReleaseStrategy,
  _PurchaseOrder.PurgReleaseSequenceStatus,
  _Item.PurchaseOrderItem,
  _Item.TaxCode,
  _Pricing.ConditionRateValue,
  _Item.PurchaseOrderItemText,
  _Item.Material,
  _Item.Plant,
  _Item.StorageLocation,
  _Item.RequirementTracking,
  _Item.OrderQuantity,
  _Item.PurchaseOrderQuantityUnit,
  _Item.IsCompletelyDelivered,
  _Item.IsFinallyInvoiced,
  _Item.RequisitionerName,
  _Item.PlannedDeliveryDurationInDays,
  _Central.PurchaseOrderNetAmount,
  _Schedule.ScheduleLineDeliveryDate,
  _Pricing.ConditionType,
  _Pricing.ConditionCurrency,
  _Partner.Region,
  _Supplier.DocumentDate,
  _Supplier.SupplierInvoiceIDByInvcgParty,
  _Supplieritem.QuantityInPurchaseOrderUnit,
  _Order.MaterialBaseUnit,
  _Order.QuantityInBaseUnit,
  _Supplieritem.PurchaseOrderQuantityUnit,
  _Pricing.TransactionCurrency,
  _Pricing.ConditionAmount,
  _Item.MaterialGroup,
  _Material.MaterialGroupName,
  _Item.IncotermsClassification,
  _PurchaseOrder.PurchaseOrderDate
