@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get previous date'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CALENDARDATE_PREV
  as select from I_CalendarDate
{
  key CalendarDate,
      dats_add_days( CalendarDate, - 0001 ,'INITIAL' ) as PrevCalendarDate
}
