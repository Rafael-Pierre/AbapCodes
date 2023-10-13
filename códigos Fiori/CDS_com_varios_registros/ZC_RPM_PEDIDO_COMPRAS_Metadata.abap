@Metadata.layer: #CORE
@UI.headerInfo: {

    typeName: 'Pedido de compra - Object Page',

    typeNamePlural: 'Pedido de compras - Object Page',

    title: { value: 'PurchaseOrder', type: #STANDARD},

    description: { value: 'PurchaseOrderItemText', type: #STANDARD }

}
annotate view ZC_RPM_PEDIDO_COMPRAS with
{
  @UI.facet: [
    {
      label: 'Informações do Pedido',
      id: 'GeneralInfo',
      type: #COLLECTION,
      position: 10   },
    {
      label: 'Dados',
      id: 'MaterialGroup',
      type: #IDENTIFICATION_REFERENCE,
      purpose: #STANDARD,
      parentId: 'GeneralInfo',
      position: 10
    }
  ]


  @UI: { lineItem: [{ position: 10 }],
  selectionField: [{ position: 10 }] }
  @UI.identification: [{ position: 10 }]
  PurchaseOrder;
  @UI: { lineItem: [{ position: 20 }],
  selectionField: [{ position: 40 }] }
  @UI.identification: [{ position: 20 }]
  CompanyCode;
  @UI: { lineItem: [{ position: 30 }] }
  PurchaseOrderCategory;
  @UI: { lineItem: [{ position: 40 }],
  selectionField: [{ position: 30 }] }
  PurchaseOrderType;
  @UI: { lineItem: [{ position: 50 }] }
  PurchaseOrderDate;
  @UI: { lineItem: [{ position: 60 }],
  selectionField: [{ position: 90 }] }
  CreatedByUser;
  @UI: { lineItem: [{ position: 70 }],
  selectionField: [{ position: 120 }] }
  Supplier;
  @UI: { lineItem: [{ position: 80 }] }
  PurchasingOrganization;
  @UI: { lineItem: [{ position: 90 }],
  selectionField: [{ position: 60 }] }
  @UI.identification: [{ position: 30 }]
  PurchasingGroup;
  @UI: { lineItem: [{ position: 100 }],
  selectionField: [{ position: 100 }] }
  SupplierRespSalesPersonName;
  @UI: { lineItem: [{ position: 110 }] }
  ReleaseCode;
  @UI: { lineItem: [{ position: 120 }] }
  ReleaseIsNotCompleted;
  @UI: { lineItem: [{ position: 130 }] }
  PurchasingCompletenessStatus;
  @UI: { lineItem: [{ position: 140 }] }
  PurgReleaseTimeTotalAmount;
  @UI: { lineItem: [{ position: 150 }] }
  PaymentTerms;
  @UI: { lineItem: [{ position: 160 }] }
  PurchasingReleaseStrategy;
  @UI: { lineItem: [{ position: 170 }] }
  PurgReleaseSequenceStatus;
  @UI: { lineItem: [{ position: 180 }] }
  PurchaseOrderItem;
  @UI: { lineItem: [{ position: 190 }] }
  TaxCode;
  @UI: { lineItem: [{ position: 200 }] }
  ConditionRateValue;
  @UI: { lineItem: [{ position: 210 }] }
  PurchaseOrderItemText;
  @UI: { lineItem: [{ position: 220 }],
  selectionField: [{ position: 130 }] }
  @Consumption.valueHelpDefinition: [{
    entity:{ name: 'ZI_RPM_VH_PEDIDO_COMPRAS', element: 'Material'  } }]
  @UI.identification: [{ position: 40 }]
  Material;
  @UI: { lineItem: [{ position: 230 }],
  selectionField: [{ position: 50 }] }
  @UI.identification: [{ position: 60 }]
  Plant;
  @UI: { lineItem: [{ position: 240 }],
  selectionField: [{ position: 140 }] }
  StorageLocation;
  @UI: { lineItem: [{ position: 250 }] }
  RequirementTracking;
  @UI: { lineItem: [{ position: 260 }] }
  OrderQuantity;
  @UI: { lineItem: [{ position: 270 }] }
  PurchaseOrderQuantityUnit;
  @UI: { lineItem: [{ position: 280 }] }
  IsCompletelyDelivered;
  @UI: { lineItem: [{ position: 290 }] }
  IsFinallyInvoiced;
  @UI: { lineItem: [{ position: 300 }],
  selectionField: [{ position: 110 }] }
  RequisitionerName;
  @UI: { lineItem: [{ position: 310 }] }
  PlannedDeliveryDurationInDays;
  @UI: { lineItem: [{ position: 320 }] }
  PurchaseOrderNetAmount;
  @UI: { lineItem: [{ position: 330 }],
  selectionField: [{ position: 80 }] }
  ScheduleLineDeliveryDate;
  @UI: { lineItem: [{ position: 340 }] }
  ConditionType;
  @UI: { lineItem: [{ position: 350 }] }
  ConditionCurrency;
  @UI: { lineItem: [{ position: 360 }] }
  Region;
  @UI: { lineItem: [{ position: 370 }] }
  DocumentDate;
  @UI: { lineItem: [{ position: 380 }],
  selectionField: [{ position: 20 }] }
  maxDate;
  @UI: { lineItem: [{ position: 390 }] }
  SupplierInvoiceIDByInvcgParty;
  @UI: { lineItem: [{ position: 400 }] }
  QuantityInPurchaseOrderUnit;
  @UI: { lineItem: [{ position: 410 }] }
  QuantityInBaseUnit;
  @UI: { lineItem: [{ position: 420 }] }
  SuplierPedido;
  @UI: { lineItem: [{ position: 430 }] }
  valorBruto;
  @UI: { lineItem: [{ position: 440 }],
  selectionField: [{ position: 70 }] }
  @UI.identification: [{ position: 50 }]
  MaterialGroup;
  @UI: { lineItem: [{ position: 450 }] }
  MaterialGroupName;
  @UI: { lineItem: [{ position: 460 }] }
  IncotermsClassification;

}