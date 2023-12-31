*&---------------------------------------------------------------------*
*& Include zjgpi_grupo2_top
*&---------------------------------------------------------------------*

TABLES: bseg, t001, lfa1,zjgpt_grupo2 .

TYPES: BEGIN OF ty_t001,
         bukrs TYPE t001-bukrs,
         butxt TYPE t001-butxt,
       END OF ty_t001,

       BEGIN OF ty_bseg,
         bukrs TYPE bseg-bukrs,
         belnr TYPE bseg-belnr,a
         gjahr TYPE bseg-gjahr,
         buzei TYPE bseg-buzei,
         dmbtr TYPE bseg-dmbtr,
         lifnr TYPE bseg-lifnr,
       END OF ty_bseg,

       BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         name1 TYPE lfa1-name1,
       END OF ty_lfa1,

       BEGIN OF ty_bsik,
         bukrs TYPE bsik_view-bukrs,
         lifnr TYPE bsik_view-lifnr,
         umskz TYPE bsik_view-umskz,
         augdt TYPE bsik_view-augdt,
         augbl TYPE bsik_view-augbl,
         zuonr TYPE bsik_view-zuonr,
         belnr TYPE bsik_view-belnr,
         dmbtr TYPE bsik_view-dmbtr,
       END OF ty_bsik,

       BEGIN OF ty_users,
         bname TYPE usr01-bname,
       END OF ty_users,

       BEGIN OF ty_belnr,
         belnr TYPE zjgpt_grupo2-belnr,
       END OF ty_belnr,

       BEGIN OF ty_excel,
         usuario_sap      TYPE zjgpt_grupo2-usuario_sap,
         status           TYPE zjgpt_grupo2-status,
         belnr            TYPE zjgpt_grupo2-belnr,
         belnr_concat     TYPE zjgpt_grupo2-belnr_concat,
         data_criacao     TYPE zjgpt_grupo2-data_criacao,
         data_modificacao TYPE zjgpt_grupo2-data_modificacao,
       END OF ty_excel,


       BEGIN OF ty_usersap,
         usuario_sap  TYPE zjgpt_grupo2-usuario_sap,
         belnr_concat TYPE zjgpt_grupo2-belnr_concat,

       END OF ty_usersap,

       BEGIN OF ty_tabelaz,
         usuario_sap      TYPE zjgpt_grupo2-usuario_sap,
         belnr_concat     TYPE zjgpt_grupo2-belnr_concat,
         status           TYPE zjgpt_grupo2-status,
         data_criacao     TYPE zjgpt_grupo2-data_criacao,
         data_modificacao TYPE zjgpt_grupo2-data_modificacao,
         belnr            TYPE zjgpt_grupo2-belnr,
         gjahr            TYPE zjgpt_grupo2-gjahr,
         buzei            TYPE zjgpt_grupo2-buzei,
       END OF ty_tabelaz,

       BEGIN OF ty_saida,
         usuario_sap      TYPE zjgpt_grupo2-usuario_sap,
         belnr_concat     TYPE zjgpt_grupo2-belnr_concat,
         status           TYPE zjgpt_grupo2-status,
         data_criacao     TYPE zjgpt_grupo2-data_criacao,
         data_modificacao TYPE zjgpt_grupo2-data_modificacao,
         field_style      TYPE lvc_t_styl,
         bukrs            TYPE t001-bukrs,
         butxt            TYPE t001-butxt,
         belnr            TYPE bseg-belnr,
         gjahr            TYPE bseg-gjahr,
         buzei            TYPE bseg-buzei,
         lifnr            TYPE lfa1-lifnr,
         name1            TYPE lfa1-name1,
         umskz            TYPE bsik_view-umskz,
         augdt            TYPE bsik_view-augdt,
         augbl            TYPE bsik_view-augbl,
         zuonr            TYPE bsik_view-zuonr,
         dmbtr            TYPE bsik_view-dmbtr,
       END OF ty_saida,

       BEGIN OF ty_saida1,
         usuario_sap      TYPE zjgpt_grupo2-usuario_sap,
         belnr_concat     TYPE zjgpt_grupo2-belnr_concat,
         status           TYPE zjgpt_grupo2-status,
         data_criacao     TYPE zjgpt_grupo2-data_criacao,
         data_modificacao TYPE zjgpt_grupo2-data_modificacao,
         bukrs            TYPE t001-bukrs,
         butxt            TYPE t001-butxt,
         belnr            TYPE bseg-belnr,
         gjahr            TYPE bseg-gjahr,
         buzei            TYPE bseg-buzei,
         lifnr            TYPE lfa1-lifnr,
         name1            TYPE lfa1-name1,
         umskz            TYPE bsik_view-umskz,
         augdt            TYPE bsik_view-augdt,
         augbl            TYPE bsik_view-augbl,
         zuonr            TYPE bsik_view-zuonr,
         dmbtr            TYPE bsik_view-dmbtr,
       END OF ty_saida1.

CONSTANTS: gc_users        TYPE char30  VALUE 'USUARIO_SAP',
           gc_belnr_concat TYPE char30  VALUE 'BELNR_CONCAT',
           gc_status       TYPE char30  VALUE 'STATUS',
           gc_dtac         TYPE char30  VALUE 'DATA_CRIACAO',
           gc_dtam         TYPE char30  VALUE 'DATA_MODIFICACAO',
           gc_field_style  TYPE char30  VALUE 'FIELD_STYLE',
           gc_bukrs        TYPE char30  VALUE 'BUKRS',
           gc_butxt        TYPE char30  VALUE 'BUTXT',
           gc_belnr        TYPE char30  VALUE 'BELNR',
           gc_gjahr        TYPE char30  VALUE 'GJAHR',
           gc_buzei        TYPE char30  VALUE 'BUZEI',
           gc_lifnr        TYPE char30  VALUE 'LIFNR',
           gc_name1        TYPE char30  VALUE 'NAME1',
           gc_umskz        TYPE char30  VALUE 'UMSKZ',
           gc_augdt        TYPE char30  VALUE 'AUGDT',
           gc_augbl        TYPE char30  VALUE 'AUGBL',
           gc_zuonr        TYPE char30  VALUE 'ZUONR',
           gc_dmbtr        TYPE char30  VALUE 'DMBTR'.

TYPE-POOLS: truxs.
DATA: go_custom_container TYPE REF TO cl_gui_custom_container,
      gt_bsik             TYPE TABLE OF ty_bsik,
      gt_bseg             TYPE TABLE OF ty_bseg,
      gt_t001             TYPE TABLE OF ty_t001,
      gt_lfa1             TYPE TABLE OF ty_lfa1,
      gt_zjgpt_grupo2     TYPE TABLE OF ty_tabelaz,
      gt_saida            TYPE TABLE OF ty_saida,
      gt_saida1           TYPE TABLE OF ty_saida1,
      gt_users            TYPE TABLE OF ty_users,
      gs_saida            LIKE LINE OF gt_saida,
      gt_fieldcat         TYPE lvc_t_fcat,
      gs_layout           TYPE lvc_s_layo,
      go_grid             TYPE REF TO cl_gui_alv_grid,
      gt_raw              TYPE truxs_t_text_data,
      gt_usr01            TYPE TABLE OF ty_users,
      gv_erro             TYPE i,
      gt_edit             TYPE TABLE OF zjgpt_grupo2,
      gs_edit             LIKE LINE OF gt_edit,
      gt_edit_aux         TYPE TABLE OF zjgpt_grupo2,
      gt_usersap          TYPE TABLE OF ty_usersap,
      gt_tabelaz          TYPE TABLE OF ty_excel,
      gs_tabelaz          LIKE LINE OF gt_tabelaz,
      gt_entrada          TYPE TABLE OF ty_tabelaz,
      gv_variavel_aux     TYPE i.
      gv_variavel_aux = 0.
      gv_erro = 0.