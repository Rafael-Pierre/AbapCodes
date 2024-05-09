@AbapCatalog.sqlViewName: 'ZI_RPM_CUSTO_QU'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Interface campos Editaveis'
@AbapCatalog.preserveKey: true
define root view ZI_RPM_CUSTO_QUANTIDADE2
  as select from zrpmt_fornecedor as _fornecedor


  association [1..1] to I_PurchaseContractItem      as _PurchaseContractItem on  _fornecedor.material = _PurchaseContractItem.Material
                                                                             and _fornecedor.item     = _PurchaseContractItem.PurchaseContractItem
                                                                             and _fornecedor.contrato = _PurchaseContractItem.PurchaseContract


  association [1..1] to I_PurchaseContract          as _PurchaseContract     on  _PurchaseContract.PurchaseContract = _fornecedor.contrato

  association [1..1] to I_Supplier                  as _Supplier             on  _fornecedor.fornecedor = _Supplier.Supplier

  association [1..*] to t685t                       as _condtext             on  _condtext.kschl = 'PB00'
                                                                             and _condtext.spras = $session.system_language
                                                                             and _condtext.kappl = 'V'


  association [1..1] to ZI_RPM_AUX_MARC_MBEW        as _Marc_mbew            on  _fornecedor.material = _Marc_mbew.Material
                                                                             and _fornecedor.item     = _Marc_mbew.PurchaseContractItem
                                                                             and _fornecedor.contrato = _Marc_mbew.PurchaseContract

  association [1..1] to zrpmt_custo_plan            as _custo                on  _custo.material   = _fornecedor.material
                                                                             and _custo.fornecedor = _fornecedor.fornecedor

  association [1..1] to ZI_RPM_AUX_CUSTO_QUANTIDADE as _aux                  on  _aux.PurchaseContract     = _fornecedor.contrato
                                                                             and _aux.PurchaseContractItem = _fornecedor.item

{

  key           _PurchaseContractItem.Material                 as Material,
  key           _PurchaseContractItem.PurchaseContractItem     as Item,
  key           _PurchaseContractItem.PurchaseContract         as Contrato,
                _PurchaseContractItem.TaxCode                  as Codigo_imp,
                _PurchaseContract.Supplier                     as Fornecedor,
                _Supplier.SupplierName                         as Descricao,
                _fornecedor.usuario                            as Usuario,
                _PurchaseContractItem.PurchaseContractItemText as TextoBreve,
                _custo.quantidade                              as quantidade,
                _PurchaseContractItem.OrderQuantityUnit        as unidade_medida,
                _custo.data_planejado                          as Data_planejado,
                _custo.montante                                as montante,
                _custo.condicao_frete                          as Condicao_Frete,
                _aux.ConditionRateValueUnit,
                _PurchaseContract.DocumentCurrency,
                @Semantics.amount.currencyCode: 'DocumentCurrency'
                _aux.montante                                  as ConditionRateValue,
                _aux.StartDate                                 as StartDate,
                _aux.EndDate                                   as EndDate,
                _aux.ConditionType                             as Condicoes,
                _aux._ContractItem.Plant                       as Centro,
                _aux._ContractItem._Plant.PlantName            as Denominacao_centro,
                _custo.custo_total                             as custo_total,
                _custo.custo_final                             as custo_final,
                _custo.kwert                                   as valor,
                _custo.ipi                                     as ipi,
                _custo.vlr_ipi                                 as vlr_ipi,
                _custo.icms                                    as icms,
                _custo.vlr_icms                                as vlr_icms,
                _custo.pis                                     as pis,
                _custo.vlr_pis                                 as vlr_pis,
                _custo.cofins                                  as cofins,
                _custo.vlr_cofins                              as vlr_cofins,
                _condtext.vtext                                as denominacao,
                _Supplier.Region                               as region,
                _PurchaseContractItem.CompanyCode              as CompanyCode,
                _Marc_mbew.steuc                               as steuc,
                _Marc_mbew.mtuse                               as mtuse


}
