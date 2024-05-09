FUNCTION zfmrpm_custo_plan
  IMPORTING
    VALUE(iv_caller) TYPE j_1btxgruop-caller OPTIONAL
    VALUE(iv_land1) TYPE land1 OPTIONAL
    VALUE(iv_shipfrom) TYPE j_1btxshpf OPTIONAL
    VALUE(iv_shipto) TYPE j_1btxshpt OPTIONAL
    VALUE(iv_validfrom) TYPE j_1btxdatf OPTIONAL
    VALUE(iv_werks) TYPE j_1bvalue OPTIONAL
    VALUE(iv_matnr) TYPE j_1bvalue2 OPTIONAL
    VALUE(iv_montante) TYPE bhwhr OPTIONAL
    VALUE(iv_lifnr) TYPE lifnr OPTIONAL
    VALUE(iv_mwskz) TYPE t007a-mwskz OPTIONAL
    VALUE(iv_bukrs) TYPE bukrs OPTIONAL
    VALUE(iv_icms_pauta) TYPE kbetr OPTIONAL
    VALUE(iv_qtde) TYPE bstmg OPTIONAL
    VALUE(iv_ncm) TYPE steuc OPTIONAL
    VALUE(iv_mtorg) TYPE j_1bmatorg OPTIONAL
    VALUE(is_tabela) TYPE zi_rpm_custo_quantidade2 OPTIONAL
    VALUE(is_table) TYPE zrpmt_custo_plan OPTIONAL.




  DATA: ls_tabela    TYPE zi_rpm_custo_quantidade2,
        ls_table     TYPE zrpmt_custo_plan,
        lv_validfrom TYPE j_1btxdatf.
  ls_tabela = is_tabela.
  ls_table = is_table.
  lv_validfrom = 99999999 - iv_validfrom.

  CALL FUNCTION 'ZMMMF_GET_IMPOSTOS' ##COMPATIBLE
    EXPORTING
      i_caller     = iv_caller
      i_land1      = iv_land1
      i_shipfrom   = iv_shipfrom
      i_shipto     = iv_shipto
      i_validfrom  = lv_validfrom
      i_werks      = iv_werks
      i_matnr      = iv_matnr
      i_montante   = iv_montante
      i_lifnr      = iv_lifnr
      i_mwskz      = iv_mwskz
      i_bukrs      = iv_bukrs
      i_qtde       = iv_qtde
      i_ncm        = iv_ncm
      i_mtorg      = iv_mtorg
    IMPORTING
      e_icms       = ls_tabela-icms
      e_pis        = ls_tabela-pis
      e_cofins     = ls_tabela-cofins
      e_ipi        = ls_tabela-ipi
      e_vlr_icms   = ls_tabela-vlr_icms
      e_vlr_pis    = ls_tabela-vlr_pis
      e_vlr_cofins = ls_tabela-vlr_cofins
      e_vlr_ipi    = ls_tabela-vlr_ipi.

  ls_tabela-custo_total = ls_tabela-conditionratevalue * ls_tabela-quantidade.
  ls_tabela-custo_final = ls_tabela-custo_total - ls_tabela-vlr_icms - ls_tabela-vlr_pis
                                     - ls_tabela-vlr_cofins.
  IF ls_tabela-Condicao_Frete IS NOT INITIAL.
    SELECT SINGLE kschl,
                  kappl,
                  krech
      FROM t685A
      INTO @DATA(ls_t685A)
      WHERE kschl = @ls_tabela-Condicao_Frete
        AND kappl = 'M'.

    IF ls_t685A-krech = 'B'.

      DATA(lv_frete) = ls_tabela-montante.
      ls_tabela-custo_final = ls_tabela-Condicao_Frete + lv_frete.
      ls_tabela-valor = lv_frete.

    ELSEIF ls_t685A-krech = 'A'.

      DATA(lv_porc) = ls_tabela-montante / 100.


      ls_tabela-valor = ls_tabela-custo_total * lv_porc.

      ls_tabela-custo_final = ls_tabela-custo_final + ls_tabela-valor.

    ELSEIF ls_t685A-krech = 'C'.

      lv_frete = ls_tabela-montante * ls_tabela-quantidade.
      ls_tabela-custo_final = ls_tabela-custo_final + lv_frete.
      ls_tabela-valor = lv_frete.

    ENDIF.
  ENDIF.

  MOVE-CORRESPONDING ls_tabela TO ls_table.

*  ls_table = VALUE #( material = ls_tabela-Material
*                      DATA = ls_tabela-Data_planejado
*                      fornecedor = ls_tabela-Fornecedor
*                      quantidade = ls_tabela-quantidade
*                      custo_total = ls_tabela-custo_total
*                      custo_final = ls_tabela-custo_final
*                      montante = ls_tabela-montante
*                      condicao_frete = ls_tabela-Condicao_Frete
*                      ipi = ls_tabela-ipi
*                      vlr_ipi = ls_tabela-vlr_ipi
*                      icms = ls_tabela-icms
*                      vlr_icms = ls_tabela-vlr_icms
*                      pis = ls_tabela-pis
*                      vlr_pis = ls_tabela-vlr_pis
*                      cofins = ls_tabela-cofins
*                      vlr_cofins = ls_tabela-vlr_cofins ).


  MODIFY zrpmt_custo_plan FROM ls_table.
  COMMIT WORK.

ENDFUNCTION.