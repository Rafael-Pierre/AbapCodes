*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_rda_f01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f_alv_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM f_select_fieldstyle.

  DATA ls_saida LIKE LINE OF gt_saida.

  SELECT mandt usuario_sap belnr_concat status
         data_criacao data_modificacao
         belnr gjahr buzei
   FROM zjgpt_grupo2
   INTO TABLE gt_edit
   WHERE belnr IN s_belnr.

  SELECT usuario_sap belnr_concat
   FROM zjgpt_grupo2
   INTO TABLE gt_usersap
   WHERE usuario_sap <> ''.

  SELECT bname
   FROM usr01                                            "#EC CI_GENBUFF
   INTO TABLE @gt_usr01
   WHERE bname <> ''.

  SORT gt_usr01 BY bname.
  SORT gt_edit BY usuario_sap.
  SORT gt_usersap BY usuario_sap.


  IF p_r1 = abap_true OR p_r2 = abap_true OR p_r3 = abap_true.
    LOOP AT gt_saida1 INTO DATA(ls_saida1).        "#EC CI_LOOP_INTO_WA

      MOVE-CORRESPONDING ls_saida1 TO ls_saida.


      ls_saida-field_style = VALUE #(
      ( fieldname = gc_users               style = cl_gui_alv_grid=>mc_style_enabled )
      ( fieldname = gc_belnr_concat      style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_status           style = cl_gui_alv_grid=>mc_style_enabled )
      ( fieldname = gc_dtac                style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_dtam              style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_bukrs               style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_butxt             style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_belnr            style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_gjahr               style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_buzei             style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_lifnr            style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_name1               style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_umskz             style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_augdt            style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_augbl               style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_zuonr        style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_dmbtr        style = cl_gui_alv_grid=>mc_style_disabled ) ).
      IF ls_saida-usuario_sap IS INITIAL.
        ls_saida-field_style[ fieldname = gc_users ]-style = cl_gui_alv_grid=>mc_style_enabled.
      ELSE.
        ls_saida-field_style[ fieldname = gc_users ]-style = cl_gui_alv_grid=>mc_style_disabled.
      ENDIF.

      APPEND ls_saida TO gt_saida.

    ENDLOOP.

  ELSEIF p_e2 = abap_true.

    LOOP AT gt_tabelaz INTO DATA(ls_tabelaz).      "#EC CI_LOOP_INTO_WA

      MOVE-CORRESPONDING ls_tabelaz TO ls_saida.

      ls_saida-field_style = VALUE #(
      ( fieldname = gc_users               style = cl_gui_alv_grid=>mc_style_enabled )
      ( fieldname = gc_belnr_concat      style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_status           style = cl_gui_alv_grid=>mc_style_enabled )
      ( fieldname = gc_dtac                style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_dtam              style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_bukrs               style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_butxt             style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_belnr            style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_gjahr               style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_buzei             style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_lifnr            style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_name1               style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_umskz             style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_augdt            style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_augbl               style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_zuonr        style = cl_gui_alv_grid=>mc_style_disabled )
      ( fieldname = gc_dmbtr        style = cl_gui_alv_grid=>mc_style_disabled ) ).

      APPEND ls_saida TO gt_saida.

    ENDLOOP.
  ENDIF.

ENDFORM.