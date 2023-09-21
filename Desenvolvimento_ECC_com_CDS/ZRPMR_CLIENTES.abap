*&---------------------------------------------------------------------*
*& Report zrpmr_clientes
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrpmr_clientes.

INCLUDE ZRPMI_CLIENTES_TOP.
INCLUDE ZRPMI_CLIENTES_SCR.
INCLUDE ZRPMI_CLIENTES_C01.
INCLUDE ZRPMI_CLIENTES_f01.

START-OF-SELECTION.

PERFORM f_seleciona_dados.
PERFORM f_exibe_alv.