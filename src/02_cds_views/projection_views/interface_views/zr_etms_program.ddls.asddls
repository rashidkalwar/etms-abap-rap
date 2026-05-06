@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZETMS_PROGRAM'
@EndUserText.label: 'Interface View - ETMS Training Programs'
define root view entity ZR_ETMS_PROGRAM
  as select from zetms_program as TrainingProgram
  composition [0..*] of ZR_ETMS_ENROLLMENT as _Enrollments
{
  key program_id            as ProgramID,
      program_name          as ProgramName,
      category_code         as CategoryCode,
      max_capacity          as MaxCapacity,
      cost_per_seat         as CostPerSeat,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'I_CurrencyStdVH',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      currency_code         as CurrencyCode,
      start_date            as StartDate,
      end_date              as EndDate,
      status                as Status,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Enrollments
}
