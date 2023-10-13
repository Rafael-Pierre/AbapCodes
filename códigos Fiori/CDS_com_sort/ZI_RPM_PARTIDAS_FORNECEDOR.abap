@AbapCatalog.sqlViewName: 'ZRPMR_PARTIDAS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de Interface progr. Part Fornecedor'
define root view ZI_RPM_PARTIDAS_FORNECEDOR
  as select from bsik_view as _bsik
    inner join   lfa1      as lfa1 on lfa1.lifnr = _bsik.lifnr
    inner join   t001              on  t001.bukrs = _bsik.bukrs
                                   and t001.spras = $session.system_language
{
  key  t001.bukrs,
  key  _bsik.lifnr,
  key  _bsik.belnr,
       t001.butxt,
       lfa1.name1,
       lfa1.stcd1,
       _bsik.zuonr,
       _bsik.budat,
       _bsik.gjahr,
       _bsik.buzei,
       @Semantics.currencyCode: true
       t001.waers,
       @Semantics.amount.currencyCode: 'waers'
       _bsik.dmbtr
}


//Metodo utilizando apenas inner joins
//
//define view ZI_RPM_PARTIDAS_FORNECEDOR as select from bsik_view as _bsik
//    inner join lfa1 as lfa1 on lfa1.lifnr = _bsik.lifnr
//    inner join t001         on t001.bukrs = _bsik.bukrs
//{
//key  t001.bukrs as bukrs,
//key _bsik.lifnr as lifnr,
//key _bsik.belnr as belnr,
//    t001.butxt as butxt,
//    lfa1.name1  as name1,
//    lfa1.stcd1  as stcd1,
//    _bsik.zuonr as zuonr,
//    _bsik.budat as budat,
//    _bsik.gjahr as gjahr,
//    _bsik.buzei as buzei,
//    _bsik.dmbtr as dmbtr
//}
