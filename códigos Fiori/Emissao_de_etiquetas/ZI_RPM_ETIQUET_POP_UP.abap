@EndUserText.label 'Value Help para o pop up'
define abstract entity ZI_RPM_ETIQUET_POP_UP
{
      @EndUserText.label 'Packaging type'
  key codigo          char40;
      @EndUserText.label 'Peso da embalagem'
      pesoEmbalagem   char5;

      @EndUserText.label 'Peso Líquido'
      peso_liquido    char5;

      @EndUserText.label 'Quantidade'
      quantidade      char5;

      @EndUserText.label 'Código da Remessa'
      @Consumption.valueHelpDefinition [{ entity{ name 'ZI_RDA_VH_REMESSA', element 'codRemessa' }, additionalBinding [{ localElement 'id',  element 'OutboundDeliveryItem'}]}]
      codido_remessa  char10;

      @EndUserText.label 'Id teste'
      @UI.hidden      true
      id              numc06;

      @EndUserText.label ''''
      @UI.textArrangement #TEXT_FIRST
      campo_check     ze_rda_check;

}
