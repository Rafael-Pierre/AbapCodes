*&---------------------------------------------------------------------*
*& Include zrpmi_doc_vendas_oo_def
*&---------------------------------------------------------------------*

CLASS lcl_main DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_vbak,
             bukrs_vf TYPE vbak-bukrs_vf,
             kunnr    TYPE vbak-kunnr,
             erdat    TYPE vbak-erdat,
             vbeln    TYPE vbak-vbeln,
           END OF ty_vbak,

           BEGIN OF ty_vbap,
             posnr TYPE vbap-posnr,
             matnr TYPE vbap-matnr,
             matkl TYPE vbap-matkl,
             netwr TYPE vbap-netwr,
             vbeln TYPE vbap-vbeln,
           END OF ty_vbap,

           BEGIN OF ty_makt,
             maktx TYPE makt-maktx,
             matnr TYPE makt-matnr,
           END OF ty_makt,

           BEGIN OF ty_t001,
             butxt TYPE t001-butxt,
             bukrs TYPE t001-bukrs,
           END OF ty_t001,

           BEGIN OF ty_kna1,
             name1 TYPE kna1-name1,
             kunnr TYPE kna1-kunnr,
           END OF ty_kna1,

           BEGIN OF ty_dados,
             bukrs_vf    TYPE vbak-bukrs_vf,
             butxt       TYPE t001-butxt,
             concatenate TYPE char30,
             kunnr       TYPE vbak-kunnr,
             name1       TYPE kna1-name1,
             erdat       TYPE vbak-erdat,
             vbeln       TYPE vbak-vbeln,
             posnr       TYPE vbap-posnr,
             matnr       TYPE vbap-matnr,
             maktx       TYPE makt-maktx,
             matkl       TYPE vbap-matkl,
             netwr       TYPE vbap-netwr,
           END OF ty_dados,

           BEGIN OF ty_dados_h,
             bukrs TYPE vbak-bukrs_vf,
             butxt TYPE t001-butxt,
           END OF ty_dados_h.


    DATA: gt_vbak         TYPE TABLE OF ty_vbak,
          gt_vbap         TYPE TABLE OF ty_vbap,
          gt_makt         TYPE TABLE OF ty_makt,
          gt_t001         TYPE TABLE OF ty_t001,
          gt_kna1         TYPE TABLE OF ty_kna1,
          gt_dados        TYPE TABLE OF ty_dados,
          gt_dados_header TYPE TABLE OF ty_dados_h,
          gt_dados_cds    TYPE TABLE OF zi_rpm_doc_vendas.

    DATA: gt_fieldcat_grid TYPE lvc_t_fcat.

    METHODS:
      m_main.

  PRIVATE SECTION.

    METHODS:
      m_select,
      m_process,
      m_preenche_h,
      m_fill_fieldcat,
      m_call_fieldcat,
      m_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid IMPORTING e_row_id e_column_id.

ENDCLASS.