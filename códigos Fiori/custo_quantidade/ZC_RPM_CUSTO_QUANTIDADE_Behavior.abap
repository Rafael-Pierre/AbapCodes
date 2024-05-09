projection;
//strict; //Comment this line in to enable strict mode. The strict mode is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for ZC_RPM_CUSTO_QUANTIDADE //alias <alias_name>
{
//  use create;
//  use update;
//  use delete;

  use action onQuantidade;
  use action onDataPick;
  use action calcular;
  use action onMontante;
  use action limpar_campos;
  use action cacular_bapi;
  use action onFrete;
}