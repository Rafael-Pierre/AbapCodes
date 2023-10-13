*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_def
*&---------------------------------------------------------------------*

CLASS lcl_main_ob DEFINITION.

  PUBLIC SECTION.

    METHODS:
      m_main_oo,
      m_save_oo.

  PRIVATE SECTION.

    METHODS:
      m_seleciona_dados_join,
      m_seleciona_dados_loop,
      m_seleciona_dados_cds,
      m_processa_dados,
      m_inclusao_dts,
      m_nao_permite_dados_em_branco,
      m_concat,
      m_seleciona_tabelaz,
      m_campos_disabled,
      m_select_oo,
      m_upload,
      m_exibir_alv_oo,
      m_fieldcat_oo CHANGING ct_fieldcat TYPE lvc_t_fcat,
      m_data_changed FOR EVENT data_changed OF cl_gui_alv_grid IMPORTING er_data_changed e_onf4 e_onf4_before e_onf4_after.

ENDCLASS.

DATA: go_main_ob TYPE REF TO lcl_main_ob.