*&---------------------------------------------------------------------*
*& Include zrpmi_alv_editavel_imp
*&---------------------------------------------------------------------*

CLASS lcl_main IMPLEMENTATION.

  METHOD m_main.

    me->m_select( ).
    me->m_exibir_alv( ).

  ENDMETHOD.

  METHOD m_select.

    DATA ls_saida LIKE LINE OF gt_saida.

    SELECT usuario_sap, item_conhecimento,
           nivel_conhecimento, data_criacao, data_modificacao
    FROM zrpmt_turmat6
    INTO TABLE @DATA(lt_edit)
    WHERE usuario_sap <> ''.

    SELECT bname
    FROM usr01 "#EC CI_GENBUFF
    WHERE bname IS NOT INITIAL
    INTO TABLE @gt_users.

    LOOP AT lt_edit INTO DATA(ls_edit).            "#EC CI_LOOP_INTO_WA

      MOVE-CORRESPONDING ls_edit TO ls_saida.

      ls_saida-field_style = VALUE #(
      ( fieldname = gc_usuario        style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_item           style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_nivel          style = cl_gui_alv_grid=>mc_style_enabled )
      ( fieldname = gc_dt_criacao     style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_dt_modificacao style = cl_gui_alv_grid=>mc_style_disabled ) ).

      APPEND ls_saida TO gt_saida.

    ENDLOOP.

  ENDMETHOD.

  METHOD m_exibir_alv.

    DATA: lt_fieldcat TYPE lvc_t_fcat,
          ls_layout   TYPE lvc_s_layo.

    IF go_grid IS INITIAL.
      " Cria controle custom
      CREATE OBJECT go_custom_container
        EXPORTING
          container_name = 'CONTAINER_0001'.

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

    ls_fieldcat-fieldname = gc_usuario.
    ls_fieldcat-coltext = TEXT-t04.
    APPEND ls_fieldcat TO ct_fieldcat.

    ls_fieldcat-fieldname = gc_item.
    ls_fieldcat-coltext = TEXT-t05.
    APPEND ls_fieldcat TO ct_fieldcat.

    ls_fieldcat-fieldname = gc_nivel.
    ls_fieldcat-coltext = TEXT-t06.
    APPEND ls_fieldcat TO ct_fieldcat.

    ls_fieldcat-fieldname = gc_dt_criacao.
    ls_fieldcat-coltext = TEXT-t07.
    APPEND ls_fieldcat TO ct_fieldcat.

    ls_fieldcat-fieldname = gc_dt_modificacao.
    ls_fieldcat-coltext = TEXT-t08.
    APPEND ls_fieldcat TO ct_fieldcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE' "#EC CI_SUBRC
      EXPORTING
        i_structure_name       = 'ZRPMST_TURMAT6'
        i_internal_tabname     = 'GT_SAIDA'
      CHANGING
        ct_fieldcat            = ct_fieldcat
      EXCEPTIONS ##FM_SUBRC_OK
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.


  ENDMETHOD.

  METHOD m_data_changed.

    DATA lr_keys_delete TYPE RANGE OF zrpmt_turmat6-usuario_sap.
    DATA lv_answer TYPE c.
    DATA ls_saida TYPE ty_saida.

    IF er_data_changed->mt_inserted_rows IS NOT INITIAL.
*
      LOOP AT er_data_changed->mt_inserted_rows INTO DATA(ls_inserted). "#EC CI_LOOP_INTO_WA

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_usuario
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_item
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_nivel
             i_style = cl_gui_alv_grid=>mc_style_enabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_dt_criacao
             i_style = cl_gui_alv_grid=>mc_style_disabled
        ).

        er_data_changed->modify_style(
          EXPORTING
             i_row_id = ls_inserted-row_id
             i_fieldname = gc_dt_modificacao
             i_style = cl_gui_alv_grid=>mc_style_disabled
        ).

      ENDLOOP.

    ENDIF.

*&---------------------------------------------------------------------*
*&----------------------EXCLUIR REGISTRO-------------------------------*
*&---------------------------------------------------------------------*

    LOOP AT er_data_changed->mt_good_cells INTO DATA(ls_column). "#EC CI_LOOP_INTO_WA

      CHECK ls_column-value IS NOT INITIAL.        "#EC CI_LOOP_INTO_WA
      "Deletar erros antes da nova validação

      DELETE er_data_changed->mt_protocol WHERE fieldname = ls_column-fieldname. "#EC CI_STDSEQ

      CASE ls_column-fieldname. "Abrindo case para utilizar os campos

        WHEN gc_nivel. "Campo nível conhecimento



          IF ls_column-value NOT BETWEEN '1' AND '5'. "Fazendo validação do nível

            CALL METHOD er_data_changed->add_protocol_entry "Chama método para mensagem
              EXPORTING
                i_msgid     = 'ZRPM_ALV_EDITAVEL' "Classe de mensagem criada
                i_msgty     = 'E'
                i_msgno     = '001' "Numero de mensagem"
                i_msgv1     = ls_column-value
                i_fieldname = ls_column-fieldname
                i_row_id    = ls_column-row_id.
          ENDIF.

        WHEN gc_usuario.

          READ TABLE gt_users ASSIGNING FIELD-SYMBOL(<fs_users>) WITH KEY usuario_sap = ls_column-value BINARY SEARCH.

          IF sy-subrc IS NOT INITIAL.
            CALL METHOD er_data_changed->add_protocol_entry
              EXPORTING
                i_msgid     = 'ZRPM_ALV_EDITAVEL' "Classe de mensagem criada
                i_msgty     = 'E'
                i_msgno     = '002' "my message number
                i_msgv1     = ls_column-value
                i_fieldname = ls_column-fieldname
                i_row_id    = ls_column-row_id.
          ENDIF.

      ENDCASE.
    ENDLOOP.

    CLEAR lr_keys_delete.

    LOOP AT er_data_changed->mt_deleted_rows INTO DATA(ls_deleted_row). "#EC CI_LOOP_INTO_WA
      READ TABLE gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>) INDEX ls_deleted_row-row_id.
      APPEND VALUE #(
      sign = 'I'
      option = 'EQ'
      low = <fs_saida>-usuario_sap
      ) TO lr_keys_delete.
    ENDLOOP.

    IF lines( lr_keys_delete ) > 0.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar      = TEXT-t02
          text_question = TEXT-t01
        IMPORTING
          answer        = lv_answer.

      IF ( lv_answer = '1' ).
        DELETE FROM zrpmt_turmat6 WHERE usuario_sap IN lr_keys_delete.
      ELSE.
        go_grid->refresh_table_display( ).
      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD m_save.

    DATA: lt_editavel TYPE TABLE OF zrpmt_turmat6,
          ls_editavel TYPE zrpmt_turmat6.

    SELECT *
    FROM zrpmt_turmat6
    INTO TABLE @lt_editavel
    WHERE usuario_sap IN @s_user.

    SORT lt_editavel BY usuario_sap item_conhecimento.
    SORT gt_saida BY usuario_sap item_conhecimento.

    LOOP AT gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>).


      IF <fs_saida>-item_conhecimento IS NOT INITIAL AND <fs_saida>-nivel_conhecimento  IS NOT INITIAL AND <fs_saida>-usuario_sap IS NOT INITIAL.

*        MOVE-CORRESPONDING <fs_saida> TO ls_editavel.
*        APPEND ls_editavel TO lt_editavel.
*        CALL METHOD go_grid->refresh_table_display( ).
*        MESSAGE ID 'ZJGP_ALV_EDITAVEL' TYPE 'S' NUMBER 000 DISPLAY LIKE 'E'.

*      ELSE.
*---------------------------------VALIDANDO NOVO USUÁRIO*
        READ TABLE lt_editavel ASSIGNING FIELD-SYMBOL(<fs_editavel>) WITH KEY usuario_sap = <fs_saida>-usuario_sap item_conhecimento = <fs_saida>-item_conhecimento BINARY SEARCH.
        IF sy-subrc IS NOT INITIAL.
*        IF <fs_editavel>-usuario_sap NE <fs_saida>-usuario_sap.
          <fs_saida>-data_criacao = sy-datum.
*                    <fs_saida>-data_modificacao = sy-datum.
          MOVE-CORRESPONDING <fs_saida> TO ls_editavel.

          APPEND ls_editavel TO lt_editavel.
          CLEAR ls_editavel.


*        ELSEIF sy-subrc IS INITIAL.
*        ENDIF.
*---------------------------------VALIDANDO NOVO USUÁRIO*

        ELSEIF <fs_saida>-nivel_conhecimento NE <fs_editavel>-nivel_conhecimento.
*          <fs_saida>-data_modificacao = sy-datum.
*          <fs_editavel>-data_modificacao = <fs_saida>-data_modificacao.
          <fs_saida>-data_modificacao = sy-datum.
*          <fs_editavel>-data_modificacao = sy-datum.
*          <fs_editavel>-nivel_conhecimento = <fs_saida>-nivel_conhecimento.
          MOVE-CORRESPONDING <fs_saida> TO ls_editavel.
          APPEND ls_editavel TO lt_editavel.
          CLEAR ls_editavel.

        ENDIF.

*      ELSE.
*
*        MESSAGE ID 'ZRPM_ALV_EDITAVEL' TYPE 'S' NUMBER 000 DISPLAY LIKE 'E'.

      ELSE.

        MESSAGE ID 'ZRPM_ALV_EDITAVEL' TYPE 'S' NUMBER 002 DISPLAY LIKE 'E'.

      ENDIF.


*      IF <fs_saida>-data_criacao IS INITIAL. "Ao terminar de preencher os demais campos seta com a data atual o campoo data
*        <fs_saida>-data_criacao = sy-datum.
*      ENDIF.
*
*      IF <fs_saida>-data_modificacao IS NOT INITIAL.
*        <fs_saida>-data_modificacao = sy-datum.
*      ELSE.
*        <fs_saida>-data_modificacao = '-'.
*      ENDIF.
*
*      MOVE-CORRESPONDING <fs_saida> TO ls_editavel.
*
*      APPEND ls_editavel TO lt_editavel.

      IF gt_saida IS NOT INITIAL.

        <fs_saida>-field_style[ fieldname = gc_usuario ]-style = cl_gui_alv_grid=>mc_style_disabled.

        <fs_saida>-field_style[ fieldname = gc_item ]-style = cl_gui_alv_grid=>mc_style_disabled.

      ENDIF.

    ENDLOOP.


    MODIFY zrpmt_turmat6 FROM TABLE lt_editavel.

  ENDMETHOD.

ENDCLASS.