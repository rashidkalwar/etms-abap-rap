@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help View - Program Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZI_ETMS_PROG_STATUS_VH
  as select from I_Language
{
  key cast( 'PLAN' as zetms_de_prog_status ) as Status,
      cast( 'Planned' as abap.char(20) )     as StatusText
}
where
  Language = $session.system_language
union all select from I_Language
{
  key cast( 'ACTV' as zetms_de_prog_status ) as Status,
      cast( 'Active' as abap.char(20) )      as StatusText
}
where
  Language = $session.system_language
union all select from I_Language
{
  key cast( 'CNCL' as zetms_de_prog_status ) as Status,
      cast( 'Cancelled' as abap.char(20) )   as StatusText
}
where
  Language = $session.system_language
union all select from I_Language
{
  key cast( 'COMP' as zetms_de_prog_status ) as Status,
      cast( 'Completed' as abap.char(20) )   as StatusText
}
where
  Language = $session.system_language
