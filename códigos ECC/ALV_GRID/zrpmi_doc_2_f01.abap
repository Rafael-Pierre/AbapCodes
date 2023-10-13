*&---------------------------------------------------------------------*
*& Include zrpmi_doc_2_f01
*&---------------------------------------------------------------------*

FORM f_seleciona_dados .

  DATA: lt_ekko_aux_bukrs TYPE TABLE OF ty_ekko,
        lt_ekko_aux_lifnr TYPE TABLE OF ty_ekko.

  SELECT ebeln
         bukrs
         lifnr
  FROM ekko
  INTO TABLE gt_ekko
  WHERE bukrs EQ p_bukrs
  AND lifnr IN s_lifnr.

  SORT gt_ekko BY bukrs.

  IF gt_ekko IS NOT INITIAL.

    SELECT  ebeln,                                 "#EC CI_NO_TRANSFORM
            netwr
    FROM ekpo
    INTO TABLE @gt_ekpo
    FOR ALL ENTRIES IN @gt_ekko
    WHERE ebeln EQ @gt_ekko-ebeln.

    lt_ekko_aux_lifnr = gt_ekko[].
    SORT lt_ekko_aux_lifnr BY lifnr.
    DELETE ADJACENT DUPLICATES FROM lt_ekko_aux_lifnr COMPARING lifnr.

    IF lt_ekko_aux_lifnr IS NOT INITIAL.

      SELECT lifnr,                                "#EC CI_NO_TRANSFORM
             land1,
             name1
      FROM lfa1
      INTO TABLE @gt_lfa1
      FOR ALL ENTRIES IN @lt_ekko_aux_lifnr
      WHERE lifnr = @lt_ekko_aux_lifnr-lifnr.

    ENDIF.

    lt_ekko_aux_bukrs = gt_ekko[].
    SORT lt_ekko_aux_lifnr BY bukrs.
    DELETE ADJACENT DUPLICATES FROM lt_ekko_aux_bukrs COMPARING bukrs.

    IF lt_ekko_aux_bukrs IS NOT INITIAL.

      SELECT bukrs,
             butxt
      FROM t001
      INTO TABLE @gt_t001
      FOR ALL ENTRIES IN @lt_ekko_aux_bukrs
      WHERE bukrs = @lt_ekko_aux_bukrs-bukrs.

    ENDIF.

  ENDIF.

  PERFORM f_processa_dados.

ENDFORM.

FORM f_processa_dados.

  DATA ls_dados LIKE LINE OF gt_dados.

  SORT: gt_ekko BY ebeln,
        gt_ekpo BY ebeln,
        gt_lfa1 BY lifnr,
        gt_t001 BY bukrs.


  LOOP AT gt_ekpo  ASSIGNING FIELD-SYMBOL(<fs_ekpo>).

    CLEAR ls_dados.

    ls_dados-netwr = <fs_ekpo>-netwr.
    ls_dados-ebeln   = <fs_ekpo>-ebeln.

    READ TABLE gt_ekko ASSIGNING FIELD-SYMBOL(<fs_ekko>) WITH KEY ebeln = <fs_ekpo>-ebeln BINARY SEARCH.

    IF sy-subrc IS INITIAL.

      ls_dados-bukrs = <fs_ekko>-bukrs.
      ls_dados-lifnr   = <fs_ekko>-lifnr.

    ENDIF.


    READ TABLE gt_lfa1 ASSIGNING FIELD-SYMBOL(<fs_lfa1>) WITH KEY lifnr = <fs_ekko>-lifnr BINARY SEARCH.

    IF sy-subrc IS INITIAL.

      ls_dados-land1 = <fs_lfa1>-land1.
      ls_dados-name1 = <fs_lfa1>-name1.

    ENDIF.

    READ TABLE gt_t001 ASSIGNING FIELD-SYMBOL(<fs_t001>) WITH KEY bukrs = <fs_ekko>-bukrs BINARY SEARCH.

    IF sy-subrc IS INITIAL.

      ls_dados-butxt = <fs_t001>-butxt.

    ENDIF.

    APPEND ls_dados TO gt_dados.

  ENDLOOP.

ENDFORM.


FORM f_fieldcat.

  PERFORM f_fill_fieldcat USING:

   'BUKRS'    TEXT-t02   1  ''    ''    ''    '',
   'BUTXT'    TEXT-t03   2  ''    ''    ''    '',
   'LIFNR'    TEXT-t04   3  ''    'X'   'X'    1,
   'NAME1'    TEXT-t05   4  ''    ''    ''    '',
   'LAND1'    TEXT-t06   5  ''    ''    ''    '',
   'EBELN'    TEXT-t07   6  ''    ''    ''    '',
   'NETWR'    TEXT-t08   7  'X'   ''    ''    ''.

  PERFORM f_alv_funcao.

ENDFORM.

FORM f_fill_fieldcat USING uv_fieldname
                           uv_col_name
                           uv_pos_name
                           uv_do_sum
                           uv_up
                           uv_subtot
                           uv_spos.


  gs_fieldcat-fieldname = uv_fieldname.
  gs_fieldcat-seltext_m = uv_col_name.
  gs_fieldcat-col_pos   = uv_pos_name.
  gs_fieldcat-do_sum    = uv_do_sum.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.


  gs_sort-fieldname = 'LIFNR'.
  gs_sort-up = uv_up.
  gs_sort-subtot = uv_subtot.
  gs_sort-spos = uv_spos.

  APPEND gs_sort TO gt_sort.
  CLEAR gs_sort.

ENDFORM.

FORM f_alv_funcao.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = gt_fieldcat
      it_sort            = gt_sort
    TABLES
      t_outtab           = gt_dados
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.

FORM f_fieldcat_grid USING uv_fieldname
                           uv_col_name
                           uv_pos_name
                           uv_do_sum.

  DATA ls_fieldcat_grid TYPE lvc_s_fcat.

  ls_fieldcat_grid-fieldname = uv_fieldname.
  ls_fieldcat_grid-coltext   = uv_col_name.
  ls_fieldcat_grid-col_pos   = uv_pos_name.
  ls_fieldcat_grid-do_sum    = uv_do_sum.

  APPEND ls_fieldcat_grid TO gt_fieldcat_grid.
  CLEAR ls_fieldcat_grid.

ENDFORM.

FORM f_alv_grid.

  PERFORM f_fieldcat_grid USING:
   'BUKRS'    TEXT-t02   1  ''   ,
   'BUTXT'    TEXT-t03   2  ''   ,
   'LIFNR'    TEXT-t04   3  ''   ,
   'NAME1'    TEXT-t05   4  ''   ,
   'LAND1'    TEXT-t06   5  ''   ,
   'EBELN'    TEXT-t07   6  ''   ,
   'NETWR'    TEXT-t08   7  'X'  .

  go_grid->set_table_for_first_display(
    CHANGING
      it_outtab                     =    gt_dados              " Output Table
      it_fieldcatalog               =    gt_fieldcat_grid              " Field Catalog
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.