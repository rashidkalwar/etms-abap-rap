@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZETMS_ENROLLMENT'
@EndUserText.label: 'Interface View - ETMS Enrollments'
define view entity ZR_ETMS_ENROLLMENT
  as select from zetms_enrollment as Enrollment
  association to parent ZR_ETMS_PROGRAM as _Program on $projection.ProgramID = _Program.ProgramID
{
  key enrollment_id         as EnrollmentID,
      program_id            as ProgramID,
      employee_id           as EmployeeID,
      employee_name         as EmployeeName,
      enrollment_date       as EnrollmentDate,
      status                as Status,
      completion_score      as CompletionScore,
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

      _Program
}
