@AbapCatalog.sqlViewName: 'ZRPM_VENDAS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de Intrf para programa Doc Vendas'
define root view ZI_RPM_DOC_VENDAS
  as select from    I_SalesDocumentBasic _Basic
    left outer join I_SalesDocumentItem as _vbap on _vbap.SalesDocument = _Basic.SalesDocument
    left outer join t001                         on t001.bukrs = _Basic.BillingCompanyCode
    left outer join makt                         on  makt.matnr = _vbap.Material
                                                 and makt.spras = $session.system_language
    inner join      kna1                         on kna1.kunnr = _Basic.SoldToParty
{
  key _Basic.BillingCompanyCode                                  as bukrs_vf,
      t001.butxt                                                 as butxt,
      concat(_Basic.BillingCompanyCode, concat('-',t001.butxt )) as concatenate,
      _Basic.SoldToParty                                         as kunnr,
      kna1.name1                                                 as name1,
      _Basic.CreationDate                                        as erdat,
      _Basic.SalesDocument                                       as vbeln,
      _vbap.SalesDocumentItem                                    as posnr,
      _vbap.Material                                             as matnr,
      makt.maktx                                                 as maktx,
      _vbap.MaterialGroup                                        as matkl,
      @UI: { hidden: true }
      _vbap.TransactionCurrency                                  as waerk,
      @Semantics.amount.currencyCode: 'waerk'
      _vbap.NetAmount                                            as netwr
}
