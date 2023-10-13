*&---------------------------------------------------------------------*
*& Include zrpmi_alv_editavel_def
*&---------------------------------------------------------------------*

CLASS lcl_main DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_saida,
             usuario_sap        TYPE zrpmt_turmat6-usuario_sap,
             item_conhecimento  TYPE zrpmt_turmat6-item_conhecimento,
             nivel_conhecimento TYPE zrpmt_turmat6-nivel_conhecimento,
             data_criacao       TYPE zrpmt_turmat6-data_criacao,
             data_modificacao   TYPE zrpmt_turmat6-data_modificacao,
             field_style        TYPE lvc_t_styl,
           END OF ty_saida,

           BEGIN OF ty_users,
             usuario_sap TYPE usr01-bname,
           END OF ty_users.


    CONSTANTS: gc_usuario        TYPE char30 VALUE 'USUARIO_SAP',
               gc_item           TYPE char30 VALUE 'ITEM_CONHECIMENTO',
               gc_nivel          TYPE char30 VALUE 'NIVEL_CONHECIMENTO',
               gc_dt_criacao     TYPE char30 VALUE 'DATA_CRIACAO',
               gc_dt_modificacao TYPE char30 VALUE 'DATA_MODIFICACAO',
               gc_field_style    TYPE char30 VALUE 'FIELD_STYLE'.

    DATA: go_custom_container TYPE REF TO cl_gui_custom_container,
          gt_saida            TYPE TABLE OF ty_saida,
          gt_users            TYPE TABLE OF ty_users,
          gt_fieldcat         TYPE lvc_t_fcat,
          gs_layout           TYPE lvc_s_layo.

    METHODS:
      m_main,
      m_save.

  PRIVATE SECTION.

    METHODS:
      m_select,
      m_exibir_alv,
      m_fieldcat CHANGING ct_fieldcat TYPE lvc_t_fcat,
      m_data_changed FOR EVENT data_changed OF cl_gui_alv_grid IMPORTING er_data_changed e_onf4 e_onf4_before e_onf4_after.

ENDCLASS.

DATA: go_main TYPE REF TO lcl_main,
      go_grid TYPE REF TO cl_gui_alv_grid.