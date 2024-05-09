CLASS lcl_ZI_RPM_CUSTO_QUANTIDADE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR custo_quantidade RESULT result.

    METHODS ondatapick FOR MODIFY
      IMPORTING keys FOR ACTION custo_quantidade~ondatapick.

    METHODS onquantidade FOR MODIFY
      IMPORTING keys FOR ACTION custo_quantidade~onquantidade.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR custo_quantidade RESULT result.
    METHODS calcular FOR MODIFY
      IMPORTING keys FOR ACTION custo_quantidade~calcular RESULT result.

    METHODS limpar_campos FOR MODIFY
      IMPORTING keys FOR ACTION custo_quantidade~limpar_campos RESULT result.

    METHODS onmontante FOR MODIFY
      IMPORTING keys FOR ACTION custo_quantidade~onmontante.
    METHODS cacular_bapi FOR MODIFY
      IMPORTING keys FOR ACTION custo_quantidade~cacular_bapi RESULT result.
    METHODS onfrete FOR MODIFY
      IMPORTING keys FOR ACTION custo_quantidade~onfrete.

ENDCLASS.

CLASS lcl_ZI_RPM_CUSTO_QUANTIDADE IMPLEMENTATION.

  METHOD get_instance_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD onDataPick.
    DATA ls_tabela TYPE zrpmt_custo_plan.

    READ ENTITIES OF zi_rpm_custo_quantidade2 IN LOCAL MODE
    ENTITY custo_quantidade
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_tabela).

    READ TABLE lt_tabela INTO DATA(ls_table) INDEX 1.
    MOVE-CORRESPONDING ls_table TO ls_tabela.

    ls_tabela-data_planejado = keys[ 1 ]-%param-Pricingdate.

    MODIFY zrpmt_custo_plan FROM ls_tabela.

  ENDMETHOD.

  METHOD onQuantidade.

    DATA ls_tabela TYPE zrpmt_custo_plan.

    READ ENTITIES OF zi_rpm_custo_quantidade2 IN LOCAL MODE
     ENTITY custo_quantidade
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_tabela).

    READ TABLE lt_tabela INTO DATA(ls_table) INDEX 1.
    MOVE-CORRESPONDING ls_table TO ls_tabela.

    ls_tabela-quantidade = keys[ 1 ]-%param-quantidade_total.

    ls_tabela-custo_total = ls_table-ConditionRateValue * keys[ 1 ]-%param-quantidade_total .


    MODIFY zrpmt_custo_plan FROM ls_tabela.

  ENDMETHOD.

  METHOD get_instance_features.
    RETURN.
  ENDMETHOD.

  METHOD calcular.

    DATA ls_tabela TYPE zrpmt_custo_plan.

    DATA: ls_caller      TYPE j_1btxgruop,
          lv_quantidade  TYPE bstmg,
          lv_data        TYPE j_1btxdatf,
          lv_werks       TYPE j_1bvalue,
          lv_matnr       TYPE j_1bvalue2,
          lv_plndprdate1 TYPE ztmm_cust_plan-plndprdate1,
          lv_montante    TYPE bhwhr.

    READ ENTITIES OF zi_rpm_custo_quantidade2 IN LOCAL MODE
   ENTITY custo_quantidade
   ALL FIELDS WITH CORRESPONDING #( keys )
   RESULT DATA(lt_tabela).

    READ TABLE lt_tabela INTO DATA(ls_table) INDEX 1.

    SELECT SINGLE regio
    INTO  @DATA(lv_regio)
    FROM t001w
    WHERE werks = @ls_table-Centro.

    CALL FUNCTION 'ZFMRPM_CUSTO_PLAN'
      STARTING NEW TASK 'COMMIT'
      EXPORTING
        iv_caller    = ls_caller-caller
        iv_land1     = 'BR'
        iv_shipfrom  = ls_table-region
        iv_shipto    = lv_regio
        iv_validfrom = sy-datum
        iv_werks     = ls_table-Centro
        iv_matnr     = ls_table-Material
        iv_montante  = ls_table-montante
        iv_lifnr     = ls_table-Fornecedor
        iv_mwskz     = ls_table-Codigo_imp
        iv_bukrs     = ls_table-CompanyCode
*       iv_icms_pauta =
        iv_qtde      = ls_table-quantidade
        iv_ncm       = ls_table-steuc
        iv_mtorg     = ls_table-mtuse
        is_tabela    = ls_table
        is_table     = ls_tabela.

  ENDMETHOD.

  METHOD limpar_campos.

    DATA: lt_dados TYPE TABLE OF zrpmt_custo_plan,
          ls_dados LIKE LINE OF lt_dados.

    READ ENTITIES OF zi_rpm_custo_quantidade2 IN LOCAL MODE
     ENTITY custo_quantidade
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_tabela).


    READ TABLE lt_tabela INTO DATA(ls_table) INDEX 1.

    IF ls_table-quantidade <> 0 OR ls_table-montante <> 0 OR ls_table-Data_planejado IS NOT INITIAL OR ls_table-Condicao_Frete IS NOT INITIAL .

      MOVE-CORRESPONDING ls_table TO ls_dados.

      DELETE FROM zrpmt_custo_plan WHERE material = ls_dados-material.

    ELSE.

      reported-custo_quantidade = VALUE #( ( %msg = new_message( id       = 'ZRPM_CAMPOS_EDITAV'
                                                        number   = '001'
                                                        severity = if_abap_behv_message=>severity-error ) ) ).

    ENDIF.


  ENDMETHOD.

  METHOD onMontante.
    DATA ls_tabela TYPE zrpmt_custo_plan.

    READ ENTITIES OF zi_rpm_custo_quantidade2 IN LOCAL MODE
    ENTITY custo_quantidade
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_tabela).

    READ TABLE lt_tabela INTO DATA(ls_table) INDEX 1.
    MOVE-CORRESPONDING ls_table TO ls_tabela.

    ls_tabela-montante = keys[ 1 ]-%param-Valor_Montante.

    MODIFY zrpmt_custo_plan FROM ls_tabela.
  ENDMETHOD.

  METHOD cacular_bapi.

    CONSTANTS: lc_class_message  TYPE symsgid VALUE 'ZRPM_CAMPOS_EDITAV',
               lc_class_number   TYPE symsgno VALUE '004',
               lc_class_number_6 TYPE symsgno VALUE '006'.

    DATA:lt_tabela TYPE TABLE OF zi_rpm_custo_quantidade2,
         lt_clear  TYPE TABLE OF zrpmt_custo_plan.

    DATA: ls_tabela        TYPE zrpmt_custo_plan,
          ls_headdata      TYPE bapimathead,
          ls_valuationdata TYPE bapi_mbew,
          ls_table         TYPE zrpmt_custo_plan,
          ls_clear         TYPE zrpmt_custo_plan.

    DATA: lr_material TYPE RANGE OF matnr,
          lr_contrato TYPE RANGE OF ebeln,
          lr_hora     TYPE RANGE OF syuzeit,
          lr_data     TYPE RANGE OF dats.


    READ ENTITIES OF zi_rpm_custo_quantidade2 IN LOCAL MODE
    ENTITY custo_quantidade
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_tabela2).

    READ TABLE lt_tabela2 INTO DATA(ls_tabela2) INDEX 1.
    MOVE-CORRESPONDING ls_table TO ls_tabela.


    IF ls_tabela2-ipi IS INITIAL OR ls_tabela2-pis IS INITIAL OR ls_tabela2-icms IS INITIAL OR ls_tabela2-cofins IS INITIAL.


      reported-custo_quantidade = VALUE #( ( %msg = new_message( id       = lc_class_message
                                                            number   = lc_class_number
                                                            severity = if_abap_behv_message=>severity-error ) ) ).

      EXIT.
    ENDIF.

    ls_headdata-material = ls_tabela2-Material.
    ls_headdata-cost_view = 'X'.
    ls_headdata-ind_sector = 'M'.
    ls_headdata-matl_type = 'ZRST'.
    ls_valuationdata-val_area = ls_tabela2-custo_final.
    ls_valuationdata-plndprice1 = 1000.
    ls_valuationdata-plndprdate1 = ls_tabela2-Data_planejado.


    MOVE-CORRESPONDING ls_tabela2 TO ls_table.

    CALL FUNCTION 'ZFMRPM_CUSTO_PLAN_BAPI'
      STARTING NEW TASK 'COMMIT'
      EXPORTING
        is_headdata      = ls_headdata
        is_valuationdata = ls_valuationdata
        is_tabela        = ls_table.

    reported-custo_quantidade = VALUE #( ( %msg = new_message( id       = lc_class_message
                                                               number   = lc_class_number_6
                                                               severity = if_abap_behv_message=>severity-success ) ) ).

  ENDMETHOD.

  METHOD onFrete.
    DATA ls_tabela TYPE zrpmt_custo_plan.

    READ ENTITIES OF zi_rpm_custo_quantidade2 IN LOCAL MODE
    ENTITY custo_quantidade
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_tabela).

    READ TABLE lt_tabela INTO DATA(ls_table) INDEX 1.
    MOVE-CORRESPONDING ls_table TO ls_tabela.

    ls_tabela-condicao_frete = keys[ 1 ]-%param-Frete.

    MODIFY zrpmt_custo_plan FROM ls_tabela.

  ENDMETHOD.

ENDCLASS.