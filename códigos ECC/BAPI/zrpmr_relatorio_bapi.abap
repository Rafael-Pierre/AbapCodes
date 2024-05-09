*&---------------------------------------------------------------------*
*& Report zrpmr_relatorio_bapi
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrpmr_relatorio_bapi.

INCLUDE zrpmi_relatorio_bapi_def.
INCLUDE zrpmi_relatorio_bapi_scr.
INCLUDE zrpmi_relatorio_bapi_imp.

START-OF-SELECTION.

  DATA go_main TYPE REF TO lcl_main.

  CREATE OBJECT go_main.
  go_main->m_main( ).