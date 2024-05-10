@EndUserText.label: 'Custom Entity para Etiquetas treinamento'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define custom entity ZC_RPM_ETIQUETA_CE with parameters
    packingtype    : char40,
    peso_embalagem : char5,
    quantidade     : char5,
    peso_liquido   : char5,
    codigo_remessa : char10,
    checkbox       : ze_rda_check
{
    key stream_data : ze_rda_rawstring;
}
