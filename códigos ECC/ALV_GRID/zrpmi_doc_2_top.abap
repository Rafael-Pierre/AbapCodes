*&---------------------------------------------------------------------*
*& Include zrpmi_doc_2_top
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         lifnr TYPE ekko-lifnr,
       END OF ty_ekko,

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         netwr TYPE ekpo-netwr,
       END OF ty_ekpo,

       BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         land1 TYPE lfa1-land1,
         name1 TYPE lfa1-name1,
       END OF ty_lfa1,

       BEGIN OF ty_t001,
         bukrs TYPE t001-bukrs,
         butxt TYPE t001-butxt,
       END OF ty_t001,

       BEGIN OF ty_dados,
         bukrs TYPE ekko-bukrs,
         lifnr TYPE ekko-lifnr,
         ebeln TYPE ekko-ebeln,
         netwr TYPE ekpo-netwr,
         name1 TYPE lfa1-name1,
         land1 TYPE lfa1-land1,
         butxt TYPE t001-butxt,
       END OF ty_dados.

DATA: gt_ekko  TYPE TABLE OF ty_ekko,
      gt_ekpo  TYPE TABLE OF ty_ekpo,
      gt_lfa1  TYPE TABLE OF ty_lfa1,
      gt_t001  TYPE TABLE OF ty_t001,
      gt_dados TYPE TABLE OF ty_dados.

DATA: gt_fieldcat      TYPE slis_t_fieldcat_alv,
      gs_fieldcat      TYPE slis_fieldcat_alv,
      gt_sort          TYPE slis_t_sortinfo_alv,
      gs_sort          TYPE slis_sortinfo_alv,
      gt_fieldcat_grid TYPE lvc_t_fcat.