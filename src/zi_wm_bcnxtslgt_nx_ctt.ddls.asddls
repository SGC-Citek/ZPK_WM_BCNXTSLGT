@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Báo cáo nhập xuất tồn số lượng & giá trị - CTT'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_BCNXTSLGT_NX_CTT
  with parameters
    P_StartDate : vdm_v_start_date,
    P_EndDate   : vdm_v_end_date
  as select from I_MaterialDocumentItem_2
{
  Plant,
  //  StorageLocation,
  Material,
  //  Batch,
  //  SalesOrder                as SDDocument,
  //  SalesOrderItem            as SDDocumentItem,
  //  InventorySpecialStockType,
  MaterialBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  sum( QuantityInBaseUnit ) as Quantity
}
where
      PostingDate                  >= $parameters.P_StartDate
  and PostingDate                  <= $parameters.P_EndDate
  and Plant                        = IssuingOrReceivingPlant
  and GoodsMovementIsCancelled     is initial
  and ReversedMaterialDocumentYear is initial
  and ReversedMaterialDocument     is initial
  and ReversedMaterialDocumentItem is initial
  and Material                     is not initial
group by
  Plant,
  //  StorageLocation,
  Material,
  //  Batch,
  //  SalesOrder,
  //  SalesOrderItem,
  //  InventorySpecialStockType,
  MaterialBaseUnit
