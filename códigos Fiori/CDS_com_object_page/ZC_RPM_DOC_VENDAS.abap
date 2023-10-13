@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de Consumo - Doc Vendas'
@Metadata.allowExtensions: true
define root view entity ZC_RPM_DOC_VENDAS
  as select from ZI_RPM_DOC_VENDAS
{
      @EndUserText.label: 'Empresa'
  key bukrs_vf,
      @EndUserText.label: 'Descrição'
      butxt,
      @EndUserText.label: 'Concatenate'
      concatenate,
      @EndUserText.label: 'Cliente'
      kunnr,
      @EndUserText.label: 'Descrição'
      name1,
      @EndUserText.label: 'Data de Criação'
      erdat,
      @EndUserText.label: 'Doc. Vendas'
      vbeln,
      @EndUserText.label: 'Item'
      posnr,
      @EndUserText.label: 'Material'
      matnr,
      @EndUserText.label: 'Descrição'
      maktx,
      @EndUserText.label: 'Grupo de Materiais'
      matkl,
      @EndUserText.label: 'Valor Líquido'
      netwr,
      @UI.hidden: true
      waerk
}
