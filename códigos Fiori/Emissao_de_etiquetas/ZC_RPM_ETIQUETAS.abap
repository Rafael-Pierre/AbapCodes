@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Consumo treinamento de Etiquetas'
@Metadata.allowExtensions: true
define root view entity ZC_RPM_ETIQUETAS
provider contract transactional_query
  as projection on ZI_RPM_ETIQUETAS
{
      @EndUserText.label: 'Código da embalagem'
  key Packaging,
      @EndUserText.label: 'Peso da embalagem'
      PesoEmbalagem,
      @EndUserText.label: 'Peso líquido (Net)'
      PesoLiquido,
      @EndUserText.label: 'Quantidade'
      Quantidade,
      @EndUserText.label: 'Codigo remessa'
      CodigoRemessa,
      @EndUserText.label: 'Peso bruto'
      PesoBruto
}
