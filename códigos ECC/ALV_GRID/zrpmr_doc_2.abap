*&---------------------------------------------------------------------*
*& Report zrpmr_doc_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrpmr_doc_2.


INCLUDE zrpmi_doc_2_top.
INCLUDE zrpmi_doc_2_scr.
INCLUDE zrpmi_doc_2_f01.

START-OF-SELECTION.

  PERFORM f_seleciona_dados.

  IF p_grid = abap_true.

    CALL SCREEN 0001.

  ENDIF.

  IF p_func = abap_true.
    PERFORM f_fieldcat.
  ENDIF.