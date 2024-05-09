managed implementation in class zcl_rpm_custo_quantidade unique;
//strict; //Comment this line in to enable strict mode. The strict mode is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for ZI_RPM_CUSTO_QUANTIDADE2 alias custo_quantidade
persistent table zrpmt_custo_plan
lock master
authorization master ( instance )
//etag master <field_name>
{
  //  create;
  //  update;
  //  delete;

  action ( features : instance ) onQuantidade parameter ZI_RPM_AUX_QUANTIDADE;
  action ( features : instance ) onDataPick parameter ZI_RPM_AUX_QUANTIDADE;
  action ( features : instance ) calcular result [1] $self;
  action ( features : instance ) onMontante parameter ZI_RPM_AUX_QUANTIDADE;
  action ( features : instance ) limpar_campos result [1] $self;
  action ( features : instance ) cacular_bapi result [1] $self;
  action ( features : instance ) onFrete parameter ZI_RPM_AUX_QUANTIDADE;

  mapping for zrpmt_custo_plan
  {

    Material = material;
    Fornecedor = fornecedor;
  }

}