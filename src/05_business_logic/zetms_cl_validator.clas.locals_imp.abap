*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*----------------------------------------------------------------------*
* Test Helper
*----------------------------------------------------------------------*
CLASS ltc_test_helper DEFINITION.
  PUBLIC SECTION.
    TYPES: ty_employee_id TYPE c LENGTH 10.

    CLASS-METHODS:
      create_test_program
        IMPORTING
          iv_capacity  TYPE zetms_de_max_capacity
        RETURNING
          VALUE(rv_id) TYPE sysuuid_x16,

      create_test_enrollment
        IMPORTING
          iv_program_id  TYPE sysuuid_x16
          iv_employee_id TYPE ty_employee_id
          iv_status      TYPE zetms_de_enrl_status,

      cleanup_test_data
        IMPORTING
          iv_program_id TYPE sysuuid_x16.
ENDCLASS.

CLASS ltc_test_helper IMPLEMENTATION.

  METHOD create_test_program.
    TRY.
        rv_id = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    INSERT zetms_program FROM @( VALUE #(
      client       = sy-mandt
      program_id   = rv_id
      program_name = 'TEST PROGRAM'
      max_capacity = iv_capacity
      status       = 'PLAN'
    ) ).
  ENDMETHOD.

  METHOD create_test_enrollment.
    DATA lv_enrl_id TYPE sysuuid_x16.
    TRY.
        lv_enrl_id = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    INSERT zetms_enrollment FROM @( VALUE #(
      client        = sy-mandt
      enrollment_id = lv_enrl_id
      program_id    = iv_program_id
      employee_id   = iv_employee_id
      status        = iv_status
    ) ).
  ENDMETHOD.

  METHOD cleanup_test_data.
    DELETE FROM zetms_enrollment
      WHERE program_id = @iv_program_id.
    DELETE FROM zetms_program
      WHERE program_id = @iv_program_id.
    ROLLBACK WORK.
  ENDMETHOD.

ENDCLASS.

*----------------------------------------------------------------------*
* Unit Test Class
*----------------------------------------------------------------------*
CLASS ltc_validator DEFINITION
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    DATA mo_validator  TYPE REF TO zetms_cl_validator.
    DATA mv_program_id TYPE sysuuid_x16.

    METHODS setup.
    METHODS teardown.
    METHODS check_capacity_pass      FOR TESTING.
    METHODS check_capacity_fail      FOR TESTING.
    METHODS check_transition_valid   FOR TESTING.
    METHODS check_transition_invalid FOR TESTING.
    METHODS check_program_not_found  FOR TESTING.
ENDCLASS.

CLASS ltc_validator IMPLEMENTATION.

  METHOD setup.
    mo_validator = NEW zetms_cl_validator( ).
  ENDMETHOD.

  METHOD teardown.
    IF mv_program_id IS NOT INITIAL.
      ltc_test_helper=>cleanup_test_data( mv_program_id ).
    ENDIF.
  ENDMETHOD.

  METHOD check_capacity_pass.
    mv_program_id = ltc_test_helper=>create_test_program(
                      iv_capacity = 5 ).
    TRY.
        mo_validator->check_program_capacity(
          iv_program_id = mv_program_id ).

        cl_abap_unit_assert=>assert_true(
          act = abap_true
          msg = 'Capacity check should pass for empty program' ).

      CATCH zcx_etms_error.
        cl_abap_unit_assert=>fail(
          msg = 'Unexpected exception: program has capacity available' ).
    ENDTRY.
  ENDMETHOD.

  METHOD check_capacity_fail.
    mv_program_id = ltc_test_helper=>create_test_program(
                      iv_capacity = 2 ).

    ltc_test_helper=>create_test_enrollment(
      iv_program_id  = mv_program_id
      iv_employee_id = 'EMP001'
      iv_status      = 'ENRL' ).

    ltc_test_helper=>create_test_enrollment(
      iv_program_id  = mv_program_id
      iv_employee_id = 'EMP002'
      iv_status      = 'ENRL' ).

    TRY.
        mo_validator->check_program_capacity(
          iv_program_id = mv_program_id ).

        cl_abap_unit_assert=>fail(
          msg = 'Exception expected: program is at full capacity' ).

      CATCH zcx_etms_error INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->if_t100_message~t100key-msgno
          exp = zcx_etms_error=>capacity_exceeded-msgno
          msg = 'Wrong exception raised for capacity check' ).
    ENDTRY.
  ENDMETHOD.

  METHOD check_transition_valid.
    TRY.
        mo_validator->check_status_transition(
          iv_current_status = 'PLAN'
          iv_new_status     = 'ENRL' ).

        cl_abap_unit_assert=>assert_true(
          act = abap_true
          msg = 'PLAN to ENRL should be a valid transition' ).

      CATCH zcx_etms_error.
        cl_abap_unit_assert=>fail(
          msg = 'PLAN to ENRL is valid but exception was raised' ).
    ENDTRY.
  ENDMETHOD.

  METHOD check_transition_invalid.
    TRY.
        mo_validator->check_status_transition(
          iv_current_status = 'COMP'
          iv_new_status     = 'PLAN' ).

        cl_abap_unit_assert=>fail(
          msg = 'COMP to PLAN is invalid but no exception raised' ).

      CATCH zcx_etms_error INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->if_t100_message~t100key-msgno
          exp = zcx_etms_error=>invalid_status_transition-msgno
          msg = 'Wrong exception raised for invalid transition' ).
    ENDTRY.
  ENDMETHOD.

  METHOD check_program_not_found.
    DATA lv_fake_id TYPE sysuuid_x16.
    TRY.
        lv_fake_id = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    TRY.
        mo_validator->check_program_capacity(
          iv_program_id = lv_fake_id ).

        cl_abap_unit_assert=>fail(
          msg = 'Exception expected: program does not exist' ).

      CATCH zcx_etms_error INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->if_t100_message~t100key-msgno
          exp = zcx_etms_error=>program_not_found-msgno
          msg = 'Wrong exception raised for missing program' ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
