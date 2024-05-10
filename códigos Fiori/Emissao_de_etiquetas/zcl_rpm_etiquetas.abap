CLASS zcl_rpm_etiquetas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_instance

      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_rpm_etiquetas.

    METHODS build
      IMPORTING
                it_filters    TYPE  if_rap_query_request=>tt_parameters
      RETURNING VALUE(rv_pdf) TYPE ze_rda_rawstring.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA go_instance TYPE REF TO zcl_rpm_etiquetas .

    TYPES: BEGIN OF ty_filters,
             packingtype    TYPE   char40,
             peso_embalagem TYPE   char5,
             quantidade     TYPE   char5,
             peso_liquido   TYPE   char5,
             codigo_remessa TYPE   char10,
             checkbox       TYPE   ze_rda_check,

           END OF ty_filters.

    DATA: gs_filters TYPE ty_filters.



    METHODS get_data
*      IMPORTING
*        iv_SalesOrder     TYPE vdm_sales_order
*        iv_SalesOrderItem TYPE sales_order_item
*        iv_Deposito       TYPE lgort_d
      EXPORTING
        es_header TYPE zsrda_etiqueta
        et_item   TYPE zctgsd_lista_carregamento.

    METHODS get_filters
      IMPORTING it_filters TYPE if_rap_query_request=>tt_parameters.

    METHODS get_adobeforms
      IMPORTING
                is_header          TYPE zsrda_etiqueta
*                it_item            TYPE zctgsd_lista_carregamento
      RETURNING VALUE(rv_pdf_file) TYPE xstring.


ENDCLASS.



CLASS zcl_rpm_etiquetas IMPLEMENTATION.

  METHOD build.

    me->get_filters( it_filters ).

    me->get_data( IMPORTING es_header         = DATA(ls_header)
                            et_item           = DATA(lt_item) ).

    CHECK ls_header IS NOT INITIAL.
*          lt_item[] IS NOT INITIAL.

    rv_pdf = me->get_adobeforms( is_header = ls_header ).
*                                 it_item   = lt_item ).

  ENDMETHOD.

  METHOD get_instance.

    IF ( go_instance IS INITIAL ).
      go_instance = NEW zcl_rpm_etiquetas( ).
    ENDIF.

    ro_instance = go_instance.

  ENDMETHOD.



  METHOD get_data.

*    DATA: mo_message_manager TYPE REF TO .

    TYPES: BEGIN OF ty_outbound,

             OutboundDelivery         TYPE I_OutboundDeliveryItem-OutboundDelivery,
             OutboundDeliveryItem     TYPE I_OutboundDeliveryItem-OutboundDeliveryItem,
             deliverydocumentitemtext TYPE I_OutboundDeliveryItem-DeliveryDocumentItemText,
             materialbycustomer       TYPE I_OutboundDeliveryItem-MaterialByCustomer,
             material                 TYPE I_OutboundDeliveryItem-Material,
             referencesddocument      TYPE I_OutboundDeliveryItem-ReferenceSDDocument,

           END OF ty_outbound,

           BEGIN OF ty_material,

             material          TYPE I_material-Material,
             materialnetweight TYPE I_material-materialnetweight,

           END OF ty_material,

           BEGIN OF ty_outdelivery,

             outbounddelivery  TYPE i_outbounddelivery-OutboundDelivery,
             salesorganization TYPE i_outbounddelivery-SalesOrganization,
             shiptoparty       TYPE i_outbounddelivery-ShipToParty,

           END OF ty_outdelivery,

           BEGIN OF ty_customer,

             customer     TYPE I_Customer-Customer,
             customername TYPE I_Customer-CustomerName,
             streetname   TYPE I_Customer-StreetName,
             cityname     TYPE I_Customer-CityName,
             region       TYPE I_Customer-Region,
             postalcode   TYPE I_Customer-PostalCode,

           END OF ty_customer,

           BEGIN OF ty_custsales,

             customer                   TYPE i_custsalespartnerfunc-Customer,
             customerpartnerdescription TYPE i_custsalespartnerfunc-CustomerPartnerDescription,

           END OF ty_custsales,

           BEGIN OF ty_salesgrmt,

             salesschedulingagreement TYPE i_salesschedgagrmt-SalesSchedulingAgreement,
             purchaseorderbycustomer  TYPE i_salesschedgagrmt-PurchaseOrderByCustomer,
*             purchaseorderbycustomer TYPE i_salesschedgagrmt-

           END OF ty_salesgrmt.


    CONSTANTS: lc_class_message  TYPE symsgid VALUE 'ZRDA_ETIQUETAS',
               lc_class_number_0 TYPE symsgno VALUE '000',
               lc_class_number_1 TYPE symsgno VALUE '001',
               lc_class_number_2 TYPE symsgno VALUE '002'.

    DATA: lt_tabela_aux  TYPE TABLE OF zi_rda_etiqueta_pop_up,
          lv_item_remssa TYPE numc06,
          lv_codigo      TYPE numc10,
          lv_peso        TYPE ntgew,
          lt_documento   TYPE TABLE OF ty_outbound,
          lt_material    TYPE TABLE OF ty_material,
          lt_tabela      TYPE TABLE OF ztrda_etq,
          lt_outdelivery TYPE TABLE OF ty_outdelivery,
          lt_customer    TYPE TABLE OF ty_customer,
          lt_custsales   TYPE TABLE OF ty_custsales,
          lt_salesgrmt   TYPE TABLE OF ty_salesgrmt.

    DATA: ls_tabela_aux  LIKE LINE OF lt_tabela_aux,
          ls_documento   LIKE LINE OF lt_documento,
          ls_material    LIKE LINE OF lt_material,
          ls_tabela      LIKE  LINE OF lt_tabela,
          ls_outdelivery LIKE LINE OF lt_outdelivery,
          ls_customer    LIKE LINE OF lt_customer,
          ls_custsales   LIKE LINE OF lt_custsales,
          ls_salesgrmt   LIKE LINE OF lt_salesgrmt.

*    ls_tabela_aux-codigo         = keys[ 1 ]-%param-codigo.
*    ls_tabela_aux-codido_remessa = keys[ 1 ]-%param-codido_remessa.
*    ls_tabela_aux-pesoEmbalagem  = keys[ 1 ]-%param-pesoEmbalagem.
*    ls_tabela_aux-quantidade     = keys[ 1 ]-%param-quantidade.
*    ls_tabela_aux-peso_liquido   = keys[ 1 ]-%param-peso_liquido.
*    ls_tabela_aux-campo_check    = keys[ 1 ]-%param-campo_check.
*    ls_tabela_aux-id             = keys[ 1 ]-%param-id.

    ls_tabela_aux-codigo         = gs_filters-packingtype.
    ls_tabela_aux-codido_remessa = gs_filters-codigo_remessa.
    ls_tabela_aux-pesoEmbalagem  = gs_filters-peso_embalagem.
    ls_tabela_aux-quantidade     = gs_filters-quantidade.
    ls_tabela_aux-peso_liquido   = gs_filters-peso_liquido.
    ls_tabela_aux-campo_check    = gs_filters-checkbox.

    lv_codigo = gs_filters-codigo_remessa.
    lv_peso   = ls_tabela_aux-peso_liquido.
    lv_item_remssa = 10.

*    lv_codigo      =  keys[ 1 ]-%param-codido_remessa.
*    lv_item_remssa =  keys[ 1 ]-%param-id.
*    lv_peso        = ls_tabela_aux-peso_liquido.



    APPEND ls_tabela_aux TO lt_tabela_aux.

    IF lv_codigo IS NOT INITIAL OR lv_item_remssa IS NOT INITIAL.

      SELECT OutboundDelivery,
             OutboundDeliveryItem,
             deliverydocumentitemtext,
             materialbycustomer,
             material,
             referencesddocument
       FROM I_OutboundDeliveryItem
       INTO TABLE @lt_documento
      WHERE OutboundDelivery = @lv_codigo AND OutboundDeliveryItem =  @lv_item_remssa.

    ENDIF.


    READ TABLE lt_documento ASSIGNING FIELD-SYMBOL(<fs_documento>) INDEX 1.

    IF ls_tabela_aux-campo_check EQ 'X'.

      SELECT material,
         materialnetweight
      FROM I_Material
      INTO TABLE @lt_material
      WHERE Material = @<fs_documento>-material.

      READ TABLE lt_material ASSIGNING FIELD-SYMBOL(<fs_material>) INDEX 1.

      ls_tabela_aux-peso_liquido = ls_tabela_aux-peso_liquido * <fs_material>-materialnetweight.

    ENDIF.

    ls_tabela-codigo_remessa = ls_tabela_aux-codido_remessa.
    ls_tabela-packaging      =  ls_tabela_aux-codigo.
    ls_tabela-peso_bruto     = ls_tabela_aux-pesoEmbalagem + ls_tabela_aux-peso_liquido.
    ls_tabela-peso_embalagem = ls_tabela_aux-pesoEmbalagem.
    ls_tabela-peso_liquido   = ls_tabela_aux-peso_liquido.
    ls_tabela-quantidade     = ls_tabela_aux-quantidade.


    APPEND ls_tabela TO lt_tabela.

    MODIFY ztrda_etq FROM ls_tabela.

    SELECT outbounddelivery,
           salesorganization,
           shiptoparty
    FROM i_outbounddelivery
    INTO TABLE @lt_outdelivery
    WHERE OutboundDelivery = @lv_codigo.

    READ TABLE lt_outdelivery ASSIGNING FIELD-SYMBOL(<fs_outdelivery>) INDEX 1.

    SELECT customer,
           customername,
           streetname,
           cityname,
           region,
           postalcode
    INTO TABLE @lt_customer
    FROM i_customer WHERE Customer = @<fs_outdelivery>-shiptoparty.

    READ TABLE lt_customer ASSIGNING FIELD-SYMBOL(<fs_customer>) INDEX 1.


    SELECT customer,
           customerpartnerdescription
    FROM i_custsalespartnerfunc
    INTO TABLE @lt_custsales
    WHERE Customer = @<fs_outdelivery>-shiptoparty
         AND SalesOrganization = @<fs_outdelivery>-salesorganization.
*         AND PartnerFunction = 'SH'.

    READ TABLE lt_custsales ASSIGNING FIELD-SYMBOL(<fs_custsales>) INDEX 1.

    SELECT purchaseorderbycustomer,
           salesschedulingagreement
    INTO TABLE @lt_salesgrmt
    FROM i_salesschedgagrmt
    WHERE SalesSchedulingAgreement = @<fs_documento>-referencesddocument .

    READ TABLE lt_salesgrmt ASSIGNING FIELD-SYMBOL(<fs_salesgrmt>) INDEX 1.



    DATA: lv_concatenated_value TYPE string.

    CONCATENATE <fs_customer>-cityname
                ','
                <fs_customer>-region
                '-'
                <fs_customer>-postalcode
      INTO lv_concatenated_value.


    DATA: lv_count TYPE i.

    SELECT COUNT( * ) INTO lv_count FROM ztrda_etq WHERE codigo_remessa <> ''.

    DATA: lv_barcode           TYPE string,
          lv_sequential_number TYPE numc10.

    lv_sequential_number = lv_count + 1.

    CONCATENATE '1J' 'UN' '000315066' lv_sequential_number INTO lv_barcode.


    es_header-cep                = <fs_customer>-postalcode.
    es_header-cidade             = <fs_customer>-cityname.
    es_header-codigo             = lv_codigo.
    es_header-data               = sy-datum.
    es_header-descricao_item     = <fs_documento>-deliverydocumentitemtext.
    es_header-item = 10.
    es_header-material_cliente   = <fs_documento>-materialbycustomer.
    es_header-material_descricao = <fs_documento>-material.
    es_header-nome_cliente       = <fs_customer>-customername.
    es_header-pedido_compra      = 'teste'.
    es_header-peso_bruto         = gs_filters-peso_liquido + gs_filters-peso_embalagem.
    es_header-peso_liquido       = gs_filters-peso_liquido.
    es_header-planta             = <fs_custsales>-customerpartnerdescription.
    es_header-qtd_remessa        = gs_filters-quantidade.
    es_header-regiao             = lv_concatenated_value.
    es_header-rua                = <fs_customer>-streetname.


  ENDMETHOD.

  METHOD get_filters.

    DATA lr_packingtype       TYPE string VALUE 'PACKINGTYPE'.
    DATA lr_peso_embalagem    TYPE string VALUE 'PESO_EMBALAGEM'.
    DATA lr_quantidade        TYPE string VALUE 'QUANTIDADE'.
    DATA lr_peso_liquido      TYPE string VALUE 'PESO_LIQUIDO'.
    DATA lr_codigo_remessa    TYPE string VALUE 'CODIGO_REMESSA'.
    DATA lr_checkbox          TYPE string VALUE 'CHECKBOX'.

    LOOP AT it_filters ASSIGNING FIELD-SYMBOL(<fs_filters>).
*
      CASE <fs_filters>-parameter_name.
        WHEN lr_packingtype.
          gs_filters-packingtype    = <fs_filters>-value .
        WHEN lr_peso_embalagem.
          gs_filters-peso_embalagem = <fs_filters>-value .
        WHEN lr_quantidade.
          gs_filters-quantidade     = <fs_filters>-value.
        WHEN lr_peso_liquido.
          gs_filters-peso_liquido   = <fs_filters>-value.
        WHEN lr_codigo_remessa.
          gs_filters-codigo_remessa = <fs_filters>-value .
        WHEN lr_checkbox.
          gs_filters-checkbox       = <fs_filters>-value .

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.



  METHOD get_adobeforms.

    DATA lv_fmname             TYPE funcname.
    DATA lv_formulario         TYPE fpname VALUE 'ZAFRDA_ETIQUETA'.
    DATA lv_err_string         TYPE string.
    DATA ls_outputpar          TYPE sfpoutputparams.
    DATA ls_docparams          TYPE sfpdocparams.
    DATA ls_control_parameters TYPE ssfctrlop.
    DATA ls_joboutput          TYPE sfpjoboutput.
    DATA ls_fp_formoutput      TYPE fpformoutput.
    DATA ls_langu              TYPE spras  VALUE 'P'.
    DATA lo_exc_api            TYPE REF TO cx_fp_api.
    DATA lr_error              TYPE string VALUE 'E'.

    CONSTANTS: lc_tddest  TYPE rspopname VALUE 'LP01',
               lc_printer TYPE fpmedium VALUE 'PRINTER'.

    TRY.
        " Obter o nome da função do formulário
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_formulario
          IMPORTING
            e_funcname = lv_fmname.

      CATCH cx_fp_api_repository
      cx_fp_api_usage
      cx_fp_api_internal
      INTO lo_exc_api.

        lv_err_string = lo_exc_api->get_text( ).

        MESSAGE lv_err_string TYPE lr_error.

        IF sy-subrc <> 0.

          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

        ENDIF.

    ENDTRY.

    ls_outputpar-dest = lc_tddest.
    ls_outputpar-getpdf   = abap_on.
    ls_outputpar-reqnew = abap_true.

    " Abrir job para o formulário
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_outputpar
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.

    IF NOT sy-subrc IS INITIAL.

      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    ENDIF.

    ls_docparams-langu = ls_langu.

    " Abrir o formulário
    CALL FUNCTION lv_fmname
      EXPORTING
        /1bcdwb/docparams  = ls_docparams
*       gt_carreg          = it_item
        gs_dados           = is_header
      IMPORTING
        /1bcdwb/formoutput = ls_fp_formoutput
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        OTHERS             = 4.

    rv_pdf_file = ls_fp_formoutput-pdf.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    " Fechar o job
    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.

    IF NOT sy-subrc IS INITIAL.

      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    ENDIF.

  ENDMETHOD.

ENDCLASS.