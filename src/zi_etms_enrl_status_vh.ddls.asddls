@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help View - Enrollment Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZI_ETMS_ENRL_STATUS_VH
  as select from I_Language
{
  key cast( 'PLAN' as zetms_de_enrl_status ) as Status,
      cast( 'Planned' as abap.char(20) )     as StatusText
}
where
  Language = $session.system_language
union all select from I_Language
{
  key cast( 'ENRL' as zetms_de_enrl_status ) as Status,
      cast( 'Enrolled' as abap.char(20) )    as StatusText
}
where
  Language = $session.system_language
union all select from I_Language
{
  key cast( 'COMP' as zetms_de_enrl_status ) as Status,
      cast( 'Completed' as abap.char(20) )   as StatusText
}
where
  Language = $session.system_language
union all select from I_Language
{
  key cast( 'CNCL' as zetms_de_enrl_status ) as Status,
      cast( 'Cancelled' as abap.char(20) )   as StatusText
}
where
  Language = $session.system_language
