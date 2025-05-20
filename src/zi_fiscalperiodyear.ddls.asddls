@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Period with year'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_fiscalperiodyear
  as select from I_FiscalYearPeriod
{
      @AnalyticsDetails.query.sortDirection: #ASC
  key FiscalYear,
      @AnalyticsDetails.query.sortDirection: #ASC
  key FiscalPeriod,
      FiscalPeriodStartDate,
      FiscalPeriodEndDate,
      concat(concat(FiscalPeriod,'.'),FiscalYear) as Period
}
where
      FiscalPeriod      <= '012'
  and FiscalYearVariant =  'K4'
group by
  FiscalYear,
  FiscalPeriod,
  FiscalPeriodStartDate,
  FiscalPeriodEndDate
