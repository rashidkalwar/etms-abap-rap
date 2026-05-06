CLASS zcx_etms_error DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      BEGIN OF program_not_found,
        msgid TYPE symsgid     VALUE 'ZETMS_MESSAGES',
        msgno TYPE symsgno     VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF program_not_found,

      BEGIN OF invalid_status_transition,
        msgid TYPE symsgid      VALUE 'ZETMS_MESSAGES',
        msgno TYPE symsgno      VALUE '008',
        attr1 TYPE scx_attrname VALUE 'MV_FROM_STATUS',
        attr2 TYPE scx_attrname VALUE 'MV_TO_STATUS',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_status_transition,

      BEGIN OF capacity_exceeded,
        msgid TYPE symsgid      VALUE 'ZETMS_MESSAGES',
        msgno TYPE symsgno      VALUE '009',
        attr1 TYPE scx_attrname VALUE 'MV_PROGRAM_NAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF capacity_exceeded.

    DATA mv_from_status  TYPE zetms_de_prog_status.
    DATA mv_to_status    TYPE zetms_de_enrl_status.
    DATA mv_program_name TYPE zetms_de_prog_name.

    METHODS constructor
      IMPORTING
        !textid       LIKE if_t100_message=>t100key OPTIONAL
        !previous     LIKE previous OPTIONAL
        !from_status  TYPE zetms_de_prog_status     OPTIONAL
        !to_status    TYPE zetms_de_enrl_status     OPTIONAL
        !program_name TYPE zetms_de_prog_name       OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_etms_error IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
    previous = previous
    ).

    " Set instance attributes for message placeholders
    mv_from_status  = from_status.
    mv_to_status    = to_status.
    mv_program_name = program_name.


    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
