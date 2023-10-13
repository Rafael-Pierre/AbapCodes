*&---------------------------------------------------------------------*
*& Include zrpmi_clientes_scr
*&---------------------------------------------------------------------*

TABLES: bkpf, kna1.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

  PARAMETERS p_bukrs TYPE bukrs. "Empresa

  SELECT-OPTIONS s_kunnr FOR kna1-kunnr. "Cliente

SELECTION-SCREEN END OF BLOCK b01.


SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-t02.

  SELECT-OPTIONS s_bldat FOR bkpf-bldat. "Data de Lancamento

SELECTION-SCREEN END OF BLOCK b02.