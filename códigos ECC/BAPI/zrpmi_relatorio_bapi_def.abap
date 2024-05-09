*&---------------------------------------------------------------------*
*& Include zrpmi_relatorio_bapi_def
*&---------------------------------------------------------------------*


CLASS lcl_main DEFINITION.


  PUBLIC SECTION.

    TYPES: BEGIN OF ty_dados,
             ordem                 TYPE bapi_order_header1-order_number,
             quantidade_produzir   TYPE bapi_order_header1-target_quantity,
             data_abertura         TYPE bapi_order_header1-production_start_date,
             data_prevista         TYPE bapi_order_header1-production_finish_date,
             quantidade_necessaria TYPE bapi_order_component-req_quan,
             um                    TYPE bapi_order_component-base_uom,
             codigo                TYPE bapi_order_component-material,
             descricao             TYPE makt-maktx,
             operacao              TYPE bapi_order_operation1-operation_number,
             descricao_operacao    TYPE bapi_order_operation1-description,
             maq                   TYPE bapi_order_operation1-work_center,
             fase                  TYPE bapi_order_operation1-work_center_text,
             texto_longo           TYPE afvc_text-tdname,
             tempo_preparacao      TYPE bapi_order_operation1-activity_type_1,
             tempo_producao        TYPE string,
           END OF ty_dados,

           BEGIN OF ty_mara,
             matnr TYPE mara-matnr,
           END OF ty_mara,

           BEGIN OF ty_makt,
             matnr TYPE makt-matnr,
             maktx TYPE makt-maktx,
           END OF ty_makt,

           BEGIN OF ty_afvc,
             aufpl  TYPE afvc_text-aufpl,
             tdname TYPE afvc_text-tdname,
           END OF ty_afvc.




    DATA: gt_fieldcat       TYPE slis_t_fieldcat_alv,
          gs_fieldcat       TYPE slis_fieldcat_alv,

          gt_fieldcat_grid  TYPE lvc_t_fcat,
          gt_fieldcat_grids TYPE lvc_t_sort,

          gt_fcat           TYPE lvc_t_fcat,
          gs_fcat           TYPE lvc_s_fcat,

          gt_sort           TYPE lvc_t_sort,
          gs_sort           TYPE lvc_s_sort.


    DATA: lt_order_data       TYPE STANDARD TABLE OF bapi_order_header1,
          lv_production_order TYPE aufnr,
          gs_order_objects    TYPE bapi_pp_order_objects,
          gt_prod_rel_tool    TYPE TABLE OF bapi_order_prod_rel_tools,
          lt_return           TYPE  bapiret2,
          gt_dados            TYPE TABLE OF ty_dados,
          gs_dados            LIKE LINE OF gt_dados,

          gt_operation        TYPE TABLE OF bapi_order_operation1,
          gt_component        TYPE TABLE OF bapi_order_component,
          gt_header           TYPE TABLE OF bapi_order_header1,

          gt_mara             TYPE TABLE OF ty_mara,
          gs_mara             LIKE LINE OF gt_mara,
          gt_makt             TYPE TABLE OF ty_makt,
          gs_makt             LIKE LINE OF gt_makt,
          gt_afvc             TYPE TABLE OF ty_afvc,
          gs_afvc             LIKE LINE OF gt_afvc.


    METHODS:
      m_main.


  PRIVATE SECTION.

    METHODS:
      m_executa_bapi,
      m_cria_alv.


ENDCLASS.