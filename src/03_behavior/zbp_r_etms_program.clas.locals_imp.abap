*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type definitions

*----------------------------------------------------------------------*
* Generated - Global Authorization Handler
*----------------------------------------------------------------------*
CLASS lhc_zr_etms_program DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
      REQUEST requested_authorizations FOR trainingprogram
      RESULT result.
ENDCLASS.

CLASS lhc_zr_etms_program IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
ENDCLASS.

*----------------------------------------------------------------------*
* Local Handler Class for Training Program entity
*----------------------------------------------------------------------*
CLASS lhc_trainingprogram DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS set_default_status FOR DETERMINE ON MODIFY
      IMPORTING keys FOR trainingprogram~setdefaultstatus.

    METHODS validate_dates FOR VALIDATE ON SAVE
      IMPORTING keys FOR trainingprogram~validatedates.

    METHODS validate_capacity FOR VALIDATE ON SAVE
      IMPORTING keys FOR trainingprogram~validatecapacity.

ENDCLASS.

CLASS lhc_trainingprogram IMPLEMENTATION.

  METHOD set_default_status.

    READ ENTITIES OF zr_etms_program IN LOCAL MODE
      ENTITY trainingprogram
        FIELDS ( status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_programs)
      FAILED DATA(lt_failed).

    DATA lt_update TYPE TABLE FOR UPDATE zr_etms_program\\trainingprogram.

    LOOP AT lt_programs INTO DATA(ls_program).
      IF ls_program-status IS INITIAL.
        APPEND VALUE #(
          %tky            = ls_program-%tky
          status          = 'PLAN'
          %control-status = if_abap_behv=>mk-on
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_etms_program IN LOCAL MODE
        ENTITY trainingprogram
          UPDATE FIELDS ( status )
          WITH lt_update
        REPORTED DATA(lt_reported).
    ENDIF.

  ENDMETHOD.

  METHOD validate_dates.

    READ ENTITIES OF zr_etms_program IN LOCAL MODE
      ENTITY trainingprogram
        FIELDS ( startdate enddate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_programs)
      FAILED DATA(lt_failed).

    LOOP AT lt_programs INTO DATA(ls_program).

      IF ls_program-startdate IS NOT INITIAL
      AND ls_program-enddate IS NOT INITIAL
      AND ls_program-enddate <= ls_program-startdate.

        APPEND VALUE #( %tky = ls_program-%tky )
          TO failed-trainingprogram.

        APPEND VALUE #(
          %tky               = ls_program-%tky
          %state_area        = 'VALIDATE_DATES'
          %msg               = new_message(
                                 id       = 'ZETMS_MESSAGES'
                                 number   = '001'
                                 severity = if_abap_behv_message=>severity-error
                               )
          %element-startdate = if_abap_behv=>mk-on
          %element-enddate   = if_abap_behv=>mk-on
        ) TO reported-trainingprogram.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validate_capacity.

    READ ENTITIES OF zr_etms_program IN LOCAL MODE
      ENTITY trainingprogram
        FIELDS ( maxcapacity )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_programs)
      FAILED DATA(lt_failed).

    LOOP AT lt_programs INTO DATA(ls_program).

      IF ls_program-maxcapacity <= 0.

        APPEND VALUE #( %tky = ls_program-%tky )
          TO failed-trainingprogram.

        APPEND VALUE #(
          %tky                 = ls_program-%tky
          %state_area          = 'VALIDATE_CAPACITY'
          %msg                 = new_message(
                                   id       = 'ZETMS_MESSAGES'
                                   number   = '002'
                                   severity = if_abap_behv_message=>severity-error
                                 )
          %element-maxcapacity = if_abap_behv=>mk-on
        ) TO reported-trainingprogram.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*----------------------------------------------------------------------*
* Local Handler Class for Enrollment entity
*----------------------------------------------------------------------*
CLASS lhc_enrollment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS set_enrollment_defaults FOR DETERMINE ON MODIFY
      IMPORTING keys FOR enrollment~setenrollmentdefaults.

    METHODS validate_enrollment FOR VALIDATE ON SAVE
      IMPORTING keys FOR enrollment~validateenrollment.

    METHODS validate_score FOR VALIDATE ON SAVE
      IMPORTING keys FOR enrollment~validatescore.

ENDCLASS.

CLASS lhc_enrollment IMPLEMENTATION.

  METHOD set_enrollment_defaults.

    READ ENTITIES OF zr_etms_program IN LOCAL MODE
      ENTITY enrollment
        FIELDS ( status enrollmentdate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_enrollments)
      FAILED DATA(lt_failed).

    DATA lt_update TYPE TABLE FOR UPDATE zr_etms_program\\enrollment.

    LOOP AT lt_enrollments INTO DATA(ls_enrollment).

      DATA(lv_status)  = ls_enrollment-status.
      DATA(lv_date)    = ls_enrollment-enrollmentdate.
      DATA(lv_changed) = abap_false.

      IF ls_enrollment-status IS INITIAL.
        lv_status  = 'PLAN'.
        lv_changed = abap_true.
      ENDIF.

      IF ls_enrollment-enrollmentdate IS INITIAL.
        lv_date    = cl_abap_context_info=>get_system_date( ).
        lv_changed = abap_true.
      ENDIF.

      IF lv_changed = abap_true.
        APPEND VALUE #(
          %tky                    = ls_enrollment-%tky
          status                  = lv_status
          enrollmentdate          = lv_date
          %control-status         = if_abap_behv=>mk-on
          %control-enrollmentdate = if_abap_behv=>mk-on
        ) TO lt_update.
      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_etms_program IN LOCAL MODE
        ENTITY enrollment
          UPDATE FIELDS ( status enrollmentdate )
          WITH lt_update
        REPORTED DATA(lt_reported).
    ENDIF.

  ENDMETHOD.

  METHOD validate_enrollment.

    READ ENTITIES OF zr_etms_program IN LOCAL MODE
      ENTITY enrollment
        FIELDS ( programid employeeid enrollmentid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_enrollments)
      FAILED DATA(lt_failed).

    LOOP AT lt_enrollments INTO DATA(ls_enrollment).

      SELECT SINGLE enrollment_id
        FROM zetms_enrollment
        WHERE program_id    = @ls_enrollment-programid
          AND employee_id   = @ls_enrollment-employeeid
          AND enrollment_id <> @ls_enrollment-enrollmentid
        INTO @DATA(lv_existing).

      IF sy-subrc = 0.

        APPEND VALUE #( %tky = ls_enrollment-%tky )
          TO failed-enrollment.

        APPEND VALUE #(
          %tky                = ls_enrollment-%tky
          %state_area         = 'VALIDATE_ENROLLMENT'
          %msg                = new_message(
                                  id       = 'ZETMS_MESSAGES'
                                  number   = '003'
                                  severity = if_abap_behv_message=>severity-error
                                )
          %element-EmployeeID = if_abap_behv=>mk-on
        ) TO reported-enrollment.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validate_score.

    READ ENTITIES OF zr_etms_program IN LOCAL MODE
      ENTITY enrollment
        FIELDS ( completionscore )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_enrollments)
      FAILED DATA(lt_failed).

    CONSTANTS lc_max_score TYPE zetms_de_comp_score VALUE '100.00'.

    LOOP AT lt_enrollments INTO DATA(ls_enrollment).

      IF ls_enrollment-completionscore IS NOT INITIAL
      AND ls_enrollment-completionscore > lc_max_score.

        " Block the save for enrollment
        APPEND VALUE #( %tky = ls_enrollment-%tky )
          TO failed-enrollment.

        " Report message on enrollment entity
        APPEND VALUE #(
          %tky                     = ls_enrollment-%tky
          %state_area              = 'VALIDATE_SCORE'
          %msg                     = new_message(
                                       id       = 'ZETMS_MESSAGES'
                                       number   = '004'
                                       severity = if_abap_behv_message=>severity-error
                                     )
          %element-CompletionScore = if_abap_behv=>mk-on
        ) TO reported-enrollment.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
