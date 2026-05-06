@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Projection View - ETMS Enrollments'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZETMS_ENROLLMENT'
}
@AccessControl.authorizationCheck: #MANDATORY
define view entity ZC_ETMS_ENROLLMENT
//  provider contract transactional_query
  as projection on ZR_ETMS_ENROLLMENT
//  association [1..1] to ZR_ETMS_ENROLLMENT as _BaseEntity on $projection.EnrollmentID = _BaseEntity.EnrollmentID
{
  key EnrollmentID,
  ProgramID,
  EmployeeID,
  EmployeeName,
  EnrollmentDate,
  Status,
  CompletionScore,
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
//  _BaseEntity
    _Program: redirected to parent ZC_ETMS_PROGRAM
}
