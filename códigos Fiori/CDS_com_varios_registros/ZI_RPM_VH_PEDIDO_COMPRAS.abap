@AbapCatalog.sqlViewName: 'ZRPM_VH_PEDIDO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Intrf. Value Help Pedido Compras'
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view ZI_RPM_VH_PEDIDO_COMPRAS
  as select from I_PurchaseOrderItem as _Item
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Value Help - Nº Material'
  key _Item.Material
}
where Material is not initial
group by Material
