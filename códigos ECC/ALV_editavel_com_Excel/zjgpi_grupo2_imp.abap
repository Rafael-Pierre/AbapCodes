*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_imp
*&---------------------------------------------------------------------*

*
CLASS lcl_main_ob IMPLEMENTATION.

  METHOD m_main_OO.


    me->m_select_oo( ).
    me->m_exibir_alv_oo(  ).

  ENDMETHOD.

  METHOD m_select_oo.

    DATA ls_saida LIKE LINE OF gt_saida.

    IF p_e1 = abap_true.
      me->m_upload(  ).
    ENDIF.

    IF p_r1 = abap_true.
      me->m_seleciona_dados_loop( ).
      me->m_processa_dados( ).

    ELSEIF p_r2 = abap_true.
      me->m_seleciona_dados_join( ).

    ELSEIF p_r3 = abap_true.
      me->m_seleciona_dados_cds( ).

    ELSEIF p_r4 = abap_true.
      IF p_e2 = abap_true.
        me->m_seleciona_tabelaz( ).

      ENDIF.
    ENDIF.

    SELECT mandt usuario_sap belnr_concat status
           data_criacao data_modificacao
           belnr gjahr buzei
     FROM zjgpt_grupo2
     INTO TABLE gt_edit
     WHERE belnr IN s_belnr.

    SELECT bname
     FROM usr01                                         "#EC CI_GENBUFF
     INTO TABLE @gt_usr01
     WHERE bname <> ''.

    SORT gt_usr01 BY bname.
    SORT gt_edit BY usuario_sap.
    SORT gt_saida BY usuario_sap.

    me->m_concat( ).

    IF gt_saida IS INITIAL.

      IF p_r1 = abap_true OR p_r2 = abap_true OR p_r3 = abap_true.
        LOOP AT gt_saida1 INTO DATA(ls_saida1).    "#EC CI_LOOP_INTO_WA

          MOVE-CORRESPONDING ls_saida1 TO ls_saida.

          ls_saida-field_style = VALUE #(
          ( fieldname = gc_users               style = cl_gui_alv_grid=>mc_style_enabled )
          ( fieldname = gc_belnr_concat        style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_status              style = cl_gui_alv_grid=>mc_style_enabled )
          ( fieldname = gc_dtac                style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_dtam                style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_bukrs               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_butxt               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_belnr               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_gjahr               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_buzei               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_lifnr               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_name1               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_umskz               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_augdt               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_augbl               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_zuonr               style = cl_gui_alv_grid=>mc_style_disabled )
          ( fieldname = gc_dmbtr               style = cl_gui_alv_grid=>mc_style_disabled ) ).
          IF ls_saida-usuario_sap IS INITIAL.
            ls_saida-field_style[ fieldname = gc_users ]-style = cl_gui_alv_grid=>mc_style_enabled.
          ELSE.
            ls_saida-field_style[ fieldname = gc_users ]-style = cl_gui_alv_grid=>mc_style_disabled.
          ENDIF.

          APPEND ls_saida TO gt_saida.

        ENDLOOP.
      ENDIF.
    ELSEIF p_e2 = abap_true.

      LOOP AT gt_tabelaz INTO DATA(ls_tabelaz).    "#EC CI_LOOP_INTO_WA

        MOVE-CORRESPONDING ls_tabelaz TO ls_saida.

        ls_saida-field_style = VALUE #(
        ( fieldname = gc_users               style = cl_gui_alv_grid=>mc_style_enabled )
        ( fieldname = gc_belnr_concat        style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_status              style = cl_gui_alv_grid=>mc_style_enabled )
        ( fieldname = gc_dtac                style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_dtam                style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_bukrs               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_butxt               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_belnr               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_gjahr               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_buzei               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_lifnr               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_name1               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_umskz               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_augdt               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_augbl               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_zuonr               style = cl_gui_alv_grid=>mc_style_disabled )
        ( fieldname = gc_dmbtr               style = cl_gui_alv_grid=>mc_style_disabled ) ).

        APPEND ls_saida TO gt_saida.

      ENDLOOP.
    ENDIF.

    SELECT usuario_sap , belnr_concat
    FROM  zjgpt_grupo2
    INTO TABLE @gt_usersap
    WHERE usuario_sap <> ''.

  ENDMETHOD.

  METHOD m_exibir_alv_oo.

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

      me->m_fieldcat_oo( CHANGING ct_fieldcat = lt_fieldcat ).

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

  METHOD m_fieldcat_oo.

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
      ls_fieldcat-hotspot = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'BELNR'.
      ls_fieldcat-col_pos = '7'.
      ls_fieldcat-hotspot = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = 'GJAHR'.
      ls_fieldcat-col_pos = '8'.
      ls_fieldcat-hotspot = 'X'.
      APPEND ls_fieldcat TO ct_fieldcat.

    ENDIF.

    IF gv_variavel_aux = 1.

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

  METHOD  m_data_changed.

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

          IF ls_column-value <> 'PENDENTE' AND ls_column-value <> 'SIM' AND ls_column-value <> 'NÃO' AND ls_column-value  <> 'NAO'.
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

          READ TABLE gt_usr01 ASSIGNING FIELD-SYMBOL(<fs_usr01>) WITH KEY bname = ls_column-value BINARY SEARCH. "#EC CI_STDSEQ
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
          READ TABLE gt_usersap ASSIGNING FIELD-SYMBOL(<fs_usersap>) WITH KEY usuario_sap = ls_column-value BINARY SEARCH. "#EC CI_STDSEQ
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

  METHOD m_save_oo.
    DATA: lt_inputexcel TYPE TABLE OF zjgpt_grupo2,
          ls_inputexcel LIKE LINE OF lt_inputexcel.

    me->m_inclusao_dts(  ).

    me->m_nao_permite_dados_em_branco(  ).

    IF gv_erro = 0.
      MODIFY zjgpt_grupo2 FROM TABLE gt_edit_aux.
      COMMIT WORK.
      IF gt_saida IS NOT INITIAL.
        me->m_campos_disabled(  ).
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

  ENDMETHOD.

  METHOD m_seleciona_dados_join.

    PERFORM f_seleciona_dados_join.
    me->m_concat(  ).

  ENDMETHOD.

  METHOD m_seleciona_dados_cds.

    PERFORM f_seleciona_dados_cds.
    me->m_concat( ).

  ENDMETHOD.

  METHOD m_concat.

    LOOP AT gt_saida1 ASSIGNING FIELD-SYMBOL(<fs_saida1>).

      CONCATENATE <fs_saida1>-belnr(3) <fs_saida1>-belnr+7(3) INTO <fs_saida1>-belnr_concat.

    ENDLOOP.

  ENDMETHOD.

  METHOD m_seleciona_dados_loop.

    PERFORM f_seleciona_dados_loop.

  ENDMETHOD.

  METHOD m_processa_dados.

    PERFORM f_processa_dados.

  ENDMETHOD.

  METHOD m_inclusao_dts.

    PERFORM f_inclusao_dts.

  ENDMETHOD.

  METHOD m_nao_permite_dados_em_branco.

    gv_erro  = 0.

    LOOP AT gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>).

      IF <fs_saida>-usuario_sap IS INITIAL OR <fs_saida>-belnr_concat  IS INITIAL OR <fs_saida>-status IS INITIAL.

        MESSAGE ID 'ZJGP_GRUPO2' TYPE 'S' NUMBER 004 DISPLAY LIKE 'E'.

        gv_erro = 1.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD m_campos_disabled.

    LOOP AT gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>).

      IF gt_saida IS NOT INITIAL.

        <fs_saida>-field_style[ fieldname = gc_users ]-style = cl_gui_alv_grid=>mc_style_disabled.
        <fs_saida>-field_style[ fieldname = gc_belnr_concat ]-style = cl_gui_alv_grid=>mc_style_disabled.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD m_seleciona_tabelaz.

    DATA ls_saida LIKE LINE OF gt_saida.

    SELECT usuario_sap status
           belnr belnr_concat
           data_criacao data_modificacao
     FROM zjgpt_grupo2
     INTO TABLE gt_tabelaz
     WHERE usuario_sap <> ''.
    gv_variavel_aux = 1.

  ENDMETHOD.

  METHOD m_upload.

    PERFORM f_upload.

  ENDMETHOD.

ENDCLASS.