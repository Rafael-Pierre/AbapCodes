*&---------------------------------------------------------------------*
*& Include zrpmi_clientes_f01
*&---------------------------------------------------------------------*

FORM f_seleciona_dados.

  SELECT *
  FROM zi_rpm_clientes
  INTO TABLE @gt_dados
  WHERE kunnr IN @s_kunnr
  AND bukrs EQ @p_bukrs
  AND bldat IN @s_bldat.

ENDFORM.

FORM f_exibe_alv.


  DATA: lo_table         TYPE REF TO cl_salv_table,
        lo_functions     TYPE REF TO cl_salv_functions,
        lo_display       TYPE REF TO cl_salv_display_settings,
        lo_columns       TYPE REF TO cl_salv_columns_table,
        lo_column        TYPE REF TO cl_salv_column_table,
        lo_agg           TYPE REF TO cl_salv_aggregations,
        lo_sorts         TYPE REF TO cl_salv_sorts,
        lo_handle_events TYPE REF TO lcl_handle_events,
        lo_events        TYPE REF TO cl_salv_events_table.

  TRY.

      cl_salv_table=>factory( IMPORTING r_salv_table = lo_table
                              CHANGING  t_table      = gt_dados  ).


      lo_functions = lo_table->get_functions( ).
      lo_functions->set_all( abap_true ).


      lo_display = lo_table->get_display_settings( ).
      lo_display->set_striped_pattern( cl_salv_display_settings=>true ).

      lo_display->set_list_header( text-t03 ).

      lo_columns =  lo_table->get_columns( ).

      lo_column ?= lo_columns->get_column( 'BELNR' ).
      lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).


      lo_agg = lo_table->get_aggregations( ).
      lo_agg->add_aggregation( columnname = 'DMBTR' ).


      lo_events = lo_table->get_event( ).

      CREATE OBJECT lo_handle_events.
      SET HANDLER lo_handle_events->m_on_double_click FOR lo_events.

    CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error cx_salv_msg.

  ENDTRY.

  lo_table->display( ).


ENDFORM.