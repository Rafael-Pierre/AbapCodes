*&---------------------------------------------------------------------*
*& Include zrpmi_doc_2_scr
*&---------------------------------------------------------------------*

TABLES: ekko, lfa1.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

  PARAMETERS p_bukrs TYPE ekko-bukrs OBLIGATORY.

  SELECT-OPTIONS: s_lifnr FOR ekko-lifnr NO INTERVALS,
                  s_land1 FOR lfa1-land1.

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-t20.

  PARAMETERS: p_grid AS CHECKBOX DEFAULT 'X',
              p_func AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b02.

MODULE status_0001 OUTPUT.
  SET PF-STATUS 'STATUS_0001'.
  SET TITLEBAR  'TITLE_0001'.
ENDMODULE.

MODULE process_before_output_0001 OUTPUT.

  DATA: go_grid             TYPE REF TO cl_gui_alv_grid,
        go_custom_container TYPE REF TO cl_gui_custom_container.


  CREATE OBJECT go_custom_container
    EXPORTING
      container_name = 'CONTAINER_0001'.

  CREATE OBJECT go_grid
    EXPORTING
      i_parent = go_custom_container.

  PERFORM f_alv_grid.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0001 INPUT.

  CASE sy-ucomm.
    WHEN  'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL' OR 'EXIT'.
      LEAVE SCREEN.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.