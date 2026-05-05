@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View - ETMS Categories'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_ETMS_CATEGORY
  as select from zetms_category
{
  key category_code as CategoryCode,
      category_name as CategoryName,
      description   as Description
}
