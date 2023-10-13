*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_mfs_f01
*&---------------------------------------------------------------------*

FORM f_seleciona_dados_join.

  SELECT e~usuario_sap, e~belnr_concat, e~status, e~data_criacao, e~data_modificacao,
         c~bukrs,c~butxt,
         b~belnr,b~gjahr,b~buzei,
         d~lifnr,d~name1,
         a~umskz,a~augdt,a~augbl,a~zuonr,b~dmbtr
   FROM bseg AS b
   LEFT OUTER JOIN bsik_view AS a ON a~belnr = b~belnr
                             AND a~buzei = b~buzei
                             AND a~gjahr = b~gjahr
   LEFT OUTER JOIN t001 AS c ON b~bukrs = c~bukrs
   LEFT OUTER JOIN lfa1 AS d ON a~lifnr = d~lifnr
   LEFT OUTER JOIN zjgpt_grupo2 AS e ON e~belnr = b~belnr
                                AND e~buzei = b~buzei
                                AND e~gjahr = b~gjahr "#EC CI_BUFFJOIN
   WHERE c~bukrs IN @s_bukrs AND
         b~belnr IN @s_belnr AND
         a~augbl IN @s_augbl AND
         d~lifnr IN @s_lifnr AND
         a~zuonr IN @s_zuonr
   INTO TABLE @gt_saida1.

  PERFORM f_concat.

ENDFORM.

FORM f_seleciona_tabelaz.
  DATA ls_saida LIKE LINE OF gt_saida.

  SELECT usuario_sap status
         belnr belnr_concat
         data_criacao data_modificacao
   FROM zjgpt_grupo2
   INTO TABLE gt_tabelaz
   WHERE usuario_sap <> ''.
  gv_variavel_aux = 1.

ENDFORM.

FORM f_buscar_arquivos.
  DATA: lt_filetable TYPE filetable,
        ls_filetable TYPE LINE OF filetable,
        lt_rc        TYPE i.

  CLEAR: ls_filetable.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Selecione o arquivo para Upload' ##NO_TEXT
      default_extension       = 'XLSX'
      file_filter             = 'Arquivos do Excel (*.XLS)|*.XLS| Excel files (*.XLSX|' ##NO_TEXT
      initial_directory       = 'C:\Users\matheus.freitas.META'
    CHANGING
      file_table              = lt_filetable
      rc                      = lt_rc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  IF sy-subrc IS NOT INITIAL.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    READ TABLE lt_filetable INTO ls_filetable INDEX 1.
    p_file = ls_filetable-filename.
  ENDIF.

ENDFORM.

FORM f_upload.

  DATA: lv_error_msg      TYPE string,
        lv_error_occurred TYPE abap_bool VALUE abap_false,
        lt_belnr          TYPE TABLE OF ty_belnr,
        lv_len            TYPE i,
        lv_zeros_needed   TYPE i,
        lv_zeros_string   TYPE string.

  SELECT usuario_sap
   FROM zjgpt_grupo2
   INTO TABLE gt_usersap
   WHERE usuario_sap <> '' .
  SORT gt_usersap BY usuario_sap.

  SELECT b~belnr
   FROM bseg AS b                                       "#EC CI_SEL_DEL
   LEFT OUTER JOIN bsik_view AS a ON a~belnr = b~belnr
   WHERE a~belnr = b~belnr
   INTO TABLE @lt_belnr.

  SORT lt_belnr BY belnr.
  DELETE ADJACENT DUPLICATES FROM lt_belnr COMPARING belnr.

  SELECT bname
   FROM usr01                                           "#EC CI_GENBUFF
   INTO TABLE @gt_usr01
   WHERE bname <> ''.

  SORT gt_usr01 BY bname.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = 'X'
      i_tab_raw_data       = gt_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_tabelaz
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.


  IF sy-subrc IS INITIAL.
    SORT gt_tabelaz BY usuario_sap.
    LOOP AT gt_tabelaz ASSIGNING FIELD-SYMBOL(<fs_tabelaz>).

      lv_len = strlen( <fs_tabelaz>-belnr ).
      lv_zeros_needed = 10 - lv_len.

      IF lv_zeros_needed > 0.
        DO lv_zeros_needed TIMES. "#EC CI_NESTED
          CONCATENATE '0' <fs_tabelaz>-belnr INTO <fs_tabelaz>-belnr.
        ENDDO.
      ENDIF.

      IF <fs_tabelaz>-usuario_sap IS INITIAL.
        lv_error_msg = TEXT-t02.
        lv_error_occurred = abap_true.
      ENDIF.

      READ TABLE gt_usr01 ASSIGNING FIELD-SYMBOL(<fs_usr01>) WITH KEY bname = <fs_tabelaz>-usuario_sap BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CONCATENATE lv_error_msg TEXT-t03 INTO lv_error_msg SEPARATED BY space.
        lv_error_occurred = abap_true.
      ENDIF.

      IF <fs_tabelaz>-status IS INITIAL OR ( <fs_tabelaz>-status <> 'SIM' AND <fs_tabelaz>-status <> 'NÃO' AND <fs_tabelaz>-status <> 'PENDENTE' ).
        CONCATENATE lv_error_msg TEXT-t04 INTO lv_error_msg SEPARATED BY space.
        lv_error_occurred = abap_true.
      ENDIF.

      READ TABLE lt_belnr ASSIGNING FIELD-SYMBOL(<fs_belnr>) WITH KEY belnr = <fs_tabelaz>-belnr BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CONCATENATE lv_error_msg TEXT-t05 INTO lv_error_msg SEPARATED BY space.
        lv_error_occurred = abap_true.
      ENDIF.

      READ TABLE gt_usersap ASSIGNING FIELD-SYMBOL(<fs_usersap>) WITH KEY usuario_sap = <fs_tabelaz>-usuario_sap BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        CONCATENATE lv_error_msg TEXT-t07 INTO lv_error_msg SEPARATED BY space.
        lv_error_occurred = abap_true.
      ENDIF.

      IF lv_error_occurred = abap_false.
        gs_saida-usuario_sap      = <fs_tabelaz>-usuario_sap.
        gs_saida-status           = <fs_tabelaz>-status.
        CONCATENATE <fs_tabelaz>-belnr(3) <fs_tabelaz>-belnr+7(3) INTO gs_saida-belnr_concat.
        gs_saida-data_criacao     = sy-datum.
        gs_saida-belnr            = <fs_tabelaz>-belnr.

        APPEND gs_saida TO gt_saida.
        CLEAR gs_saida.
      ENDIF.

    ENDLOOP.

    gv_variavel_aux = 1.
    gv_erro = 1.

    IF lv_error_occurred = abap_true.
      MESSAGE lv_error_msg TYPE 'E'.
    ENDIF.
  ELSE.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

FORM f_campos_disabled.

  LOOP AT gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>).

    IF gt_saida IS NOT INITIAL.

      <fs_saida>-field_style[ fieldname = gc_users ]-style = cl_gui_alv_grid=>mc_style_disabled.
      <fs_saida>-field_style[ fieldname = gc_belnr_concat ]-style = cl_gui_alv_grid=>mc_style_disabled.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM f_inclusao_dts.

  SORT gt_saida BY usuario_sap.
  LOOP AT gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>).

    READ TABLE gt_edit ASSIGNING FIELD-SYMBOL(<fs_editavel>) WITH KEY usuario_sap = <fs_saida>-usuario_sap BINARY SEARCH.

    IF sy-subrc IS NOT INITIAL.

      MOVE-CORRESPONDING <fs_saida> TO gs_edit.
      <fs_saida>-data_criacao = sy-datum.
      gs_edit-data_criacao = <fs_saida>-data_criacao.

    ELSEIF <fs_saida>-usuario_sap = <fs_editavel>-usuario_sap
      AND <fs_saida>-belnr_concat = <fs_editavel>-belnr_concat
      AND <fs_saida>-status NE <fs_editavel>-status.

      MOVE-CORRESPONDING <fs_saida> TO gs_edit.
      <fs_saida>-data_modificacao = sy-datum.
      gs_edit-data_modificacao = sy-datum.

    ENDIF.

    APPEND gs_edit TO gt_edit_aux.
  ENDLOOP.

ENDFORM.