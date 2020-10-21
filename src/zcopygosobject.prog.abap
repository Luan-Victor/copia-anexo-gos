*&---------------------------------------------------------------------*
*& Report ZCOPYGOSOBJECT
*&---------------------------------------------------------------------*
*& Programa que copia o objeto GOS de um objeto para outro
*& Ex: Copia objeto da Req.Compra para o Contrato de Compra
*&---------------------------------------------------------------------*
REPORT zcopygosobject.

*--------------------------------------------------------------------*
* Global Objects
*--------------------------------------------------------------------*
TABLES: tojtb.

DATA: go_gos_service TYPE REF TO cl_gos_service_tools,
      ls_source      TYPE sibflporb,
      ls_target      TYPE sibflporb,
      lt_service_sel TYPE tgos_sels.

*--------------------------------------------------------------------*
* First Screen
*--------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS: p_s_type TYPE tojtb-name OBLIGATORY DEFAULT 'BUS2014',
            p_s_id   TYPE string OBLIGATORY DEFAULT '4600000020',
            p_t_type TYPE tojtb-name OBLIGATORY DEFAULT 'BUS2014',
            p_t_id   TYPE string OBLIGATORY DEFAULT '4600000021'.

SELECTION-SCREEN: END OF BLOCK b1.

*--------------------------------------------------------------------*
* Main event
*--------------------------------------------------------------------*
START-OF-SELECTION.

  CREATE OBJECT go_gos_service.

  ls_source-catid  = 'BO'.
  ls_source-instid = p_s_id.  "'4600000020'.
  ls_source-typeid = p_s_type.                              "'BUS2014'.

  ls_target-catid  = 'BO'.
  ls_target-instid = p_t_id.  "'4600000021'.
  ls_target-typeid = p_t_type.                              "'BUS2014'.

  APPEND INITIAL LINE TO lt_service_sel ASSIGNING FIELD-SYMBOL(<service_sel>).
  <service_sel>-sign   = 'I'.
  <service_sel>-option = 'EQ'.
  <service_sel>-low    = 'PCATTA_CREA'.

  go_gos_service->copy_linked_objects(
    EXPORTING
      is_source            = ls_source                 " Local Persistent Object Reference - BOR Compatible
      is_target            = ls_target                 " Local Persistent Object Reference - BOR Compatible
      it_service_selection = lt_service_sel            " SGOS: Selection Criteria for Service Selection
  ).

  COMMIT WORK AND WAIT.

  MESSAGE 'Anexos copiados'(002) TYPE 'S'.
