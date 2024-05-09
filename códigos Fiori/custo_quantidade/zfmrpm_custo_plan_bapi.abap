FUNCTION zfmrpm_custo_plan_bapi
  IMPORTING
    VALUE(is_headdata) TYPE bapimathead
    VALUE(is_valuationdata) TYPE bapi_mbew OPTIONAL
    VALUE(is_tabela) TYPE zrpmt_custo_plan
  TABLES
    it_tabela LIKE zrpmt_custo_plan.




  DATA: ls_valuationdatax TYPE bapi_mbewx,
        ls_return         TYPE bapiret2,
        lt_log            TYPE TABLE OF  zrpmt_log_fornec,
        ls_aux            TYPE p DECIMALS 2,
        ls_valuationdata  TYPE bapi_mbew.

  DATA ls_log LIKE  LINE OF lt_log.

  ls_valuationdatax-plndprdate1 = abap_true.
  ls_valuationdatax-plndprice1 = abap_true.
  ls_valuationdatax-val_area = is_valuationdata-val_area.

  ls_valuationdata = is_valuationdata.
  ls_aux = is_valuationdata-plndprice1.
  ls_valuationdata-plndprice1 = ls_aux.

  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      headdata       = is_headdata
      valuationdata  = ls_valuationdata
      valuationdatax = ls_valuationdatax
    IMPORTING
      return         = ls_return.


  ls_log-material = is_tabela-material.
  ls_log-data = sy-datum.
  ls_log-hora = sy-uzeit.
  ls_log-fornecedor = is_tabela-fornecedor.
  ls_log-acao = ls_return-message.
  ls_log-usuario = sy-uname.
*  ls_log-status = ls_return-type.


*  return = ls_return.

  APPEND ls_log TO lt_log.

  MODIFY zrpmt_log_fornec FROM TABLE lt_log.



ENDFUNCTION.