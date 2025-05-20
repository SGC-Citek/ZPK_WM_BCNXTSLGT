@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Báo cáo nhập xuất tồn số lượng & giá trị'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_BCNXTSLGT_CHAR
  as select from I_Batch
    inner join   I_ClfnObjectCharcValForKeyDate(P_KeyDate: $session.system_date) on I_ClfnObjectCharcValForKeyDate.ClfnObjectInternalID = I_Batch.ClfnObjectInternalID
    inner join   I_ClfnCharacteristic                                            on I_ClfnCharacteristic.CharcInternalID = I_ClfnObjectCharcValForKeyDate.CharcInternalID
{
  key I_Batch.Material,
  key I_Batch.Plant,
  key I_Batch.Batch,
  key I_ClfnCharacteristic.Characteristic,
      I_ClfnObjectCharcValForKeyDate.CharcValue,
      I_ClfnObjectCharcValForKeyDate.CharcFromNumericValue,
      round(fltp_to_dec( I_ClfnObjectCharcValForKeyDate.CharcFromNumericValue as abap.dec( 23, 3 ) ), 2) as Z_HSQD,
      I_ClfnObjectCharcValForKeyDate.CharcToNumericValue,
      I_ClfnObjectCharcValForKeyDate.CharcFromDate,
      I_ClfnObjectCharcValForKeyDate.CharcToDate
}
