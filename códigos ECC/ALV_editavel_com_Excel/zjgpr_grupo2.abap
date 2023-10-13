*&---------------------------------------------------------------------*
*& Report zjgpr_grupo2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zjgpr_grupo2.



INCLUDE zjgpi_grupo2_top.
INCLUDE zjgpi_grupo2_c01.
INCLUDE zjgpi_grupo2_def.
INCLUDE zjgpi_grupo2_scr.
INCLUDE zjgpi_grupo2_imp.

INCLUDE zjgpi_grupo2_mfs_f01.
INCLUDE zjgpi_grupo2_rda_f01.
INCLUDE zjgpi_grupo2_rpm_f01.
INCLUDE zjgpi_grupo2_joa_f01.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_buscar_arquivos.


START-OF-SELECTION.

  IF p_o1 = abap_true.

    IF p_e1 = abap_true.
      PERFORM f_upload.
    ENDIF.

    IF p_r1 = abap_true.
      PERFORM f_seleciona_dados_loop.
      PERFORM f_processa_dados.

    ELSEIF p_r2 = abap_true.
      PERFORM f_seleciona_dados_join.

    ELSEIF p_r3 = abap_true.
      PERFORM f_seleciona_dados_cds.

    ELSEIF p_r4 = abap_true.
      IF p_e2 = abap_true.
        PERFORM f_seleciona_tabelaz.

      ENDIF.
    ENDIF.
  ENDIF.
  PERFORM f_select_fieldstyle.
  CALL SCREEN 0001.