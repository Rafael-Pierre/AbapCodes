*&---------------------------------------------------------------------*
*& Include zrpmi_clientes_c01
*&---------------------------------------------------------------------*

CLASS lcl_handle_events DEFINITION.

  PUBLIC SECTION.

    METHODS:
      m_on_double_click FOR EVENT double_click OF cl_salv_events_table

        IMPORTING row column.

ENDCLASS.

CLASS lcl_handle_events IMPLEMENTATION.

  METHOD m_on_double_click.

    DATA ls_dados LIKE LINE OF gt_dados.

    READ TABLE gt_dados INTO ls_dados INDEX row.

    CASE column.

      WHEN 'BELNR'.

        SET PARAMETER ID: 'BLN' FIELD ls_dados-belnr, 'BUK' FIELD ls_dados-bukrs, 'GJR' FIELD ls_dados-gjahr.

        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.