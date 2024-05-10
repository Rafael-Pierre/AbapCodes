@EndUserText.label : 'Tabela para etiquetas treinamento'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #ALLOWED
define table ztrpm_etiquetas {
  key mandt      : mandt not null;
  key packaging  : char40 not null;
  peso_embalagem : char5;
  peso_liquido   : char5;
  quantidade     : char5;
  codigo_remessa : char10;
  peso_bruto     : char5;

}