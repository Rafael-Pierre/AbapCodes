*&---------------------------------------------------------------------*
*& Include zrpmi_relatorio_bapi_imp
*&---------------------------------------------------------------------*

CLASS lcl_main IMPLEMENTATION.


  METHOD m_main.
    me->m_executa_bapi(  ).
    me->m_cria_alv(  ).
  ENDMETHOD.

  METHOD m_executa_bapi.

    DATA: lv_h TYPE string .

    DATA: lv_hora    TYPE i,
          lv_minuto  TYPE num02,
          lv_segundo TYPE num02.

    DATA: lt_order_data       TYPE STANDARD TABLE OF bapi_order_header1,
          lv_production_order TYPE aufnr,
          lt_return           TYPE TABLE OF bapiret2,
          lv_hours_string     TYPE char1 VALUE '0',
          lv_formatted_time   TYPE string.

    gs_order_objects-header         =  abap_true.
    gs_order_objects-positions      =  abap_true.
    gs_order_objects-sequences      =  abap_true.
    gs_order_objects-operations     =  abap_true.
    gs_order_objects-components     =  abap_true.
    gs_order_objects-prod_rel_tools =  abap_true.
    gs_order_objects-trigger_points =  abap_true.
    gs_order_objects-suboperations  =  abap_true.


    CALL FUNCTION 'BAPI_PRODORD_GET_DETAIL'
      EXPORTING
        number        = p_ordem
        order_objects = gs_order_objects
      TABLES
        header        = gt_header
        component     = gt_component
        operation     = gt_operation
        prod_rel_tool = gt_prod_rel_tool.


    READ TABLE gt_component ASSIGNING FIELD-SYMBOL(<fs_component_index1>) INDEX 1.
    READ TABLE gt_operation  ASSIGNING FIELD-SYMBOL(<fs_operation_index1>)  INDEX 1.

    IF gt_mara IS INITIAL AND gt_component IS NOT INITIAL.
      SELECT SINGLE
             matnr
        FROM mara
        INTO gs_mara
       WHERE matnr = <fs_component_index1>-material.
      APPEND gs_mara TO gt_mara.

    ENDIF.

    IF gt_mara IS NOT INITIAL.

      SELECT                                       "#EC CI_EMPTY_SELECT
             matnr,
             maktx
        FROM makt
        INTO @gs_makt
        FOR ALL ENTRIES IN @gt_mara
        WHERE matnr = @gt_mara-matnr.
      ENDSELECT.

      APPEND gs_makt TO gt_makt.

    ENDIF.



    IF gt_afvc IS INITIAL AND gt_operation IS NOT INITIAL.
      SELECT SINGLE
             aufpl,
             tdname
        FROM afvc_text
        INTO @gs_afvc
        WHERE aufpl = @<fs_operation_index1>-routing_no.

      APPEND gs_afvc TO gt_afvc.

    ENDIF.

    SORT: gt_component BY material,
          gt_afvc BY aufpl,
          gt_makt BY matnr.


    LOOP AT gt_operation ASSIGNING FIELD-SYMBOL(<fs_operation>).

      gs_dados-operacao = <fs_operation>-operation_number.
      gs_dados-descricao_operacao = <fs_operation>-description.
      gs_dados-maq = <fs_operation>-work_center.
      gs_dados-fase = <fs_operation>-work_center_text.
      gs_dados-tempo_preparacao = <fs_operation>-activity_type_1.

      READ TABLE gt_component ASSIGNING FIELD-SYMBOL(<fs_component>) WITH KEY material = gs_mara-matnr BINARY SEARCH.

      IF sy-subrc IS  INITIAL.

        gs_dados-quantidade_necessaria  = <fs_component>-req_quan.
        gs_dados-um                     = <fs_component>-base_uom.
        gs_dados-codigo                 = <fs_component>-material.

      ENDIF.

      READ TABLE gt_makt ASSIGNING FIELD-SYMBOL(<fs_makt>) INDEX 1.

      IF sy-subrc IS INITIAL.

        gs_dados-descricao = <fs_makt>-maktx.

      ENDIF.

      READ TABLE gt_header ASSIGNING FIELD-SYMBOL(<fs_header>) INDEX 1.

      IF sy-subrc IS INITIAL.

        gs_dados-ordem = <fs_header>-order_number.
        gs_dados-quantidade_produzir = <fs_header>-target_quantity.
        gs_dados-data_abertura = <fs_header>-production_start_date.
        gs_dados-data_prevista = <fs_header>-production_finish_date.

      ENDIF.

      READ TABLE gt_afvc ASSIGNING FIELD-SYMBOL(<fs_afvc>) WITH KEY aufpl = <fs_operation>-routing_no BINARY SEARCH.

      IF sy-subrc IS  INITIAL.

        gs_dados-texto_longo  = <fs_afvc>-tdname.

      ENDIF.


      READ TABLE gt_prod_rel_tool ASSIGNING FIELD-SYMBOL(<fs_rel_tool>) INDEX 1.

      IF <fs_rel_tool> IS ASSIGNED.

        lv_hora =  trunc( <fs_rel_tool>-duration / 60 ).
        lv_minuto = trunc( <fs_rel_tool>-duration MOD 60 ).
        lv_segundo = trunc( ( ( <fs_rel_tool>-duration MOD 60 ) - lv_minuto ) * 60 ).

        IF lv_hora < 10.
          lv_h = |{ lv_hours_string }{ lv_hora }|.
        ELSE.
          lv_h = |{ lv_hora }|.
        ENDIF.

        gs_dados-tempo_producao =  | { lv_h }:{ lv_minuto }:{ lv_segundo } |.


      ENDIF.

      APPEND gs_dados TO gt_dados.
      CLEAR gs_dados.

    ENDLOOP.


*
** Preencha o número da ordem de produção
*    lv_production_order = 'SUA_ORDEM_DE_PRODUCAO'.
*
** Chame a BAPI para obter detalhes da ordem de produção
*    CALL FUNCTION 'BAPI_PRODORD_GET_DETAIL'
*      EXPORTING
*        productionorder = lv_production_order
*      TABLES
*        header     = lt_order_data.

*    CALL FUNCTION 'BAPI_PRODORD_GET_DETAIL'
*      EXPORTING
*        productionorder = p_ordem
*      TABLES
*        order_data      = lt_order_data
*        return          = lt_return.

* Verifique se a chamada foi bem-sucedida
*    IF sy-subrc = 0.
*      LOOP AT lt_order_data INTO DATA(ls_order_data).
*        " Aqui você pode preencher a tabela para o ALV
*        APPEND VALUE #(field1 = ls_order_data-campo1
*                        field2 = ls_order_data-campo2
*                        " ... outros campos
*                       ) TO gt_alv_data.
*      ENDLOOP.

*    LOOP AT lt_order_data INTO DATA(ls_order_data).
*
*
*
*    ENDLOOP.


  ENDMETHOD.

  METHOD m_cria_alv.

    DATA: lr_table TYPE REF TO cl_salv_table.
    DATA: lr_functions TYPE REF TO cl_salv_functions.
    DATA: lr_display   TYPE REF TO cl_salv_display_settings.
    DATA: lr_columns   TYPE REF TO cl_salv_columns_table.
    DATA: lr_column    TYPE REF TO cl_salv_column_table.
    DATA:lr_sorts TYPE REF TO cl_salv_sorts.
    DATA:lr_agg TYPE REF TO cl_salv_aggregations.

    DATA: lr_events TYPE REF TO cl_salv_events_table.
    DATA: lr_selections TYPE REF TO cl_salv_selections.


    TRY.

        cl_salv_table=>factory( IMPORTING r_salv_table = lr_table
                                CHANGING t_table  = gt_dados ).

        lr_functions = lr_table->get_functions( ).
        lr_functions->set_all( abap_true ).

        lr_display = lr_table->get_display_settings( ).
        lr_display->set_striped_pattern( cl_salv_display_settings=>true ).
        lr_display->set_list_header( TEXT-t01  ).


      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t17 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t02 ).
    lr_column->set_medium_text( TEXT-t02 ) .

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t18 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t03 ).
    lr_column->set_medium_text( TEXT-t32 ).
    lr_column->set_short_text( TEXT-t32 ).

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t19 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t04 ).
    lr_column->set_medium_text( TEXT-t33 ).
    lr_column->set_short_text( TEXT-t33 ).

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t20 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t05 ).
    lr_column->set_medium_text( TEXT-t34 ).
    lr_column->set_short_text( TEXT-t34 ).

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t21 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t06 ).

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t22 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t07 ).

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t23 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t08 ).
    lr_column->set_medium_text( TEXT-t08 ).
    lr_column->set_short_text( TEXT-t08 ).



    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t24 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t09 ).
    lr_column->set_medium_text( TEXT-t09 ).
    lr_column->set_short_text( TEXT-t09 ).


    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t25 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t10 ).
    lr_column->set_medium_text( TEXT-t10 ).
    lr_column->set_short_text( TEXT-t10 ).

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t26 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t11 ).
    lr_column->set_medium_text( TEXT-t37 ).
    lr_column->set_short_text( TEXT-t37 ).

    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t27 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t12 ).
    lr_column->set_medium_text( TEXT-t12 ).
    lr_column->set_short_text( TEXT-t12 ).

    lr_columns = lr_table->get_columns( ).



    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t28 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.


    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t13 ).
    lr_column->set_medium_text( TEXT-t13 ).
    lr_column->set_short_text( TEXT-t13 ).


    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t29 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t14 ).
    lr_column->set_medium_text( TEXT-t14 ).
    lr_column->set_short_text( TEXT-t35 ).


    lr_columns = lr_table->get_columns( ).

    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t30 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.


    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t15 ).
    lr_column->set_medium_text( TEXT-t15 ).
    lr_column->set_short_text( TEXT-t36 ).


    lr_columns = lr_table->get_columns( ).


    TRY.

        lr_column ?= lr_columns->get_column( TEXT-t31 ).
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_msg cx_salv_existing.

    ENDTRY.

    lr_columns->set_optimize( abap_true ).
    lr_column->set_long_text( TEXT-t16 ).

    lr_columns = lr_table->get_columns( ).

    lr_events = lr_table->get_event( ).


    lr_table->display( ).


  ENDMETHOD.



ENDCLASS.