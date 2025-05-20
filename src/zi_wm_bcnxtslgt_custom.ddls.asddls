@EndUserText.label: 'Báo cáo nhập xuất tồn số lượng & giá trị'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_WM_BCNXTSLGT'
@UI: {
    headerInfo: {
        typeName: 'Báo cáo nhập xuất tồn số lượng & giá trị',
        typeNamePlural: 'Báo cáo nhập xuất tồn số lượng & giá trị'
    }
}
define custom entity ZI_WM_BCNXTSLGT_CUSTOM
  with parameters
    //    // tham số 11
    //    @EndUserText.label       : 'From Date'
    //    P_StartDate  : vdm_v_start_date,
    //    // tham số 12
    //    @EndUserText.label       : 'To Date'
    //    P_EndDate    : vdm_v_end_date,
    // tham số 13
    @EndUserText.label: 'Period'
    @Consumption.hidden: false
    //    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZSH_FISCALPERIODYEAR',  element : 'FiscalPeriod' } }]
    P_period     : fins_fiscalperiod,
    //    @Consumption.hidden: true
    //    @EndUserText.label       : 'Period Type'
    //    P_PeriodType : nsdm_period_type,
    // tham số 14
    @EndUserText.label       : 'Fiscal Year'
    P_FiscalYear : fis_gjahr_no_conv
{
      // tham số 1
      @Consumption              : {
      valueHelpDefinition       : [ {
      entity                    :{
      name                      :'I_CompanyCodeStdVH',
      element                   :'CompanyCode' }
      }],
      filter                    :{ mandatory:true } }
      @UI.selectionField        : [ { position: 10 } ]
      @UI.lineItem              : [ { position: 10 } ]
      @EndUserText.label        : 'Company Code'
  key CompanyCode               : bukrs;
      // tham số 3
      @Consumption              : {
      valueHelpDefinition       : [ {
      entity                    :{
      name                      :'I_PlantStdVH',
      element                   :'Plant' }
      }],
      filter                    :{ mandatory:true } }
      @UI.selectionField        : [ { position: 30 } ]
      @UI.lineItem              : [ { position: 20 } ]
      @EndUserText.label        : 'Plant'
  key Plant                     : werks_d;
      //      // tham số 4
      //      @UI.selectionField       : [ { position: 40 } ]
      //      @UI.lineItem             : [ { position: 30 } ]
      //      @EndUserText.label       : 'Storage Location'
      //  key StorageLocation,
      // tham số 10
      //      @Consumption.valueHelpDefinition      : [ {
      //      entity                    :{
      //      name                      :'I_InventorySpecialStockType',
      //      element                   :'InventorySpecialStockType' }
      //      }]
      //      @UI.selectionField        : [ { position: 100 } ]
      //      @UI.lineItem              : [ { position: 40 } ]
      //      @EndUserText.label        : 'Special Indicator'
      //  key InventorySpecialStockType : sobkz;
      // tham số 2
      @Consumption.valueHelpDefinition      : [ {
      entity                    :{
      name                      :'I_ProductStdVH',
      element                   :'Product' }
      }]
      @UI.selectionField        : [ { position: 20 } ]
      @UI.lineItem              : [ { position: 50 } ]
      @EndUserText.label        : 'Material Number'
  key Material                  : matnr;
      // tham số 7
      //      @Consumption.valueHelpDefinition      : [ {
      //      entity                    :{
      //      name                      :'I_BatchStdVH',
      //      element                   :'Batch' },
      //      additionalBinding         : [
      //      {element                  : 'Material', localElement: 'Material', usage: #FILTER_AND_RESULT},
      //      {element                  : 'Plant', localElement: 'Plant', usage: #FILTER_AND_RESULT}
      //      ]
      //      }]
      //      @UI.selectionField        : [ { position: 70 } ]
      //      @UI.lineItem              : [ { position: 60 } ]
      //      @EndUserText.label        : 'Batch'
      //  key Batch                     : charg_d;
      //      @UI.lineItem              : [ { position: 61 } ]
      //      @EndUserText.label        : 'Sales Order'
      //  key SDDocument                : zde_vbeln_va;
      //      @UI.lineItem              : [ { position: 62 } ]
      //      @EndUserText.label        : 'Sales Order Item'
      //  key SDDocumentItem            : zde_posnr_va;

      @UI.lineItem              : [ { position: 11 } ]
      @EndUserText.label        : 'Company Code Name'
      CompanyCodeName           : abap.char(200);
      @UI.lineItem              : [ { position: 21 } ]
      @EndUserText.label        : 'Plant Text'
      PlantName                 : abap.char(200);
      @UI.lineItem              : [ { position: 51 } ]
      ProductDescription        : maktx;
      //      @UI.lineItem           : [ { position: 100 } ]
      //      @EndUserText.label     : 'Start Date'
      //      StartDate              : vdm_v_start_date;
      //      @UI.lineItem           : [ { position: 110 } ]
      //      @EndUserText.label     : 'End Date'
      //      EndDate                : vdm_v_end_date;
      @UI.lineItem              : [ { position: 120 } ]
      @EndUserText.label        : 'Base Unit'
      MaterialBaseUnit          : meins;
      @UI.lineItem              : [ { position: 130 } ]
      @EndUserText.label        : 'Currency'
      CompanyCodeCurrency       : waers;
      @Aggregation.default      : #SUM
      @UI.lineItem              : [ { position: 140 } ]
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label        : 'Opening Stock'
      OpeningStock              : abap.dec( 31, 2 );
      @Aggregation.default      : #SUM
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem              : [ { position: 150 } ]
      @EndUserText.label        : 'Total Receipt Quantities'
      TotalReceiptQty           : abap.dec( 31, 2 );
      @Aggregation.default      : #SUM
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem              : [ { position: 160 } ]
      @EndUserText.label        : 'Total Issue Quantities'
      TotalIssueQty             : abap.dec( 31, 2 );
      @Aggregation.default      : #SUM
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem              : [ { position: 170 } ]
      @EndUserText.label        : 'Closing Stock'
      ClosingStock              : abap.dec( 31, 2 );
      @UI.lineItem              : [ { position: 180 } ]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label        : 'Đơn giá cuối kỳ'
      DonGiaCuoiKy              : abap.dec(13,2);
      // tham số 5
      @Consumption.valueHelpDefinition      : [ {
      entity                    :{
      name                      :'I_ProductType_2',
      element                   :'ProductType' }
      }]
      @UI.selectionField        : [ { position: 50 } ]
      @UI.lineItem              : [ { position: 180 } ]
      @EndUserText.label        : 'Material Type'
      ProductType               : mtart;
      @UI.lineItem              : [ { position: 190 } ]
      MaterialTypeName          : abap.char(25);
      // tham số 6
      @Consumption.valueHelpDefinition      : [ {
      entity                    :{
      name                      :'I_ProductGroup_2',
      element                   :'ProductGroup' }
      }]
      @UI.selectionField        : [ { position: 60 } ]
      @UI.lineItem              : [ { position: 200 } ]
      @EndUserText.label        : 'Material Group'
      ProductGroup              : matkl;
      @UI.lineItem              : [ { position: 210 } ]
      @EndUserText.label        : 'Material Group Text'
      ProductGroupName          : abap.char(20);
      @EndUserText.label        : 'Chứng nhận'
      @UI.selectionField        : [ { position: 110 } ]
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CustomFieldCodeListText', element: 'Code' },
      additionalBinding         : [{element: 'CustomFieldID', localConstant: 'YY1_CHUNGNHAN', usage: #FILTER }] } ]
      @UI.hidden                : true
      Chungnhan                 : abap.char(100);
      @UI.lineItem              : [ { position: 330 } ]
      @EndUserText.label        : 'Chứng nhận'
      ChungnhanText             : abap.char(100);
      @EndUserText.label        : 'Dòng sản phẩm'
      @UI.selectionField        : [ { position: 120 } ]
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CustomFieldCodeListText', element: 'Code' },
      additionalBinding         : [{element: 'CustomFieldID', localConstant: 'YY1_DONGSANPHAM', usage: #FILTER }] } ]
      @UI.hidden                : true
      Dongsanpham               : abap.char(100);
      @UI.lineItem              : [ { position: 340 } ]
      @EndUserText.label        : 'Dòng sản phẩm'
      DongsanphamText           : abap.char(100);
      @EndUserText.label        : 'Gia vị/ phụ gia'
      @UI.selectionField        : [ { position: 130 } ]
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CustomFieldCodeListText', element: 'Code' },
      additionalBinding         : [{element: 'CustomFieldID', localConstant: 'YY1_GIAVIPHUGIA', usage: #FILTER }] } ]
      @UI.hidden                : true
      GiaviPhugia               : abap.char(100);
      @UI.lineItem              : [ { position: 350 } ]
      @EndUserText.label        : 'Gia vị/ phụ gia'
      GiaviPhugiaText           : abap.char(100);
      @EndUserText.label        : 'Kích cỡ/ Hình dáng/ Size'
      @UI.selectionField        : [ { position: 140 } ]
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CustomFieldCodeListText', element: 'Code' },
      additionalBinding         : [{element: 'CustomFieldID', localConstant: 'YY1_KICHCOHINHDANGSIZE', usage: #FILTER }] } ]
      @UI.hidden                : true
      KichcoHinhdangSize        : abap.char(100);
      @UI.lineItem              : [ { position: 360 } ]
      @EndUserText.label        : 'Kích cỡ/ Hình dáng/ Size'
      KichcoHinhdangSizeText    : abap.char(100);
      @EndUserText.label        : 'Loại hình sản xuất'
      @UI.selectionField        : [ { position: 150 } ]
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CustomFieldCodeListText', element: 'Code' },
      additionalBinding         : [{element: 'CustomFieldID', localConstant: 'YY1_LOAIHINHSANXUAT', usage: #FILTER }] } ]
      @UI.hidden                : true
      Loaihinhsanxuat           : abap.char(100);
      @UI.lineItem              : [ { position: 370 } ]
      @EndUserText.label        : 'Loại hình sản xuất'
      LoaihinhsanxuatText       : abap.char(100);
      @EndUserText.label        : 'Loại TP thu hồi'
      @UI.selectionField        : [ { position: 160 } ]
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CustomFieldCodeListText', element: 'Code' },
      additionalBinding         : [{element: 'CustomFieldID', localConstant: 'YY1_LOAITPTHUHOI', usage: #FILTER }] } ]
      @UI.hidden                : true
      LoaiTPthuhoi              : abap.char(100);
      @UI.lineItem              : [ { position: 380 } ]
      @EndUserText.label        : 'Loại TP thu hồi'
      LoaiTPthuhoiText          : abap.char(100);
      @EndUserText.label        : 'Quy cách đóng gói'
      @UI.selectionField        : [ { position: 170 } ]
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CustomFieldCodeListText', element: 'Code' },
      additionalBinding         : [{element: 'CustomFieldID', localConstant: 'YY1_QUYCACHDONGGOI', usage: #FILTER }] } ]
      @UI.hidden                : true
      Quycachdonggoi            : abap.char(100);
      @UI.lineItem              : [ { position: 390 } ]
      @EndUserText.label        : 'Quy cách đóng gói'
      QuycachdonggoiText        : abap.char(100);
      @Aggregation.default      : #SUM
      @UI.lineItem              : [ { position: 400 } ]
      @EndUserText.label        : 'Opening Value'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OpeningPrice              : abap.curr( 23, 2 );
      @Aggregation.default      : #SUM
      @UI.lineItem              : [ { position: 410 } ]
      @EndUserText.label        : 'Total Receipt Values'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      TotalReceiptPrice         : abap.curr( 23, 2 );
      @Aggregation.default      : #SUM
      @UI.lineItem              : [ { position: 420 } ]
      @EndUserText.label        : 'Total Issue Values'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      TotalIssuePrice           : abap.curr( 23, 2 );
      @Aggregation.default      : #SUM
      @UI.lineItem              : [ { position: 430 } ]
      @EndUserText.label        : 'Closing Value'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ClosingPrice              : abap.curr( 23, 2 );
      @UI.lineItem              : [ { position: 440 } ]
      @EndUserText.label        : 'GL Account'
      glaccount                 : saknr;

      @UI.lineItem              : [ { position: 440 } ]
      @EndUserText.label        : 'Value Class Name'
      ValuationClassDescription : abap.char(25);
      @ObjectModel.filter.enabled:false
      @UI.hidden                : true
      BaseUnit                  : abap.unit( 3 );
      @ObjectModel.filter.enabled:false
      @UI.hidden                : true
      QuantityNumerator         : abap.dec( 5 );
      @ObjectModel.filter.enabled:false
      @UI.hidden                : true
      QuantityDenominator       : abap.dec(5);
}
