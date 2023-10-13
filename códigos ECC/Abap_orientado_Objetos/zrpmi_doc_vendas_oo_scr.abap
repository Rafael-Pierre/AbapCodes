*&---------------------------------------------------------------------*
*& Include zrpmi_alv_editavel_scr
*&---------------------------------------------------------------------*

DATA: gv_user               TYPE zrpmt_turmat6-usuario_sap,
      gv_item_conhecimento  TYPE zrpmt_turmat6-item_conhecimento,
      gv_nivel_conhecimento TYPE zrpmt_turmat6-nivel_conhecimento,
      gv_data_criacao       TYPE zrpmt_turmat6-data_criacao.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t03.


  SELECT-OPTIONS: s_user FOR  gv_user,
                  s_item FOR gv_item_conhecimento,
                  s_nivel FOR gv_nivel_conhecimento,
                  s_data FOR gv_data_criacao.


SELECTION-SCREEN END OF BLOCK b01.



MODULE status_0001 OUTPUT.
  SET PF-STATUS 'STATUS_0001'.
  SET TITLEBAR 'TITLE_0001'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PROCESS_BEFORE_OUTPUT_0001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE process_before_output_0001 OUTPUT.

  CREATE OBJECT go_main.
  go_main->m_main( ).


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0001 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT' OR 'CANCEL'.
      LEAVE SCREEN.
    WHEN 'SAVE'.
      go_grid->check_changed_data( ).
      go_main->m_save( ).

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.