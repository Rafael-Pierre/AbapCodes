@EndUserText.label : 'Estrutura para etiquetas treinamento'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
define structure zsrpm_etiquetas {
  codigo             : char10;
  item               : numc06;
  nome_cliente       : char50;
  rua                : char50;
  cidade             : char50;
  regiao             : char50;
  cep                : char50;
  planta             : knref;
  pedido_compra      : bstkd;
  descricao_item     : text40;
  material_cliente   : char35;
  material_descricao : char50;
  data               : dats;
  qtd_remessa        : char5;
  peso_bruto         : char5;
  peso_liquido       : char5;
  codigo_barra       : char50;
  codigo_barra_txt   : char50;
  qrcode             : char200;

}