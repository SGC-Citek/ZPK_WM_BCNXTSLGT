@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search help NSDM_PERIOD_TYPE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_WM_NSDM_PERIOD_TYPE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_NSDM_PERIOD_TYPE' )
{
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      @ObjectModel.text.element:[ 'text' ]
      value_low,
      text
}
