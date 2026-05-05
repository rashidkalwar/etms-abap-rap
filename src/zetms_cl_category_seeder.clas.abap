CLASS zetms_cl_category_seeder DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS seed_categories
      IMPORTING
        out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zetms_cl_category_seeder IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    seed_categories( out ).

  ENDMETHOD.


  METHOD seed_categories.
    " Define the category records we want to insert
    DATA lt_categories TYPE TABLE OF zetms_category.

    lt_categories = VALUE #(
        ( client        = sy-mandt
          category_code = 'TECH'
          category_name = 'Technical Skills'
          description   = 'Courses covering technical and IT skills' )

        ( client        = sy-mandt
          category_code = 'SOFT'
          category_name = 'Soft Skills'
          description   = 'Communication, leadership and teamwork courses' )

        ( client        = sy-mandt
          category_code = 'COMP'
          category_name = 'Compliance'
          description   = 'Mandatory compliance and regulatory training' )

        ( client        = sy-mandt
          category_code = 'MGMT'
          category_name = 'Management'
          description   = 'Courses for team leads and managers' )

        ( client        = sy-mandt
          category_code = 'SFTY'
          category_name = 'Health & Safety'
          description   = 'Workplace safety and health regulations' )
      ).

    " MODIFY = insert if not exists, update if exists (safe to re-run)
    MODIFY zetms_category FROM TABLE @lt_categories.

    IF sy-subrc = 0.
      out->write( '✅ Categories seeded successfully!' ).
      out->write( |{ lines( lt_categories ) } records inserted/updated.| ).
    ELSE.
      out->write( '❌ Something went wrong. Check sy-subrc.' ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
