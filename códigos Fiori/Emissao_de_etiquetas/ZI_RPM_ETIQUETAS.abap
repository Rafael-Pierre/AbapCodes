@AbapCatalog.sqlViewName: 'ZI_RPM_ETIQUETA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Interfac. para treinam. de Etiquetas'
define root view ZI_RPM_ETIQUETAS
  as select from ztrpm_etiquetas as _etiquetas
{
    key packaging as Packaging,
    peso_embalagem as PesoEmbalagem,
    peso_liquido as PesoLiquido,
    quantidade as Quantidade,
    codigo_remessa as CodigoRemessa,
    peso_bruto as PesoBruto
}
