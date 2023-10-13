@AbapCatalog.sqlViewName: 'ZRPMR_CLIENTES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS para seleção de Partidas'
define root view ZI_RPM_CLIENTES
  as select from bsid_view as _bsid
  association [1..1] to I_Customer    as _Customer    on  $projection.kunnr = _Customer.Customer
  association [1..*] to I_CompanyCode as _CompanyCode on  $projection.currency  = _bsid.waers
                                                      and _CompanyCode.Language = $session.system_language
{
  key _bsid.bukrs,
  key _bsid.kunnr,
  key _bsid.buzei,
  key _bsid.belnr,
      _Customer.OrganizationBPName1,
      _Customer.TaxNumber1,
      _bsid.zuonr,
      _bsid.bldat,
      _bsid.gjahr,
      @Semantics.currencyCode: true
      _CompanyCode.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      _bsid.dmbtr

}
