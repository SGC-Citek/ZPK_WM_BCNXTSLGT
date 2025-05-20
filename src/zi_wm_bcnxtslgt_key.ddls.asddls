@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Báo cáo nhập xuất tồn số lượng & giá trị'
define view entity ZI_WM_BCNXTSLGT_KEY
  with parameters
    P_PassStartDate : abap.dats,
    P_StartDate     : vdm_v_start_date,
    P_EndDate       : vdm_v_end_date,
    P_PeriodType    : nsdm_period_type,
    P_FiscalYear    : fis_gjahr_no_conv
  as select from    ZI_WM_BCNXTSLGT_STOCK
                 ( P_StartDate  : $parameters.P_StartDate,
                    P_EndDate    : $parameters.P_EndDate,
                    P_PeriodType : $parameters.P_PeriodType   ) as ClosingStock
    inner join      I_CalendarDate                              as CalendarDateStart on  CalendarDateStart.CalendarDate = $parameters.P_StartDate
                                                                                     and CalendarDateStart.CalendarYear = $parameters.P_FiscalYear
    inner join      I_CalendarDate                              as CalendarDateEnd   on  CalendarDateEnd.CalendarDate = $parameters.P_EndDate
                                                                                     and CalendarDateEnd.CalendarYear = $parameters.P_FiscalYear
    left outer join ZI_WM_BCNXTSLGT_STOCK
                    ( P_StartDate  : $parameters.P_PassStartDate,
                    P_EndDate    : $parameters.P_PassStartDate,
                    P_PeriodType : $parameters.P_PeriodType   ) as OpeningStock      on  ClosingStock.CompanyCode = OpeningStock.CompanyCode
                                                                                     and ClosingStock.Plant       = OpeningStock.Plant
    //                                                                                     and ClosingStock.StorageLocation           = OpeningStock.StorageLocation
    //                                                                                     and ClosingStock.InventorySpecialStockType = OpeningStock.InventorySpecialStockType
                                                                                     and ClosingStock.Material    = OpeningStock.Material
  //                                                                                     and ClosingStock.Batch                     = OpeningStock.Batch
  //                                                                                     and ClosingStock.SDDocument                = OpeningStock.SDDocument
  //                                                                                     and ClosingStock.SDDocumentItem            = OpeningStock.SDDocumentItem
    left outer join ZI_WM_BCNXTSLGT_NX
                    ( P_StartDate  : $parameters.P_StartDate,
                    P_EndDate    : $parameters.P_EndDate )                           on  ClosingStock.Plant    = ZI_WM_BCNXTSLGT_NX.Plant
    //                                                                                     and ClosingStock.StorageLocation           = ZI_WM_BCNXTSLGT_NX.StorageLocation
                                                                                     and ClosingStock.Material = ZI_WM_BCNXTSLGT_NX.Material
  //                                                                                     and ClosingStock.Batch                     = ZI_WM_BCNXTSLGT_NX.Batch
  //                                                                                     and ClosingStock.SDDocument                = ZI_WM_BCNXTSLGT_NX.SDDocument
  //                                                                                     and ClosingStock.SDDocumentItem            = ZI_WM_BCNXTSLGT_NX.SDDocumentItem
  //                                                                                     and ClosingStock.InventorySpecialStockType = ZI_WM_BCNXTSLGT_NX.InventorySpecialStockType
    left outer join ZI_WM_BCNXTSLGT_NX_CTT
                    ( P_StartDate  : $parameters.P_StartDate,
                    P_EndDate    : $parameters.P_EndDate )                           on  ClosingStock.Plant    = ZI_WM_BCNXTSLGT_NX_CTT.Plant
    //                                                                                     and ClosingStock.StorageLocation           = ZI_WM_BCNXTSLGT_NX_CTT.StorageLocation
                                                                                     and ClosingStock.Material = ZI_WM_BCNXTSLGT_NX_CTT.Material
  //                                                                                     and ClosingStock.Batch                     = ZI_WM_BCNXTSLGT_NX_CTT.Batch
  //                                                                                     and ClosingStock.SDDocument                = ZI_WM_BCNXTSLGT_NX_CTT.SDDocument
  //                                                                                     and ClosingStock.SDDocumentItem            = ZI_WM_BCNXTSLGT_NX_CTT.SDDocumentItem
  //                                                                                     and ClosingStock.InventorySpecialStockType = ZI_WM_BCNXTSLGT_NX_CTT.InventorySpecialStockType
{
  key ClosingStock.CompanyCode,
  key ClosingStock.Plant,
      //  key ClosingStock.StorageLocation,
      //  key ClosingStock.InventorySpecialStockType,
  key ClosingStock.Material,
      //  key ClosingStock.Batch,
      //  key ClosingStock.SDDocument,
      //  key ClosingStock.SDDocumentItem,
      $parameters.P_StartDate                                            as StartDate,
      $parameters.P_EndDate                                              as EndDate,
      ClosingStock.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      OpeningStock.MatlWrhsStkQtyInMatlBaseUnit                          as OpeningStock,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ZI_WM_BCNXTSLGT_NX.TotalReceiptQty                                 as TotalReceiptQty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ZI_WM_BCNXTSLGT_NX.TotalIssueQty                                   as TotalIssueQty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( ZI_WM_BCNXTSLGT_NX_CTT.Quantity / 2 as abap.quan( 31, 11 ) ) as TotalReceiptQtyCTT,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( ZI_WM_BCNXTSLGT_NX_CTT.Quantity / 2 as abap.quan( 31, 11 ) ) as TotalIssueQtyCTT,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ClosingStock.MatlWrhsStkQtyInMatlBaseUnit                          as ClosingStock
}
