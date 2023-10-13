*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_joa_f01
*&---------------------------------------------------------------------*

FORM f_seleciona_dados_cds.

  SELECT usuario_sap,belnr_concat,status,
         data_criacao,data_modificacao,bukrs,
         butxt,belnr,gjahr,
         buzei,lifnr,name1,
         umskz,augdt,augbl,
         zuonr,dmbtr
   FROM zi_jgp_grupo02
   INTO TABLE @gt_saida1
   WHERE bukrs IN @s_bukrs
        AND belnr IN @s_belnr
        AND augbl IN @s_augbl
        AND lifnr IN @s_lifnr
        AND zuonr IN @s_zuonr.

  PERFORM f_concat.

ENDFORM.

FORM f_concat.

  LOOP AT gt_saida1 ASSIGNING FIELD-SYMBOL(<fs_saida1>).

    CONCATENATE <fs_saida1>-belnr(3) <fs_saida1>-belnr+7(3) INTO <fs_saida1>-belnr_concat.

  ENDLOOP.

ENDFORM.