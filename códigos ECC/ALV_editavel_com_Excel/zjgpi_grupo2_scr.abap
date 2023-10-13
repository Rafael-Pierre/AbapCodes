*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_scr
*&---------------------------------------------------------------------*

DATA: gv_bukrs TYPE t001-bukrs,
      gv_belnr TYPE bseg-belnr,
      gv_augbl TYPE bsik_view-augbl,
      gv_lifnr TYPE lfa1-lifnr,
      gv_zuonr TYPE bsik_view-zuonr.

SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: s_bukrs FOR gv_bukrs OBLIGATORY, "EMPRESA
                  s_belnr FOR gv_belnr OBLIGATORY , "Numero do documento
                  s_augbl FOR gv_augbl, "OBLIGATORY, "Documento compensacao
                  s_lifnr FOR gv_lifnr, "fornecedor
                  s_zuonr FOR gv_zuonr. "atribuicao

  PARAMETERS: p_r1   RADIOBUTTON GROUP rad1 USER-COMMAND abc,
              p_r2   RADIOBUTTON GROUP rad1,
              p_r3   RADIOBUTTON GROUP rad1,
              p_r4   RADIOBUTTON GROUP rad1,
              p_e1   RADIOBUTTON GROUP rad2 MODIF ID id3 USER-COMMAND abcd,
              p_e2   RADIOBUTTON GROUP rad2 MODIF ID id3 DEFAULT 'X',
              p_file TYPE rlgrap-filename MODIF ID id1.

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN: BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-t06.

  PARAMETERS: p_o1 RADIOBUTTON GROUP rad3 DEFAULT 'X',
              p_o2 RADIOBUTTON GROUP rad3.

SELECTION-SCREEN END OF BLOCK b02.



AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF p_e1 = 'X' AND screen-group1 = 'ID1'.
      screen-active = 1.
      MODIFY SCREEN.
      CONTINUE.
    ELSEIF p_e1 = '' AND screen-group1 = 'ID1'.
      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.
    ENDIF.
  ENDLOOP.


  LOOP AT SCREEN.
    IF p_r4 = 'X' AND screen-group1 = 'ID3'.
      screen-active = 1.
      MODIFY SCREEN.
      CONTINUE.
    ELSEIF p_r4 = '' AND screen-group1 = 'ID3'.
      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.
    ENDIF.
  ENDLOOP.


*&---------------------------------------------------------------------*
*& Module STATUS_0001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0001 OUTPUT.
  SET PF-STATUS 'STATUS_001'.
  SET TITLEBAR 'TITLE_001'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module PROCESS_BEFORE_OUTPUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE process_before_output OUTPUT.

  IF p_o1 = abap_true.
    CREATE OBJECT go_main.
    go_main->m_main( ).

  ELSE.

    CREATE OBJECT go_main_ob.
    go_main_ob->m_main_oo( ).

  ENDIF.
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
      IF p_o1 = abap_true.
        go_grid->check_changed_data(  ).
        go_main->m_save( ).
      ELSEIF p_o2 = abap_true.

        go_grid->check_changed_data(  ).
        go_main_ob->m_save_oo( ).

      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.