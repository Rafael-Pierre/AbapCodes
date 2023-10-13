*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_rpm_f01
*&---------------------------------------------------------------------*

FORM f_seleciona_dados_loop .

  DATA: lt_bseg_aux_belnr TYPE TABLE OF ty_bseg.

  SELECT  bukrs belnr
          gjahr buzei
          dmbtr lifnr
   FROM bseg
   INTO TABLE gt_bseg
   WHERE belnr IN s_belnr
   AND bukrs IN s_bukrs.


  lt_bseg_aux_belnr = gt_bseg[].
  SORT lt_bseg_aux_belnr BY belnr.
  DELETE ADJACENT DUPLICATES FROM lt_bseg_aux_belnr COMPARING belnr.

  SORT lt_bseg_aux_belnr BY belnr.

  IF lt_bseg_aux_belnr IS NOT INITIAL.

    IF s_zuonr IS NOT INITIAL.

      SELECT bukrs,lifnr,
             umskz,augdt,
             augbl,zuonr,
             belnr,dmbtr
       FROM bsik_view
       FOR ALL ENTRIES IN @lt_bseg_aux_belnr
       WHERE augbl IN @s_augbl
       AND zuonr IN @s_zuonr
       AND belnr = @lt_bseg_aux_belnr-belnr
       INTO TABLE @gt_bsik.

    ELSE.

      SELECT bukrs,lifnr,
             umskz,augdt,
             augbl,zuonr,
             belnr,dmbtr
       FROM bsik_view
       FOR ALL ENTRIES IN @lt_bseg_aux_belnr
       WHERE augbl IN @s_augbl
       AND belnr = @lt_bseg_aux_belnr-belnr
       INTO TABLE @gt_bsik.

    ENDIF.

    IF gt_bsik IS NOT INITIAL.

      IF s_lifnr IS NOT INITIAL.

        SELECT lifnr,name1                              "#EC CI_NO_TRANSFORM
         FROM lfa1
         FOR ALL ENTRIES IN @gt_bsik
         WHERE lifnr = @gt_bsik-lifnr
         AND lifnr IN @s_lifnr
         INTO TABLE @gt_lfa1.

      ELSE.

        SELECT lifnr,name1                              "#EC CI_NO_TRANSFORM
         FROM lfa1
         FOR ALL ENTRIES IN @gt_bsik
         WHERE lifnr = @gt_bsik-lifnr
         INTO TABLE @gt_lfa1.

      ENDIF.
    ENDIF.

    SELECT  usuario_sap,belnr_concat,
            status,data_criacao,
            data_modificacao,belnr,
            gjahr,buzei
     FROM zjgpt_grupo2
     FOR ALL ENTRIES IN @lt_bseg_aux_belnr
     WHERE belnr = @lt_bseg_aux_belnr-belnr
     INTO TABLE @gt_zjgpt_grupo2.

  ENDIF.

  IF gt_bseg IS NOT INITIAL.

    SELECT bukrs,butxt
     FROM t001
     FOR ALL ENTRIES IN @gt_bseg
     WHERE bukrs EQ @gt_bseg-bukrs
     AND bukrs IN @s_bukrs
     INTO TABLE @gt_t001.

  ENDIF.

ENDFORM.

FORM f_processa_dados.


  SORT: gt_bseg BY belnr,
        gt_bsik BY belnr bukrs lifnr,
        gt_lfa1 BY lifnr,
        gt_t001 BY bukrs,
        gt_zjgpt_grupo2 BY belnr buzei gjahr.

  DATA ls_dados LIKE LINE OF gt_saida1.

  LOOP AT gt_bseg ASSIGNING FIELD-SYMBOL(<fs_bseg>).

    CLEAR ls_dados.

    ls_dados-belnr = <fs_bseg>-belnr.
    ls_dados-gjahr = <fs_bseg>-gjahr.
    ls_dados-buzei = <fs_bseg>-buzei.
    ls_dados-dmbtr = <fs_bseg>-dmbtr.

    READ TABLE gt_bsik ASSIGNING FIELD-SYMBOL(<fs_bsik>) WITH KEY belnr = <fs_bseg>-belnr BINARY SEARCH.

    IF sy-subrc IS INITIAL.

      ls_dados-umskz = <fs_bsik>-umskz.
      ls_dados-augdt = <fs_bsik>-augdt.
      ls_dados-augbl = <fs_bsik>-augbl.
      ls_dados-zuonr = <fs_bsik>-zuonr.

    ENDIF.

    READ TABLE gt_lfa1 ASSIGNING FIELD-SYMBOL(<fs_lfa1>) WITH KEY lifnr = <fs_bseg>-lifnr BINARY SEARCH.

    IF sy-subrc IS INITIAL.

      ls_dados-lifnr = <fs_lfa1>-lifnr.
      ls_dados-name1 = <fs_lfa1>-name1.

    ENDIF.

    READ TABLE gt_t001 ASSIGNING FIELD-SYMBOL(<fs_t001>) WITH KEY bukrs = <fs_bsik>-bukrs BINARY SEARCH.

    IF sy-subrc IS INITIAL.

      ls_dados-bukrs = <fs_t001>-bukrs.
      ls_dados-butxt = <fs_t001>-butxt.

    ENDIF.

    READ TABLE gt_zjgpt_grupo2 ASSIGNING FIELD-SYMBOL(<fs_tabelaz>) WITH KEY belnr = <fs_bseg>-belnr buzei = <fs_bseg>-buzei gjahr = <fs_bseg>-gjahr BINARY SEARCH.

    IF sy-subrc IS INITIAL.

      ls_dados-usuario_sap = <fs_tabelaz>-usuario_sap.
      ls_dados-belnr_concat = <fs_tabelaz>-belnr_concat.
      ls_dados-status = <fs_tabelaz>-status.
      ls_dados-data_criacao = <fs_tabelaz>-data_criacao.
      ls_dados-data_modificacao = <fs_tabelaz>-data_modificacao.

    ENDIF.

    APPEND ls_dados TO gt_saida1.

  ENDLOOP.

    PERFORM f_concat.

ENDFORM.

FORM f_nao_permite_dados_em_branco.

  LOOP AT gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>).

    IF <fs_saida>-usuario_sap IS INITIAL OR <fs_saida>-belnr_concat  IS INITIAL OR <fs_saida>-status IS INITIAL.

      MESSAGE ID 'ZJGP_GRUPO2' TYPE 'S' NUMBER 004 DISPLAY LIKE 'E'.

      gv_erro = 1.

    ENDIF.

  ENDLOOP.

ENDFORM.