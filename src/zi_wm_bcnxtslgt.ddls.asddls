@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Báo cáo nhập xuất tồn số lượng & giá trị'
define view entity ZI_WM_BCNXTSLGT
  with parameters
    P_PassStartDate : vdm_v_key_date,
    // tham số 11
    @EndUserText.label       : 'From Date'
    P_StartDate     : vdm_v_start_date,
    // tham số 12
    @EndUserText.label       : 'To Date'
    P_EndDate       : vdm_v_end_date,
    // tham số 13
    @Consumption.valueHelpDefinition      : [ {
    entity                   :{
    name                     :'ZI_WM_NSDM_PERIOD_TYPE',
    element                  :'value_low' }
    }]
    @EndUserText.label       : 'Period Type'
    P_PeriodType    : nsdm_period_type,
    // tham số 14
    @EndUserText.label       : 'Fiscal Year'
    P_FiscalYear    : fis_gjahr_no_conv
  as select distinct from ZI_WM_BCNXTSLGT_KEY
                          ( P_PassStartDate: $parameters.P_PassStartDate,
                          P_StartDate  : $parameters.P_StartDate,
                          P_EndDate    : $parameters.P_EndDate,
                          P_PeriodType : $parameters.P_PeriodType,
                          P_FiscalYear : $parameters.P_FiscalYear   ) as Stock
    left outer join       I_CompanyCode                                                                on Stock.CompanyCode = I_CompanyCode.CompanyCode
    left outer join       I_Plant                                                                      on Stock.Plant = I_Plant.Plant
  //    left outer join I_StorageLocation                                                            on Stock.StorageLocation = I_StorageLocation.StorageLocation
    left outer join       I_Product                                                                    on Stock.Material = I_Product.Product
  //    left outer join I_Batch                                                                      on  Stock.Material = I_Batch.Material
  //                                                                                                 and Stock.Batch    = I_Batch.Batch
  //                                                                                                 and I_Batch.Plant  = ''
    left outer join       I_ProductDescription                                                         on  Stock.Material                = I_ProductDescription.Product
                                                                                                       and I_ProductDescription.Language = $session.system_language
    left outer join       I_ProductTypeText                                                            on  I_Product.ProductType      = I_ProductTypeText.ProductType
                                                                                                       and I_ProductTypeText.Language = $session.system_language
    left outer join       I_ProductGroupText_2                                                         on  I_Product.ProductGroup        = I_ProductGroupText_2.ProductGroup
                                                                                                       and I_ProductGroupText_2.Language = $session.system_language
  //    left outer join ZCORE_I_PROFILE_SUPPLIER                    as SupplierProfile               on I_Batch.Supplier = SupplierProfile.Supplier
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_GRD                         on  I_Batch.Material     = Z_GRD.Material
  //                                                                                                 and I_Batch.Plant        = Z_GRD.Plant
  //                                                                                                 and I_Batch.Batch        = Z_GRD.Batch
  //                                                                                                 and Z_GRD.Characteristic = 'Z_GRD'
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_NSX                         on  I_Batch.Material     = Z_NSX.Material
  //                                                                                                 and I_Batch.Plant        = Z_NSX.Plant
  //                                                                                                 and I_Batch.Batch        = Z_NSX.Batch
  //                                                                                                 and Z_NSX.Characteristic = 'Z_NSX'
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_HSD                         on  I_Batch.Material     = Z_HSD.Material
  //                                                                                                 and I_Batch.Plant        = Z_HSD.Plant
  //                                                                                                 and I_Batch.Batch        = Z_HSD.Batch
  //                                                                                                 and Z_HSD.Characteristic = 'Z_HSD'
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_DSX                         on  I_Batch.Material     = Z_DSX.Material
  //                                                                                                 and I_Batch.Plant        = Z_DSX.Plant
  //                                                                                                 and I_Batch.Batch        = Z_DSX.Batch
  //                                                                                                 and Z_DSX.Characteristic = 'Z_DSX'
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_NCC                         on  I_Batch.Material     = Z_NCC.Material
  //                                                                                                 and I_Batch.Plant        = Z_NCC.Plant
  //                                                                                                 and I_Batch.Batch        = Z_NCC.Batch
  //                                                                                                 and Z_NCC.Characteristic = 'Z_NCC'
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_GHICHU                      on  I_Batch.Material        = Z_GHICHU.Material
  //                                                                                                 and I_Batch.Plant           = Z_GHICHU.Plant
  //                                                                                                 and I_Batch.Batch           = Z_GHICHU.Batch
  //                                                                                                 and Z_GHICHU.Characteristic = 'Z_GHICHU'
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_SHD                         on  I_Batch.Material     = Z_SHD.Material
  //                                                                                                 and I_Batch.Plant        = Z_SHD.Plant
  //                                                                                                 and I_Batch.Batch        = Z_SHD.Batch
  //                                                                                                 and Z_SHD.Characteristic = 'Z_SHD'
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_CSX                         on  I_Batch.Material     = Z_CSX.Material
  //                                                                                                 and I_Batch.Plant        = Z_CSX.Plant
  //                                                                                                 and I_Batch.Batch        = Z_CSX.Batch
  //                                                                                                 and Z_CSX.Characteristic = 'Z_CSX'
  //    left outer join ZI_WM_BCNXTSLGT_CHAR                        as Z_HSQD                        on  I_Batch.Material      = Z_HSQD.Material
  //                                                                                                 and I_Batch.Plant         = Z_HSQD.Plant
  //                                                                                                 and I_Batch.Batch         = Z_HSQD.Batch
  //                                                                                                 and Z_HSQD.Characteristic = 'Z_HSQD'
    left outer join       I_CustomFieldCodeListValueHelp              as CL_YY1_Chungnhan_PRD          on  I_Product.YY1_Chungnhan_PRD        = CL_YY1_Chungnhan_PRD.Code
                                                                                                       and CL_YY1_Chungnhan_PRD.CustomFieldID = 'YY1_CHUNGNHAN'
    left outer join       I_CustomFieldCodeListValueHelp              as CL_YY1_Dongsanpham_PRD        on  I_Product.YY1_Dongsanpham_PRD        = CL_YY1_Dongsanpham_PRD.Code
                                                                                                       and CL_YY1_Dongsanpham_PRD.CustomFieldID = 'YY1_DONGSANPHAM'
    left outer join       I_CustomFieldCodeListValueHelp              as CL_YY1_GiaviPhugia_PRD        on  I_Product.YY1_GiaviPhugia_PRD        = CL_YY1_GiaviPhugia_PRD.Code
                                                                                                       and CL_YY1_GiaviPhugia_PRD.CustomFieldID = 'YY1_GIAVIPHUGIA'
    left outer join       I_CustomFieldCodeListValueHelp              as CL_YY1_KichcoHinhdangSize_PRD on  I_Product.YY1_KichcoHinhdangSize_PRD        = CL_YY1_KichcoHinhdangSize_PRD.Code
                                                                                                       and CL_YY1_KichcoHinhdangSize_PRD.CustomFieldID = 'YY1_KICHCOHINHDANGSIZE'
    left outer join       I_CustomFieldCodeListValueHelp              as CL_YY1_Loaihinhsanxuat_PRD    on  I_Product.YY1_Loaihinhsanxuat_PRD        = CL_YY1_Loaihinhsanxuat_PRD.Code
                                                                                                       and CL_YY1_Loaihinhsanxuat_PRD.CustomFieldID = 'YY1_LOAIHINHSANXUAT'
    left outer join       I_CustomFieldCodeListValueHelp              as CL_YY1_LoaiTPthuhoi_PRD       on  I_Product.YY1_LoaiTPthuhoi_PRD        = CL_YY1_LoaiTPthuhoi_PRD.Code
                                                                                                       and CL_YY1_LoaiTPthuhoi_PRD.CustomFieldID = 'YY1_LOAITPTHUHOI'
    left outer join       I_CustomFieldCodeListValueHelp              as CL_YY1_Quycachdonggoi_PRD     on  I_Product.YY1_Quycachdonggoi_PRD        = CL_YY1_Quycachdonggoi_PRD.Code
                                                                                                       and CL_YY1_Quycachdonggoi_PRD.CustomFieldID = 'YY1_QUYCACHDONGGOI'
{
      // tham số 1
      @Consumption             : {
      valueHelpDefinition      : [ {
      entity                   :{
      name                     :'I_CompanyCodeStdVH',
      element                  :'CompanyCode' }
      }],
      filter                   :{ mandatory:true } }
      @UI.selectionField       : [ { position: 10 } ]
      @UI.lineItem             : [ { position: 10 } ]
      @EndUserText.label       : 'Company Code'
  key Stock.CompanyCode,
      // tham số 3
      @Consumption             : {
      valueHelpDefinition      : [ {
      entity                   :{
      name                     :'I_PlantStdVH',
      element                  :'Plant' }
      }],
      filter                   :{ mandatory:true } }
      @UI.selectionField       : [ { position: 30 } ]
      @UI.lineItem             : [ { position: 20 } ]
      @EndUserText.label       : 'Plant'
  key Stock.Plant,
      //      // tham số 4
      //      @UI.selectionField       : [ { position: 40 } ]
      //      @UI.lineItem             : [ { position: 30 } ]
      //      @EndUserText.label       : 'Storage Location'
      //  key Stock.StorageLocation,
      // tham số 10
      //      @Consumption.valueHelpDefinition      : [ {
      //      entity                   :{
      //      name                     :'I_InventorySpecialStockType',
      //      element                  :'InventorySpecialStockType' }
      //      }]
      //      @UI.selectionField       : [ { position: 100 } ]
      //      @UI.lineItem             : [ { position: 40 } ]
      //      @EndUserText.label       : 'Special Stock Indicator'
      //  key Stock.InventorySpecialStockType,
      // tham số 2
      @Consumption.valueHelpDefinition      : [ {
      entity                   :{
      name                     :'I_ProductStdVH',
      element                  :'Product' }
      }]
      @UI.selectionField       : [ { position: 20 } ]
      @UI.lineItem             : [ { position: 50 } ]
      @EndUserText.label       : 'Material Number'
  key Stock.Material,
      // tham số 7
      //      @Consumption.valueHelpDefinition      : [ {
      //      entity                   :{
      //      name                     :'I_BatchStdVH',
      //      element                  :'Batch' },
      //      additionalBinding: [
      //      {element: 'Material', localElement: 'Material', usage: #FILTER_AND_RESULT},
      //      {element: 'Plant', localElement: 'Plant', usage: #FILTER_AND_RESULT}
      //      ]
      //      }]
      //      @UI.selectionField       : [ { position: 70 } ]
      //      @UI.lineItem             : [ { position: 60 } ]
      //      @EndUserText.label       : 'Batch'
      //  key Stock.Batch,
      //      @UI.lineItem             : [ { position: 61 } ]
      //      @EndUserText.label       : 'Sales Order'
      //  key Stock.SDDocument,
      //      @UI.lineItem             : [ { position: 62 } ]
      //      @EndUserText.label       : 'Sales Order Item'
      //  key Stock.SDDocumentItem,

      @UI.lineItem             : [ { position: 70 } ]
      I_CompanyCode.CompanyCodeName,
      @UI.lineItem             : [ { position: 80 } ]
      I_Plant.PlantName,
      //      @UI.lineItem             : [ { position: 90 } ]
      //      I_StorageLocation.StorageLocationName,
      @UI.lineItem             : [ { position: 51 } ]
      I_ProductDescription.ProductDescription,
      @UI.lineItem             : [ { position: 100 } ]
      Stock.StartDate                           as StartDate,
      @UI.lineItem             : [ { position: 110 } ]
      Stock.EndDate                             as EndDate,
      @UI.lineItem             : [ { position: 120 } ]
      Stock.MaterialBaseUnit,
      @UI.lineItem             : [ { position: 130 } ]
      I_CompanyCode.Currency                    as CompanyCodeCurrency,
      @UI.lineItem             : [ { position: 140 } ]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label       : 'Opening Stock'
      Stock.OpeningStock,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem             : [ { position: 150 } ]
      @EndUserText.label       : 'Total Receipt Quantities'
      Stock.TotalReceiptQty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      Stock.TotalReceiptQtyCTT,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem             : [ { position: 160 } ]
      @EndUserText.label       : 'Total Issue Quantities'
      Stock.TotalIssueQty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      Stock.TotalIssueQtyCTT,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem             : [ { position: 170 } ]
      @EndUserText.label       : 'Closing Stock'
      Stock.ClosingStock,
      // tham số 5
      @Consumption.valueHelpDefinition      : [ {
      entity                   :{
      name                     :'I_ProductType_2',
      element                  :'ProductType' }
      }]
      @UI.selectionField       : [ { position: 50 } ]
      @UI.lineItem             : [ { position: 180 } ]
      @EndUserText.label       : 'Material Type'
      I_Product.ProductType,
      @UI.lineItem             : [ { position: 190 } ]
      I_ProductTypeText.MaterialTypeName,
      // tham số 6
      @Consumption.valueHelpDefinition      : [ {
      entity                   :{
      name                     :'I_ProductGroup_2',
      element                  :'ProductGroup' }
      }]
      @UI.selectionField       : [ { position: 60 } ]
      @UI.lineItem             : [ { position: 200 } ]
      @EndUserText.label       : 'Material Group'
      I_Product.ProductGroup,
      @UI.lineItem             : [ { position: 210 } ]
      I_ProductGroupText_2.ProductGroupName,
      //      @UI.lineItem             : [ { position: 220 } ]
      //      I_Batch.Supplier,
      //      @UI.lineItem             : [ { position: 230 } ]
      //      @EndUserText.label       : 'Supplier Name'
      //      SupplierProfile.SupplierFullName,
      //      @UI.lineItem             : [ { position: 240 } ]
      //      @EndUserText.label       : 'Ngày nhập kho'
      //      Z_GRD.CharcFromDate                                              as Z_GRD,
      //      @UI.lineItem             : [ { position: 250 } ]
      //      @EndUserText.label       : 'Ngày sản xuất'
      //      Z_NSX.CharcFromDate                                              as Z_NSX,
      //      @UI.lineItem             : [ { position: 260 } ]
      //      @EndUserText.label       : 'Hạn sử dụng'
      //      Z_HSD.CharcFromDate                                              as Z_HSD,
      //      @UI.lineItem             : [ { position: 270 } ]
      //      @EndUserText.label       : 'Đơn vị sản xuất'
      //      Z_DSX.CharcValue                                                 as Z_DSX,
      //      @UI.lineItem             : [ { position: 280 } ]
      //      @EndUserText.label       : 'Nhà cung cấp'
      //      Z_NCC.CharcValue                                                 as Z_NCC,
      //      @UI.lineItem             : [ { position: 290 } ]
      //      @EndUserText.label       : 'Ghi chú'
      //      Z_GHICHU.CharcValue                                              as Z_GHICHU,
      //      @UI.lineItem             : [ { position: 300 } ]
      //      @EndUserText.label       : 'Số hợp đồng'
      //      Z_SHD.CharcValue                                                 as Z_SHD,
      //      @UI.lineItem             : [ { position: 310 } ]
      //      @EndUserText.label       : 'Ca sản xuất'
      //      Z_CSX.CharcValue                                                 as Z_CSX,
      //      @UI.lineItem             : [ { position: 320 } ]
      //      @EndUserText.label       : 'KG/Thùng'
      //      fltp_to_dec( Z_HSQD.CharcFromNumericValue as abap.dec( 10, 3 ) ) as Z_HSQD,
      @UI.lineItem             : [ { position: 321 } ]
      @EndUserText.label       : 'ĐVT THU'
      cast( 'Z1' as meins )                     as THUUnit,
      @UI.lineItem             : [ { position: 322 } ]
      @Semantics.quantity.unitOfMeasure: 'THUUnit'
      @EndUserText.label       : 'Tồn đầu kỳ THU'
      cast( 0 as abap.quan( 31, 2 ) )           as THUOpeningStock,
      @UI.lineItem             : [ { position: 323 } ]
      @Semantics.quantity.unitOfMeasure: 'THUUnit'
      @EndUserText.label       : 'Tổng nhập THU'
      cast( 0 as abap.quan( 31, 2 ) )           as THUTotalReceiptQty,
      @UI.lineItem             : [ { position: 324 } ]
      @Semantics.quantity.unitOfMeasure: 'THUUnit'
      @EndUserText.label       : 'Tổng xuất THU'
      cast( 0 as abap.quan( 31, 2 ) )           as THUTotalIssueQty,
      @UI.lineItem             : [ { position: 325 } ]
      @Semantics.quantity.unitOfMeasure: 'THUUnit'
      @EndUserText.label       : 'Tồn cuối kỳ THU'
      cast( 0 as abap.quan( 31, 2 ) )           as THUClosingStock,
      @EndUserText.label       : 'Chứng nhận'
      @UI.hidden: true
      I_Product.YY1_Chungnhan_PRD               as Chungnhan,
      @UI.lineItem             : [ { position: 330 } ]
      @EndUserText.label       : 'Chứng nhận'
      CL_YY1_Chungnhan_PRD.Description          as ChungnhanText,
      @EndUserText.label       : 'Dòng sản phẩm'
      @UI.hidden: true
      I_Product.YY1_Dongsanpham_PRD             as Dongsanpham,
      @UI.lineItem             : [ { position: 340 } ]
      @EndUserText.label       : 'Dòng sản phẩm'
      CL_YY1_Dongsanpham_PRD.Description        as DongsanphamText,
      @EndUserText.label       : 'Gia vị/ phụ gia'
      @UI.hidden: true
      I_Product.YY1_GiaviPhugia_PRD             as GiaviPhugia,
      @UI.lineItem             : [ { position: 350 } ]
      @EndUserText.label       : 'Gia vị/ phụ gia'
      CL_YY1_GiaviPhugia_PRD.Description        as GiaviPhugiaText,
      @EndUserText.label       : 'Kích cỡ/ Hình dáng/ Size'
      @UI.hidden: true
      I_Product.YY1_KichcoHinhdangSize_PRD      as KichcoHinhdangSize,
      @UI.lineItem             : [ { position: 360 } ]
      @EndUserText.label       : 'Kích cỡ/ Hình dáng/ Size'
      CL_YY1_KichcoHinhdangSize_PRD.Description as KichcoHinhdangSizeText,
      @EndUserText.label       : 'Loại hình sản xuất'
      @UI.hidden: true
      I_Product.YY1_Loaihinhsanxuat_PRD         as Loaihinhsanxuat,
      @UI.lineItem             : [ { position: 370 } ]
      @EndUserText.label       : 'Loại hình sản xuất'
      CL_YY1_Loaihinhsanxuat_PRD.Description    as LoaihinhsanxuatText,
      @EndUserText.label       : 'Loại TP thu hồi'
      @UI.hidden: true
      I_Product.YY1_LoaiTPthuhoi_PRD            as LoaiTPthuhoi,
      @UI.lineItem             : [ { position: 380 } ]
      @EndUserText.label       : 'Loại TP thu hồi'
      CL_YY1_LoaiTPthuhoi_PRD.Description       as LoaiTPthuhoiText,
      @EndUserText.label       : 'Quy cách đóng gói'
      @UI.hidden: true
      I_Product.YY1_Quycachdonggoi_PRD          as Quycachdonggoi,
      @UI.lineItem             : [ { position: 390 } ]
      @EndUserText.label       : 'Quy cách đóng gói'
      CL_YY1_Quycachdonggoi_PRD.Description     as QuycachdonggoiText
}
