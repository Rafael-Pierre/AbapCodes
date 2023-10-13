@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de consumo - Partidas Fornecedor'
@Metadata.allowExtensions: true

define root view entity ZC_RPM_PARTIDAS_FORNECEDOR
  as projection on ZI_RPM_PARTIDAS_FORNECEDOR
{
  @EndUserText.label: 'Cod. Empresa'  
  key bukrs,
       @EndUserText.label: 'Fornecedor'
  key lifnr,
      @EndUserText.label: 'Documento'
  key belnr,
      @EndUserText.label: 'Empresa'
      butxt,
      @EndUserText.label: 'Razão Social'
      name1,
      @EndUserText.label: 'CNPJ'    
      stcd1,
      zuonr,
       @EndUserText.label: 'Data Lançamento'
      budat,
       @EndUserText.label: 'Ano'
      gjahr,
      buzei,
      @UI.hidden: true
      waers,
       @EndUserText.label: 'Valor'
       @Aggregation.default: #SUM
      dmbtr
}
