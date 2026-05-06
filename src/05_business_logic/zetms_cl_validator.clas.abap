CLASS zetms_cl_validator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <p class="shorttext synchronized">Check if program has available capacity</p>
    "! @parameter iv_program_id | Program UUID to check
    "! @raising zcx_etms_error  | Raised if capacity exceeded or program not found
    METHODS check_program_capacity
      IMPORTING
        iv_program_id TYPE sysuuid_x16
      RAISING
        zcx_etms_error.

    "! <p class="shorttext synchronized">Validate status transition for enrollment</p>
    "! @parameter iv_current_status | Current enrollment status
    "! @parameter iv_new_status     | Requested new status
    "! @raising zcx_etms_error      | Raised if transition is invalid
    METHODS check_status_transition
      IMPORTING
        iv_current_status TYPE zetms_de_enrl_status
        iv_new_status     TYPE zetms_de_enrl_status
      RAISING
        zcx_etms_error.

  PROTECTED SECTION.
  PRIVATE SECTION.

    " Valid status transitions map
    " PLAN → ENRL → COMP
    " PLAN → CNCL
    " ENRL → COMP
    " ENRL → CNCL
    METHODS is_valid_transition
      IMPORTING
        iv_from         TYPE zetms_de_enrl_status
        iv_to           TYPE zetms_de_enrl_status
      RETURNING
        VALUE(rv_valid) TYPE abap_boolean.

ENDCLASS.



CLASS zetms_cl_validator IMPLEMENTATION.

  METHOD check_program_capacity.

    " Read program from database
    SELECT SINGLE
      program_id,
      program_name,
      max_capacity
    FROM zetms_program
    WHERE program_id = @iv_program_id
    INTO @DATA(ls_program).

    " Program not found
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etms_error
        EXPORTING
          textid = zcx_etms_error=>program_not_found.
    ENDIF.

    " Count current active enrollments
    SELECT COUNT(*)
      FROM zetms_enrollment
      WHERE program_id = @iv_program_id
        AND status    <> 'CNCL'
      INTO @DATA(lv_enrollment_count).

    " Check if capacity is exceeded
    IF lv_enrollment_count >= ls_program-max_capacity.
      RAISE EXCEPTION TYPE zcx_etms_error
        EXPORTING
          textid       = zcx_etms_error=>capacity_exceeded
          program_name = ls_program-program_name.
    ENDIF.

  ENDMETHOD.

  METHOD check_status_transition.

    IF is_valid_transition(
         iv_from = iv_current_status
         iv_to   = iv_new_status ) = abap_false.

      RAISE EXCEPTION TYPE zcx_etms_error
        EXPORTING
          textid      = zcx_etms_error=>invalid_status_transition
          from_status = iv_current_status
          to_status   = iv_new_status.

    ENDIF.

  ENDMETHOD.

  METHOD is_valid_transition.

    rv_valid = abap_false.

    CASE iv_from.
      WHEN 'PLAN'.
        IF iv_to = 'ENRL' OR iv_to = 'CNCL'.
          rv_valid = abap_true.
        ENDIF.
      WHEN 'ENRL'.
        IF iv_to = 'COMP' OR iv_to = 'CNCL'.
          rv_valid = abap_true.
        ENDIF.
      WHEN OTHERS.
        rv_valid = abap_false.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
