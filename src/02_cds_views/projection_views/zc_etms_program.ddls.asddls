@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Projection View - ETMS Training Programs'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZETMS_PROGRAM'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_ETMS_PROGRAM
  provider contract transactional_query
  as projection on ZR_ETMS_PROGRAM
  association [1..1] to ZR_ETMS_PROGRAM  as _BaseEntity on $projection.PROGRAMID = _BaseEntity.PROGRAMID
  association [0..1] to ZI_ETMS_CATEGORY as _Category   on $projection.CategoryCode = _Category.CategoryCode
{
  key ProgramID,
      ProgramName,
      CategoryCode,
      MaxCapacity,
      CostPerSeat,
      @Consumption: {
        valueHelpDefinition: [ {
          entity.element: 'Currency',
          entity.name: 'I_CurrencyStdVH',
          useForValidation: true
        } ]
      }
      CurrencyCode,
      StartDate,
      EndDate,
      Status,
      @Semantics: {
        user.createdBy: true
      }
      CreatedBy,
      @Semantics: {
        systemDateTime.createdAt: true
      }
      CreatedAt,
      @Semantics: {
        user.lastChangedBy: true
      }
      LastChangedBy,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      LastChangedAt,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      _BaseEntity,
      _Category,
      _Enrollments : redirected to composition child ZC_ETMS_ENROLLMENT
}
