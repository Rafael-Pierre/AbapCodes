*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_c01
*&---------------------------------------------------------------------*



CLASS lcl_handle_events DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS : handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid

      IMPORTING e_row_id e_column_id.

ENDCLASS. "lcl_event_receiver DEFINITION

CLASS lcl_handle_events IMPLEMENTATION.

  METHOD handle_hotspot_click.

    READ TABLE gt_saida INTO gs_saida INDEX e_row_id-index.

    CASE e_column_id.

      WHEN 'BELNR'.

        SET PARAMETER ID: 'BLN' FIELD gs_saida-belnr, 'BUK' FIELD gs_saida-bukrs, 'GJR' FIELD gs_saida-gjahr.

        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

    ENDCASE.

  ENDMETHOD. "handle_double_click

ENDCLASS. "lcl_event_receiver IMPLEMENTATION

CLASS lcl_main DEFINITION.

  PUBLIC SECTION.

    METHODS:
      m_main,
      m_save.

  PRIVATE SECTION.

    METHODS:

      m_exibir_alv,
      m_fieldcat CHANGING ct_fieldcat TYPE lvc_t_fcat,
      m_data_changed FOR EVENT data_changed OF cl_gui_alv_grid IMPORTING er_data_changed e_onf4 e_onf4_before e_onf4_after.

ENDCLASS.

DATA: go_main TYPE REF TO lcl_main.

CLASS lcl_main IMPLEMENTATION.

  METHOD m_main.

    me->m_exibir_alv( ).

  ENDMETHOD.

  METHOD m_exibir_alv.

    DATA: lt_fieldcat TYPE lvc_t_fcat,
          ls_layout   TYPE lvc_s_layo.

    IF go_grid IS INITIAL.
      " Cria controle custom
      CREATE OBJECT go_custom_container
        EXPORTING
          container_name = 'CONTAINER_001'.

    ENDIF.

    IF go_grid IS INITIAL.
      " Cria ALV Grid
      CREATE OBJECT go_grid
        EXPORTING
          i_parent = go_custom_container.

      ls_layout-stylefname = gc_field_style.
      ls_layout-sel_mode   = 'A'. "DESCOBRIR O QUE É
      ls_layout-cwidth_opt = 'X'.

      me->m_fieldcat( CHANGING ct_fieldcat = lt_fieldcat ).

      CALL METHOD go_grid->set_ready_for_input
        EXPORTING
          i_ready_for_input = 1.

      CALL METHOD go_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_enter.

      CALL METHOD go_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.

      SET HANDLER me->m_data_changed FOR go_grid.

      go_grid->set_table_for_first_display(
       EXPORTING
         is_layout            = ls_layout
         i_save               = abap_true
       CHANGING
         it_fieldcatalog      = lt_fieldcat
         it_outtab            = gt_saida ).

    ELSE.

      CALL METHOD go_grid->refresh_table_display
        EXPORTING
          is_stable = VALUE #( row = abap_true )
        EXCEPTIONS
          finished  = 1
          OTHERS    = 2.

    ENDIF.

  ENDMETHOD.

  METHOD m_fieldcat.

    DATA: ls_fieldcat TYPE lvc_s_fcat.
    DATA lo_hotspot TYPE REF TO lcl_handle_events.

    IF gv_variavel_aux = 0.
      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'DMBTR'.
      ls_fieldcat-do_sum    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'BUKRS'.
      ls_fieldcat-col_pos = '6'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'BELNR'.
      ls_fieldcat-col_pos = '7'.
      ls_fieldcat-hotspot = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'GJAHR'.
      ls_fieldcat-col_pos = '8'.
      APPEND ls_fieldcat TO ct_fieldcat.

    ENDIF.

    IF gv_variavel_aux = 1.

      ls_fieldcat-fieldname = 'DATA_MODIFICACAO'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      ls_fieldcat-fieldname = 'BUKRS'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'BUTXT'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.

      ls_fieldcat-fieldname = 'GJAHR'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'BUZEI'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'LIFNR'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'NAME1'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'DMBTR'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'UMSKZ'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'AUGDT'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'AUGBL'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'ZUONR'.
      ls_fieldcat-no_out    = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

    ENDIF.

    IF sy-subrc = 0.

      SET HANDLER lcl_handle_events=>handle_hotspot_click FOR go_grid.

    ENDIF.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'          "#EC CI_SUBRC
      EXPORTING
        i_structure_name       = 'ZJGPS_GRUPO2'
        i_internal_tabname     = 'GT_SAIDA'
      CHANGING
        ct_fieldcat            = ct_fieldcat
      EXCEPTIONS ##FM_SUBRC_OK
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

  ENDMETHOD.

  METHOD m_data_changed.

    DATA lr_keys_delete TYPE RANGE OF zjgpt_grupo2-usuario_sap.
    DATA lv_answer TYPE c.
    DATA ls_saida TYPE ty_saida.

    IF er_data_changed->mt_inserted_rows IS NOT INITIAL.
*
      LOOP AT er_data_changed->mt_inserted_rows INTO DATA(ls_inserted). "#EC CI_LOOP_INTO_WA

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_users
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_belnr_concat
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_status
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_dtac
             i_style = cl_gui_alv_grid=>mc_style_disabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_dtam
             i_style = cl_gui_alv_grid=>mc_style_disabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_bukrs
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_butxt
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_belnr
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_gjahr
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_buzei
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_lifnr
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_name1
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_umskz
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_augdt
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_augbl
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_zuonr
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_dmbtr
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

      ENDLOOP.

    ENDIF.

    LOOP AT er_data_changed->mt_good_cells INTO DATA(ls_column). "#EC CI_LOOP_INTO_WA

      CHECK ls_column-value IS NOT INITIAL.

      DELETE er_data_changed->mt_protocol WHERE fieldname = ls_column-fieldname. "#EC CI_STDSEQ

      CASE ls_column-fieldname.

        WHEN gc_status.

          IF ls_column-value <> 'PENDENTE' AND ls_column-value <> 'SIM' AND ls_column-value <> 'NÃO'.
            CALL METHOD er_data_changed->add_protocol_entry
              EXPORTING
                i_msgid     = 'ZJGP_GRUPO2'
                i_msgty     = 'E'
                i_msgno     = '000'
                i_msgv1     = ls_column-value
                i_fieldname = ls_column-fieldname
                i_row_id    = ls_column-row_id.
          ENDIF.

        WHEN gc_users. "Campo nível conhecimento
          DATA: lv_index TYPE sy-tabix.

          lv_index = ls_column-row_id.

          READ TABLE gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>) INDEX lv_index.

          READ TABLE gt_usr01 ASSIGNING FIELD-SYMBOL(<fs_usr01>) WITH KEY bname = ls_column-value. "#EC CI_STDSEQ
          IF sy-subrc IS NOT INITIAL.
            CALL METHOD er_data_changed->add_protocol_entry
              EXPORTING
                i_msgid     = 'ZJGP_GRUPO2'
                i_msgty     = 'E'
                i_msgno     = '002'
                i_msgv1     = ls_column-value
                i_fieldname = ls_column-fieldname
                i_row_id    = ls_column-row_id.
          ENDIF.
          READ TABLE gt_usersap ASSIGNING FIELD-SYMBOL(<fs_usersap>) WITH KEY usuario_sap = ls_column-value. "#EC CI_STDSEQ
          IF sy-subrc IS INITIAL.
            CALL METHOD er_data_changed->add_protocol_entry
              EXPORTING
                i_msgid     = 'ZJGP_GRUPO2'
                i_msgty     = 'E'
                i_msgno     = '003'
                i_msgv1     = ls_column-value
                i_fieldname = ls_column-fieldname
                i_row_id    = ls_column-row_id.
          ENDIF.

      ENDCASE.
    ENDLOOP.
*&---------------------------------------------------------------------*
*&----------------------EXCLUIR REGISTRO-------------------------------*
*&---------------------------------------------------------------------*

    CLEAR lr_keys_delete.

    LOOP AT er_data_changed->mt_deleted_rows INTO DATA(ls_deleted_row). "#EC CI_LOOP_INTO_WA
      READ TABLE gt_saida1 ASSIGNING FIELD-SYMBOL(<fs_saida1>) INDEX ls_deleted_row-row_id.
      APPEND VALUE #(
      sign = 'I'
      option = 'EQ'
      low = <fs_saida1>-belnr
      ) TO lr_keys_delete.
    ENDLOOP.

    IF lines( lr_keys_delete ) > 0.
      CALL FUNCTION 'POPUP_TO_CONFIRM' ##TEXT_POOL
        EXPORTING
          titlebar      = TEXT-t02
          text_question = TEXT-001
        IMPORTING
          answer        = lv_answer.

      IF ( lv_answer = '1' ).
*        DELETE FROM zjgpt_grupo2 WHERE usuario_sap IN lr_keys_delete.
      ELSE.
        go_grid->refresh_table_display( ).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD m_save.
    DATA: lt_inputexcel TYPE TABLE OF zjgpt_grupo2,
          ls_inputexcel LIKE LINE OF lt_inputexcel.

    PERFORM f_inclusao_dts.

    PERFORM f_nao_permite_dados_em_branco.

    IF gv_erro = 0.
      MODIFY zjgpt_grupo2 FROM TABLE gt_edit_aux.
      COMMIT WORK.
      IF gt_saida IS NOT INITIAL.
        PERFORM f_campos_disabled.
      ENDIF.
    ENDIF.

    IF gv_variavel_aux = 1.
      LOOP AT gt_saida INTO DATA(ls_saida).        "#EC CI_LOOP_INTO_WA
        MOVE-CORRESPONDING ls_saida TO ls_inputexcel.
        APPEND ls_inputexcel TO lt_inputexcel.
      ENDLOOP.
      MODIFY zjgpt_grupo2 FROM TABLE lt_inputexcel.
      COMMIT WORK.
    ENDIF.
    DELETE FROM zjgpt_grupo2 WHERE usuario_sap = ''.
    COMMIT WORK.
*     DELETE FROM zjgpt_grupo2.
  ENDMETHOD.

ENDCLASS.