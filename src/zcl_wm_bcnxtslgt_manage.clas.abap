CLASS zcl_wm_bcnxtslgt_manage DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: gt_data1    TYPE TABLE OF zi_wm_bcnxtslgt_custom.

    CLASS-METHODS:
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO zcl_wm_bcnxtslgt_manage,
      get_data
        IMPORTING io_request TYPE REF TO if_rap_query_request
        EXPORTING et_data    LIKE gt_data1.
  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-DATA: instance TYPE REF TO zcl_wm_bcnxtslgt_manage,
                gt_price TYPE TABLE OF zmd_fi_fmlt_price=>tys_yy_1_i_fmlt_price_type.

    CLASS-METHODS:
      get_price IMPORTING iv_date  TYPE dats
                          iv_year  TYPE gjahr
                          it_matnr TYPE table.
ENDCLASS.



CLASS ZCL_WM_BCNXTSLGT_MANAGE IMPLEMENTATION.


  METHOD get_data.
    DATA: lv_start_date                TYPE vdm_v_start_date,
          lv_end_date                  TYPE vdm_v_end_date,
          lv_period_type               TYPE nsdm_period_type VALUE 'Y',
          lv_fiscal_year               TYPE fis_gjahr_no_conv,
          lr_bukrs                     TYPE RANGE OF bukrs,
          lr_werks                     TYPE RANGE OF werks_d,
          lr_sobkz                     TYPE RANGE OF sobkz,
          lr_matnr                     TYPE RANGE OF matnr,
          lr_charg                     TYPE RANGE OF charg_d,
          lr_mtart                     TYPE RANGE OF mtart,
          lr_matkl                     TYPE RANGE OF matkl,
          p_period                     TYPE fins_fiscalperiod,
          p_periodtype                 TYPE nsdm_period_type VALUE 'Y',
          lr_valuationclassdescription TYPE RANGE OF zi_wm_bcnxtslgt_custom-valuationclassdescription,
          lr_materialtypename          TYPE RANGE OF zi_wm_bcnxtslgt_custom-materialtypename,
          lr_productgroupname          TYPE RANGE OF zi_wm_bcnxtslgt_custom-productgroupname,
          lr_productdescription        TYPE RANGE OF zi_wm_bcnxtslgt_custom-productdescription,

          lv_lastdateofprevper         TYPE dats,
          lv_check_author              TYPE abap_boolean,

          lr_chungnhantext             TYPE RANGE OF zi_wm_bcnxtslgt_custom-chungnhantext,
          lr_dongsanphamtext           TYPE RANGE OF zi_wm_bcnxtslgt_custom-dongsanphamtext,
          lr_giaviphugiatext           TYPE RANGE OF zi_wm_bcnxtslgt_custom-giaviphugiatext,
          lr_kichcohinhdangsizetext    TYPE RANGE OF zi_wm_bcnxtslgt_custom-kichcohinhdangsizetext,
          lr_loaihinhsanxuattext       TYPE RANGE OF zi_wm_bcnxtslgt_custom-loaihinhsanxuattext,
          lr_loaitpthuhoitext          TYPE RANGE OF zi_wm_bcnxtslgt_custom-loaitpthuhoitext,
          lr_quycachdonggoitext        TYPE RANGE OF zi_wm_bcnxtslgt_custom-quycachdonggoitext,
          lr_glaccount                 TYPE RANGE OF saknr,

          lv_period_start              TYPE i_goodsmovementcube-fiscalyearperiod,
          lv_year_start                TYPE i_goodsmovementcube-fiscalyear,
          lv_period_end                TYPE i_goodsmovementcube-fiscalyearperiod,
          lv_year_end                  TYPE i_goodsmovementcube-fiscalyear.
*    DATA: gt_data    TYPE TABLE OF zi_wm_bcnxtslgt_custom.
    " get filter by parameter -----------------------
    DATA(lt_parameter) = io_request->get_parameters( ).
    IF lt_parameter IS NOT INITIAL.
      LOOP AT lt_parameter REFERENCE INTO DATA(ls_parameter).
        CASE ls_parameter->parameter_name.
          WHEN 'P_PERIOD'.
            p_period        = ls_parameter->value .
          WHEN 'P_PERIODTYPE'.
            p_periodtype = ls_parameter->value .
          WHEN 'P_FISCALYEAR'.
            lv_fiscal_year  = ls_parameter->value.
        ENDCASE.
      ENDLOOP.
    ENDIF.
    " get filter by parameter -----------------------

    " get range by filter ---------------------------
    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.
    IF lt_filter_cond IS NOT INITIAL.
      LOOP AT lt_filter_cond REFERENCE INTO DATA(ls_filter_cond).
        CASE ls_filter_cond->name.
          WHEN 'COMPANYCODE'.
            lr_bukrs = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'PLANT'.
            lr_werks = CORRESPONDING #( ls_filter_cond->range ) .
*          WHEN 'INVENTORYSPECIALTYPE'.
*            lr_sobkz = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'MATERIAL'.
            lr_matnr = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'BATCH'.
            lr_charg = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'PRODUCTTYPE'.
            lr_mtart = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'PRODUCTGROUP'.
            lr_matkl = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'VALUATIONCLASSDESCRIPTION'.
            lr_valuationclassdescription = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'MATERIALTYPENAME'.
            lr_materialtypename = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'PRODUCTGROUPNAME'.
            lr_productgroupname = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'PRODUCTDESCRIPTION'.
            lr_productdescription = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'CHUNGNHANTEXT'.
            lr_chungnhantext   = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'DONGSANPHAMTEXT'.
            lr_dongsanphamtext = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'GIAVIPHUGIATEXT'.
            lr_giaviphugiatext = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'KICHCOHINHDANGSIZETEXT'.
            lr_kichcohinhdangsizetext = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'LOAIHINHSANXUATTEXT'.
            lr_loaihinhsanxuattext = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'LOAITPTHUHOITEXT'.
            lr_loaitpthuhoitext    = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'QUYCACHDONGGOITEXT'.
            lr_quycachdonggoitext  = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'GLACCOUNT'.
            lr_glaccount  = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDIF.
    " get range by filter ---------------------------

    " get previous date
    SELECT SINGLE prevcalendardate
     FROM zi_calendardate_prev
     WHERE calendardate = @lv_end_date
     INTO @DATA(lv_prev_end_date).

    SELECT SINGLE fiscalperiodstartdate,
                  fiscalperiodenddate
    FROM  zi_fiscalperiodyear
    WHERE zi_fiscalperiodyear~fiscalperiod = @p_period AND zi_fiscalperiodyear~fiscalyear = @lv_fiscal_year
    INTO @DATA(ls_date).


    lv_end_date   = ls_date-fiscalperiodenddate.
    lv_start_date = ls_date-fiscalperiodstartdate.

    SELECT SINGLE prevcalendardate
    FROM zi_calendardate_prev
    WHERE calendardate = @lv_start_date
    INTO @DATA(lv_prev_start_date).

    lv_lastdateofprevper = lv_prev_start_date.
    lv_period_start      = lv_lastdateofprevper+4(2).
    lv_year_start        = lv_lastdateofprevper+0(4).
    lv_period_end        = lv_end_date+4(2).
    lv_year_end          = lv_end_date(4).

    SELECT
        MAX( enddate ) AS enddate,
        periodtype,
        material,
        plant
     FROM  i_materialstocktimeseries( p_enddate   = @lv_end_date,
                                      p_startdate = @lv_start_date,
                                      p_periodtype = 'Y' ) AS source
     INNER JOIN i_product ON i_product~product = source~material
     WHERE material    IN @lr_matnr
       AND plant       IN @lr_werks
       AND companycode IN @lr_bukrs
     GROUP BY periodtype,
              material,
              plant
     INTO TABLE @DATA(lt_stock_key).

    SELECT inventory~material,
           inventory~valuationarea,
           inventory~companycodecurrency,
           SUM( inventory~valuationquantity ) AS openingquantity,
           SUM( inventory~amountincompanycodecurrency ) AS openingvalue
    FROM  i_inventoryamtbyfsclperd( p_fiscalperiod =  @lv_period_start,
                                    p_fiscalyear   =  @lv_year_start )  AS inventory
    INNER JOIN @lt_stock_key AS source
                             ON source~material = inventory~material
                            AND source~plant    = inventory~valuationarea
      WHERE inventory~ledger IN ( '0L' )
      GROUP BY  inventory~material,
                inventory~valuationarea,
                inventory~companycodecurrency
      ORDER BY   inventory~material,
                 inventory~valuationarea,
                 inventory~companycodecurrency
     INTO TABLE @DATA(lt_opening).

*    SELECT source~material,
*           source~valuationarea,
*             SUM( source~valuationquantity ) AS closingquantity,
*             SUM( source~amountincompanycodecurrency ) AS closevalue
*            FROM  i_inventoryamtbyfsclperd( p_fiscalperiod = @lv_period_end, p_fiscalyear =  @lv_year_end )  AS source
*          INNER JOIN @lt_stock_key AS inventory ON  inventory~material = source~material
*                                              AND  inventory~plant = source~valuationarea
*         WHERE source~ledger IN ( '0L' )
*          GROUP BY  source~material,
*                    source~valuationarea
*         ORDER BY   source~material,
*                    source~valuationarea
*         INTO TABLE @DATA(lt_closing).


    SELECT
      cube~material,
      cube~plant,
      cube~materialdocument,
      cube~materialdocumentitem,
      cube~companycodecurrency,
      cube~isreversalmovementtype,
      SUM( cube~goodsreceiptqtyinbaseunit )      AS totalreceipt_q,
      SUM( cube~goodsreceiptamountincocodecrcy ) AS totalreceipt_v,
      SUM( cube~goodsissueqtyinbaseunit )        AS totalissue_q,
      SUM( cube~goodsissueamountincocodecrcy )   AS totalissue_v
   FROM i_goodsmovementcube AS  cube
   INNER JOIN @lt_stock_key AS inventory ON  inventory~material = cube~material
                                         AND  inventory~plant   = cube~plant
   INNER JOIN i_materialdocumentitem_2 AS matdoc
                                       ON matdoc~materialdocument     = cube~materialdocument
                                      AND matdoc~materialdocumentitem = cube~materialdocumentitem
    WHERE cube~postingdate         >= @lv_start_date
      AND cube~postingdate         <= @lv_end_date
      AND cube~materialdocumentyear = @lv_fiscal_year
      AND matdoc~debitcreditcode    EQ 'H'
*      AND matdoc~reversedmaterialdocument     IS INITIAL
*      AND matdoc~reversedmaterialdocumentitem IS INITIAL
*      AND matdoc~reversedmaterialdocumentyear IS INITIAL
      AND matdoc~inventoryspecialstocktype <> 'B'
      AND NOT EXISTS ( SELECT * FROM i_goodsmovementcube AS cube2
                                                      WHERE cube2~issuingorreceivingplant      = cube~plant
                                                        AND cube2~issgorrcvgmaterial           = cube~material
                                                        AND cube2~materialdocument             = cube~materialdocument
                                                        AND cube2~materialdocumentyear         = cube~materialdocumentyear
                                                        AND cube2~materialdocumentitem         = cube~materialdocumentitem
                                                        AND cube2~goodsmovementtype NOT IN ( '411', '413' ) )
*      AND NOT EXISTS ( SELECT * FROM i_materialdocumentitem_2 AS b
*                                                           WHERE b~reversedmaterialdocument     = cube~materialdocument
*                                                             AND b~reversedmaterialdocumentitem = cube~materialdocumentitem
*                                                             AND b~reversedmaterialdocumentyear = cube~materialdocumentyear )
    GROUP BY   cube~material, cube~plant, cube~materialdocument,cube~materialdocumentitem, cube~companycodecurrency,  cube~isreversalmovementtype
    ORDER BY   cube~material,cube~plant, cube~materialdocument,cube~materialdocumentitem, cube~companycodecurrency,  cube~isreversalmovementtype
   INTO TABLE @DATA(lt_issue).


    SELECT i_accountingdocumentjournal~material,
           i_accountingdocumentjournal~plant,
           SUM( i_accountingdocumentjournal~debitamountincocodecrcy ) AS debitamountincocodecrcy
    FROM i_accountingdocumentjournal
    INNER JOIN @lt_stock_key AS inventory ON  inventory~material = i_accountingdocumentjournal~material
                                         AND  inventory~plant    = i_accountingdocumentjournal~plant
    WHERE i_accountingdocumentjournal~ledger = '0L'
      AND i_accountingdocumentjournal~debitcreditcode = 'S'
      AND i_accountingdocumentjournal~postingdate         >= @lv_start_date
      AND i_accountingdocumentjournal~postingdate         <= @lv_end_date
      AND i_accountingdocumentjournal~fiscalyear          = @lv_fiscal_year
*      AND i_accountingdocumentjournal~baseunit            IS INITIAL
      AND i_accountingdocumentjournal~referencedocumenttype <> 'MKPF'
      AND i_accountingdocumentjournal~transactiontypedetermination = 'BSX'
      AND i_accountingdocumentjournal~transactiontypedetermination <> ' '
     GROUP BY i_accountingdocumentjournal~material, i_accountingdocumentjournal~plant
     ORDER BY i_accountingdocumentjournal~material, i_accountingdocumentjournal~plant
    INTO TABLE @DATA(lt_amout_receipt).

    SELECT i_accountingdocumentjournal~material,
           i_accountingdocumentjournal~plant,
           i_accountingdocumentjournal~accountingdocument
    FROM i_accountingdocumentjournal
    INNER JOIN @lt_stock_key AS inventory ON  inventory~material = i_accountingdocumentjournal~material
                                         AND  inventory~plant    = i_accountingdocumentjournal~plant
    WHERE i_accountingdocumentjournal~ledger = '0L'
      AND i_accountingdocumentjournal~debitcreditcode = 'S'
      AND i_accountingdocumentjournal~postingdate         >= @lv_start_date
      AND i_accountingdocumentjournal~postingdate         <= @lv_end_date
      AND i_accountingdocumentjournal~fiscalyear          = @lv_fiscal_year
*      AND i_accountingdocumentjournal~baseunit            IS INITIAL
      AND i_accountingdocumentjournal~referencedocumenttype <> 'MKPF'
      AND i_accountingdocumentjournal~transactiontypedetermination = 'BSX'
      AND i_accountingdocumentjournal~transactiontypedetermination <> ' '
    INTO TABLE @DATA(lt_amout_receipt_tmp).


    SELECT
       cube~material,
       cube~plant,
       cube~materialdocument,
       cube~materialdocumentitem,
       cube~companycodecurrency,
       cube~isreversalmovementtype,
       SUM( cube~goodsreceiptqtyinbaseunit )      AS totalreceipt_q,
       SUM( cube~goodsreceiptamountincocodecrcy ) AS totalreceipt_v,
       SUM( cube~goodsissueqtyinbaseunit )        AS totalissue_q,
       SUM( cube~goodsissueamountincocodecrcy )   AS totalissue_v
    FROM i_goodsmovementcube AS  cube
    INNER JOIN @lt_stock_key AS inventory ON  inventory~material = cube~material
                                          AND  inventory~plant   = cube~plant
    INNER JOIN i_materialdocumentitem_2 AS matdoc
                                        ON matdoc~materialdocument     = cube~materialdocument
                                       AND matdoc~materialdocumentitem = cube~materialdocumentitem
     WHERE cube~postingdate         >= @lv_start_date
       AND cube~postingdate         <= @lv_end_date
       AND cube~materialdocumentyear = @lv_fiscal_year
       AND matdoc~debitcreditcode    EQ 'S'
*       AND matdoc~reversedmaterialdocument     IS INITIAL
*       AND matdoc~reversedmaterialdocumentitem IS INITIAL
*       AND matdoc~reversedmaterialdocumentyear IS INITIAL
       AND matdoc~inventoryspecialstocktype <> 'B'
       AND NOT EXISTS ( SELECT * FROM i_goodsmovementcube AS cube2
                                                       WHERE cube2~issuingorreceivingplant      = cube~plant
                                                         AND cube2~issgorrcvgmaterial           = cube~material
                                                         AND cube2~materialdocument             = cube~materialdocument
                                                         AND cube2~materialdocumentyear         = cube~materialdocumentyear
                                                         AND cube2~materialdocumentitem         = cube~materialdocumentitem
                                                         AND cube2~goodsmovementtype NOT IN ( '411', '413' ) )
*       AND NOT EXISTS ( SELECT * FROM i_materialdocumentitem_2 AS b
*                                                            WHERE b~reversedmaterialdocument     = cube~materialdocument
*                                                              AND b~reversedmaterialdocumentitem = cube~materialdocumentitem
*                                                              AND b~reversedmaterialdocumentyear = cube~materialdocumentyear )
     GROUP BY   cube~material, cube~plant, cube~materialdocument, cube~companycodecurrency, cube~materialdocumentitem, cube~isreversalmovementtype
     ORDER BY   cube~material,cube~plant, cube~materialdocument, cube~companycodecurrency, cube~materialdocumentitem, cube~isreversalmovementtype
    INTO TABLE @DATA(lt_receipt).

    SELECT i_accountingdocumentjournal~material,
           i_accountingdocumentjournal~plant,
           SUM( i_accountingdocumentjournal~creditamountincocodecrcy ) AS  creditamountincocodecrcy
    FROM i_accountingdocumentjournal
    INNER JOIN @lt_stock_key AS inventory ON  inventory~material = i_accountingdocumentjournal~material
                                         AND  inventory~plant    = i_accountingdocumentjournal~plant
    WHERE i_accountingdocumentjournal~ledger = '0L'
      AND i_accountingdocumentjournal~debitcreditcode = 'H'
      AND i_accountingdocumentjournal~postingdate         >= @lv_start_date
      AND i_accountingdocumentjournal~postingdate         <= @lv_end_date
      AND i_accountingdocumentjournal~fiscalyear          = @lv_fiscal_year
*      AND i_accountingdocumentjournal~baseunit            IS INITIAL
      AND i_accountingdocumentjournal~transactiontypedetermination =  'BSX'
      AND i_accountingdocumentjournal~referencedocumenttype <> 'MKPF'
*      and i_accountingdocumentjournal~transactiontypedetermination <> ' '
     GROUP BY i_accountingdocumentjournal~material, i_accountingdocumentjournal~plant
     ORDER BY i_accountingdocumentjournal~material, i_accountingdocumentjournal~plant
    INTO TABLE @DATA(lt_amout_issue).

    SELECT i_accountingdocumentjournal~material,
           i_accountingdocumentjournal~plant,
           i_accountingdocumentjournal~accountingdocument
    FROM i_accountingdocumentjournal
    INNER JOIN @lt_stock_key AS inventory ON  inventory~material = i_accountingdocumentjournal~material
                                         AND  inventory~plant    = i_accountingdocumentjournal~plant
    WHERE i_accountingdocumentjournal~ledger = '0L'
      AND i_accountingdocumentjournal~debitcreditcode = 'H'
      AND i_accountingdocumentjournal~postingdate         >= @lv_start_date
      AND i_accountingdocumentjournal~postingdate         <= @lv_end_date
      AND i_accountingdocumentjournal~fiscalyear          = @lv_fiscal_year
*      AND i_accountingdocumentjournal~baseunit            IS INITIAL
      AND i_accountingdocumentjournal~transactiontypedetermination = 'BSX'
      AND i_accountingdocumentjournal~referencedocumenttype <> 'MKPF'
*      and i_accountingdocumentjournal~transactiontypedetermination <> ' '
    INTO TABLE @DATA(lt_amout_issue_tmp).

*    SELECT
*      cube~material,
*      cube~plant,
*      cube~materialdocument,
*      cube~materialdocumentitem,
*      cube~companycodecurrency,
*      SUM( cube~goodsreceiptqtyinbaseunit ) AS totalreceipt_q,
*      SUM( cube~goodsreceiptamountincocodecrcy ) AS totalreceipt_v,
*      SUM( cube~goodsissueqtyinbaseunit ) AS totalissue_q,
*      SUM( cube~goodsissueamountincocodecrcy ) AS totalissue_v
*   FROM i_goodsmovementcube AS  cube
*   INNER JOIN @lt_stock_key AS inventory ON  inventory~material = cube~material
*                                         AND  inventory~plant   = cube~plant
*    WHERE cube~postingdate         >= @lv_start_date
*      AND cube~postingdate         <= @lv_end_date
*      AND cube~materialdocumentyear = @lv_fiscal_year
*      AND NOT EXISTS ( SELECT * FROM i_goodsmovementcube AS cube2
*                                                      WHERE cube2~issuingorreceivingplant      = cube~plant
*                                                        AND cube2~issgorrcvgmaterial           = cube~material
*                                                        AND cube2~materialdocument             = cube~materialdocument
*                                                        AND cube2~materialdocumentyear         = cube~materialdocumentyear )
*    GROUP BY   cube~material, cube~plant, materialdocument, companycodecurrency,materialdocumentitem
*    ORDER BY   cube~material,cube~plant, materialdocument, companycodecurrency,materialdocumentitem
*   INTO TABLE @DATA(lt_issue_receipt).


*    SELECT
*     source~material,
*     source~plant,
*     source~materialdocument,
*     source~reversedmaterialdocumentitem
* FROM  i_materialdocumentitem_2 AS source
*       WHERE source~postingdate <= @lv_end_date AND source~materialdocumentyear = @lv_fiscal_year
*         AND source~postingdate >= @lv_start_date
*         AND ( ( source~reversedmaterialdocumentitem <> '' AND source~reversedmaterialdocument <> '' )
*          OR ( source~goodsmovementiscancelled = 'X' ) )
*     AND NOT ( source~goodsmovementtype = '311' AND source~reversedmaterialdocument IS NOT INITIAL )
*     AND NOT ( ( source~goodsmovementtype IN ( '311', '312', '413', '414','301','302','Z30','Y30','315','122','411','412' ) ) )
*    INTO TABLE @DATA(lt_huy_cube).


*    SORT lt_issue_receipt BY plant  materialdocument material materialdocumentitem .
*    SORT lt_huy_cube BY plant materialdocument material reversedmaterialdocumentitem .
*
*    LOOP AT lt_issue_receipt ASSIGNING FIELD-SYMBOL(<fs_i_receipt>).
*      READ TABLE lt_huy_cube INTO DATA(ls_huy_cube) WITH KEY plant = <fs_i_receipt>-plant
*                                                             materialdocument = <fs_i_receipt>-materialdocument
*                                                             material = <fs_i_receipt>-material
*                                                             reversedmaterialdocumentitem = <fs_i_receipt>-materialdocumentitem
*                                                             BINARY SEARCH.
*      IF sy-subrc = 0.
*        DELETE lt_issue_receipt.
*      ENDIF.
*    ENDLOOP.
*    UNASSIGN <fs_i_receipt>.
*    CLEAR: ls_huy_cube.



    DATA: lv_receipt_q    TYPE i_goodsmovementcube-goodsreceiptqtyinbaseunit,
          lv_receipt_v    TYPE i_goodsmovementcube-goodsreceiptamountincocodecrcy,
          lv_totalissue_q TYPE i_goodsmovementcube-goodsissueqtyinbaseunit,
          lv_totalissue_v TYPE i_goodsmovementcube-goodsissueamountincocodecrcy.


    SORT lt_receipt BY material plant .
    DATA(lt_receipt1) = lt_receipt.

    DELETE ADJACENT DUPLICATES FROM lt_receipt COMPARING material plant.

    LOOP AT lt_receipt ASSIGNING FIELD-SYMBOL(<lfs_receipt>).

      READ TABLE lt_receipt1 TRANSPORTING NO FIELDS WITH KEY material  = <lfs_receipt>-material
                                                             plant     = <lfs_receipt>-plant BINARY SEARCH.
      IF sy-subrc = 0.
        LOOP AT lt_receipt1 INTO DATA(ls_data_receipt) FROM sy-tabix.
          IF NOT (
                 ls_data_receipt-material = <lfs_receipt>-material AND
                 ls_data_receipt-plant    = <lfs_receipt>-plant  ) .
            EXIT.
          ELSE.
            IF ls_data_receipt-isreversalmovementtype = 'X'.
              lv_receipt_q = abs( lv_receipt_q )  + abs( ls_data_receipt-totalissue_q ).
              lv_receipt_v = abs( lv_receipt_v )  + abs( ls_data_receipt-totalissue_v ).
            ENDIF.
            lv_receipt_q    = abs( lv_receipt_q ) + abs( ls_data_receipt-totalreceipt_q ).
            lv_receipt_v    = abs( lv_receipt_v ) + abs( ls_data_receipt-totalreceipt_v ).
*            lv_totalissue_q = abs( lv_totalissue_q ) + abs( ls_data_receipt-totalissue_q ).
*            lv_totalissue_v = abs( lv_totalissue_v ) + abs( ls_data_receipt-totalissue_v ).
          ENDIF.
        ENDLOOP.
      ENDIF.
      <lfs_receipt>-totalreceipt_q = lv_receipt_q .
      <lfs_receipt>-totalreceipt_v = lv_receipt_v.
*      <lfs_receipt>-totalissue_q = lv_totalissue_q.
*      <lfs_receipt>-totalissue_v = lv_totalissue_v.

      CLEAR: lv_receipt_q .
      CLEAR: lv_receipt_v.
      CLEAR: lv_totalissue_q.
      CLEAR: lv_totalissue_v.
    ENDLOOP.

    CLEAR: lt_receipt1, ls_data_receipt.
    UNASSIGN <lfs_receipt>.


    SORT lt_issue BY material plant .
    DATA(lt_issue1) = lt_issue.

    DELETE ADJACENT DUPLICATES FROM lt_issue COMPARING material plant.

    LOOP AT lt_issue ASSIGNING FIELD-SYMBOL(<lfs_issue>).

      READ TABLE lt_issue1 TRANSPORTING NO FIELDS WITH KEY material  = <lfs_issue>-material
                                                           plant     = <lfs_issue>-plant BINARY SEARCH.
      IF sy-subrc = 0.
        LOOP AT lt_issue1 INTO DATA(ls_data_issue) FROM sy-tabix.
          IF NOT (
                 ls_data_issue-material = <lfs_issue>-material AND
                 ls_data_issue-plant    = <lfs_issue>-plant  ) .
            EXIT.
          ELSE.
            IF ls_data_issue-isreversalmovementtype = 'X'.
              lv_totalissue_q = abs( lv_totalissue_q )  + abs( ls_data_issue-totalreceipt_q ).
              lv_totalissue_v = abs( lv_totalissue_v ) + abs( ls_data_issue-totalreceipt_v ).
            ENDIF.
*            lv_receipt_q    = abs( lv_receipt_q ) + abs( ls_data_issue-totalreceipt_q ).
*            lv_receipt_v    = abs( lv_receipt_v ) + abs( ls_data_issue-totalreceipt_v ).
            lv_totalissue_q = abs( lv_totalissue_q ) + abs( ls_data_issue-totalissue_q ).
            lv_totalissue_v = abs( lv_totalissue_v ) + abs( ls_data_issue-totalissue_v ).
          ENDIF.
        ENDLOOP.
      ENDIF.
*      <fs_issue_receipt>-totalreceipt_q = lv_receipt_q .
*      <fs_issue_receipt>-totalreceipt_v = lv_receipt_v.
      <lfs_issue>-totalissue_q = lv_totalissue_q.
      <lfs_issue>-totalissue_v = lv_totalissue_v.

      CLEAR: lv_receipt_q .
      CLEAR: lv_receipt_v.
      CLEAR: lv_totalissue_q.
      CLEAR: lv_totalissue_v.
    ENDLOOP.

    CLEAR: lt_issue1, ls_data_issue.
    UNASSIGN <lfs_issue>.



*//////////////////////////////////// loại các mvt

*    SELECT
*            source~material,
*            source~plant,
*            SUM( source~quantityinbaseunit ) AS sumsource
*            FROM  i_materialdocumentitem_2   AS source
*            WHERE source~postingdate       <= @lv_end_date
*              AND source~postingdate       >= @lv_start_date
**              AND source~goodsmovementtype IN ( '311', '312', '413', '414','301', '302','315','411','412' )
*              AND source~materialdocumentyear = @lv_fiscal_year
*              AND EXISTS ( SELECT *  FROM i_materialdocumentitem_2 AS matdoc2
*                                        WHERE matdoc2~issuingorreceivingplant    = source~plant
*                                          AND matdoc2~issgorrcvgmaterial         = source~material
*                                          AND matdoc2~materialdocument           = source~materialdocument
*                                          AND matdoc2~materialdocumentyear       = source~materialdocumentyear
*                                          AND matdoc2~materialdocumentitem       = source~materialdocumentitem )
*            GROUP BY  source~material, source~plant
*            ORDER BY  source~material, source~plant
*            INTO TABLE @DATA(lt_countdk1).

    SELECT DISTINCT
        source~material,
        source~plant,
        source~\_plant-plantname,
        source~materialbaseunit,
        source~companycode,
        source~\_companycode-companycodename,
*        source~supplier,
        i_product~producttype,
        i_product~productgroup,
        i_productgrouptext_2~productgroupname,
        i_producttext~productname AS productdescription,
        i_producttypetext~materialtypename,
        i_product~yy1_chungnhan_prd              AS chungnhan,
        cl_yy1_chungnhan_prd~description         AS chungnhantext,
      i_product~yy1_dongsanpham_prd             AS dongsanpham,
      cl_yy1_dongsanpham_prd~description        AS dongsanphamtext,
      i_product~yy1_giaviphugia_prd             AS giaviphugia,
      cl_yy1_giaviphugia_prd~description        AS giaviphugiatext,
      i_product~yy1_kichcohinhdangsize_prd      AS kichcohinhdangsize,
      cl_yy1_kichcohinhdangsize_prd~description AS kichcohinhdangsizetext,
      i_product~yy1_loaihinhsanxuat_prd         AS loaihinhsanxuat,
      cl_yy1_loaihinhsanxuat_prd~description    AS loaihinhsanxuattext,
      i_product~yy1_loaitpthuhoi_prd            AS loaitpthuhoi,
      cl_yy1_loaitpthuhoi_prd~description       AS loaitpthuhoitext,
      i_product~yy1_quycachdonggoi_prd          AS quycachdonggoi,
      cl_yy1_quycachdonggoi_prd~description     AS quycachdonggoitext,
       t025t~valuationclassdescription,
       marm~quantitynumerator,
       marm~quantitydenominator,
       marm~alternativeunit AS baseunit,
       zwm_tb_val_glacc~glaccount
    FROM i_materialstocktimeseries( p_enddate    = @lv_end_date,
                                    p_startdate  = @lv_start_date,
                                    p_periodtype = @p_periodtype ) AS source
    INNER JOIN @lt_stock_key AS stock_ekey ON source~periodtype = stock_ekey~periodtype
    AND source~enddate = stock_ekey~enddate
    AND source~material = stock_ekey~material
    AND source~plant = stock_ekey~plant

    INNER JOIN i_product ON i_product~product = source~material
    LEFT JOIN i_producttext  ON i_producttext~product = i_product~product
    AND i_producttext~language = @sy-langu
    LEFT JOIN i_productgrouptext_2  ON i_productgrouptext_2~productgroup = i_product~productgroup
    AND i_productgrouptext_2~language = @sy-langu
    LEFT JOIN i_producttypetext  ON i_producttypetext~producttype = i_product~producttype
    AND i_producttypetext~language = @sy-langu
    LEFT JOIN i_producttext AS pt ON pt~product  = source~material
                                 AND pt~language = @sy-langu
    LEFT JOIN i_plant AS plant ON plant~plant = source~plant
    LEFT JOIN i_productunitsofmeasure AS marm
                                      ON marm~product         = source~material
                                     AND marm~alternativeunit = 'Z1'
    LEFT JOIN i_productvaluationbasic AS valuation
                                      ON valuation~product       = source~material
                                     AND valuation~valuationarea = source~plant
                                     AND valuation~valuationtype IS INITIAL
    LEFT JOIN i_prodvaluationclasstxt AS t025t
                                      ON t025t~valuationclass = valuation~valuationclass
                                     AND t025t~language       = @sy-langu
    LEFT JOIN zwm_tb_val_glacc ON zwm_tb_val_glacc~valuationclass = valuation~valuationclass
    LEFT  JOIN      i_customfieldcodelistvaluehelp              AS cl_yy1_chungnhan_prd          ON  i_product~yy1_chungnhan_prd        = cl_yy1_chungnhan_prd~code
                                                                                                       AND cl_yy1_chungnhan_prd~customfieldid = 'YY1_CHUNGNHAN'
    LEFT JOIN       i_customfieldcodelistvaluehelp              AS cl_yy1_dongsanpham_prd        ON  i_product~yy1_dongsanpham_prd        = cl_yy1_dongsanpham_prd~code
                                                                                                       AND cl_yy1_dongsanpham_prd~customfieldid = 'YY1_DONGSANPHAM'
    LEFT JOIN       i_customfieldcodelistvaluehelp              AS cl_yy1_giaviphugia_prd        ON  i_product~yy1_giaviphugia_prd        = cl_yy1_giaviphugia_prd~code
                                                                                                AND cl_yy1_giaviphugia_prd~customfieldid = 'YY1_GIAVIPHUGIA'
    LEFT JOIN       i_customfieldcodelistvaluehelp              AS cl_yy1_kichcohinhdangsize_prd ON  i_product~yy1_kichcohinhdangsize_prd        = cl_yy1_kichcohinhdangsize_prd~code
                                                                                                       AND cl_yy1_kichcohinhdangsize_prd~customfieldid = 'YY1_KICHCOHINHDANGSIZE'
    LEFT JOIN       i_customfieldcodelistvaluehelp              AS cl_yy1_loaihinhsanxuat_prd    ON  i_product~yy1_loaihinhsanxuat_prd        = cl_yy1_loaihinhsanxuat_prd~code
                                                                                                       AND cl_yy1_loaihinhsanxuat_prd~customfieldid = 'YY1_LOAIHINHSANXUAT'
    LEFT JOIN       i_customfieldcodelistvaluehelp              AS cl_yy1_loaitpthuhoi_prd       ON  i_product~yy1_loaitpthuhoi_prd        = cl_yy1_loaitpthuhoi_prd~code
                                                                                                       AND cl_yy1_loaitpthuhoi_prd~customfieldid = 'YY1_LOAITPTHUHOI'
    LEFT JOIN       i_customfieldcodelistvaluehelp              AS cl_yy1_quycachdonggoi_prd     ON  i_product~yy1_quycachdonggoi_prd        = cl_yy1_quycachdonggoi_prd~code
                                                                                                       AND cl_yy1_quycachdonggoi_prd~customfieldid = 'YY1_QUYCACHDONGGOI'
    WHERE source~material      IN @lr_matnr
    AND source~plant           IN @lr_werks
    AND source~companycode     IN @lr_bukrs
    AND i_product~producttype  IN @lr_mtart
    AND i_product~productgroup IN @lr_matkl
    AND t025t~valuationclassdescription       IN @lr_valuationclassdescription
    AND i_productgrouptext_2~productgroupname IN @lr_productgroupname
    AND i_producttypetext~materialtypename    IN @lr_materialtypename
    AND i_producttext~productname             IN @lr_productdescription
    AND cl_yy1_chungnhan_prd~description      IN @lr_chungnhantext
    AND cl_yy1_dongsanpham_prd~description    IN @lr_dongsanphamtext
    AND cl_yy1_giaviphugia_prd~description    IN @lr_giaviphugiatext
    AND cl_yy1_kichcohinhdangsize_prd~description IN @lr_kichcohinhdangsizetext
    AND cl_yy1_loaihinhsanxuat_prd~description    IN @lr_loaihinhsanxuattext
    AND cl_yy1_loaitpthuhoi_prd~description       IN @lr_loaitpthuhoitext
    AND cl_yy1_quycachdonggoi_prd~description     IN @lr_quycachdonggoitext
    AND zwm_tb_val_glacc~glaccount                IN @lr_glaccount
    INTO CORRESPONDING FIELDS OF TABLE @et_data.

    SORT et_data BY material plant.
    SORT lt_opening BY material valuationarea.
*    SORT lt_closing BY material valuationarea.

    SORT lt_issue BY material plant.
    SORT lt_receipt BY material plant.

    LOOP AT et_data REFERENCE INTO DATA(ls_data) .

      READ TABLE lt_opening REFERENCE INTO DATA(ls_currentstock)
         WITH KEY material             = ls_data->material
               valuationarea           = ls_data->plant BINARY SEARCH.
      IF sy-subrc = 0.
        ls_data->openingstock = ls_currentstock->openingquantity.
        ls_data->openingprice = ls_currentstock->openingvalue.
        ls_data->companycodecurrency = ls_currentstock->companycodecurrency.

      ENDIF.

      READ TABLE lt_issue REFERENCE INTO DATA(ls_issue) WITH KEY material = ls_data->material
                                                                     plant    = ls_data->plant BINARY SEARCH.
      IF sy-subrc = 0.
        ls_data->totalissueqty       = ls_issue->totalissue_q.
        ls_data->totalissueprice     = ls_issue->totalissue_v.
        ls_data->companycodecurrency = ls_issue->companycodecurrency.
      ENDIF.

      READ TABLE lt_receipt REFERENCE INTO DATA(ls_receive) WITH KEY material = ls_data->material
                                                                     plant    = ls_data->plant BINARY SEARCH.
      IF sy-subrc = 0.
        ls_data->totalreceiptqty     = ls_receive->totalreceipt_q.
        ls_data->totalreceiptprice   = ls_receive->totalreceipt_v.
        ls_data->companycodecurrency = ls_receive->companycodecurrency.
      ENDIF.

      READ TABLE lt_amout_receipt REFERENCE INTO DATA(ls_amount_receipt) WITH KEY material = ls_data->material
                                                                                  plant    = ls_data->plant BINARY SEARCH.
      IF sy-subrc = 0.
        ls_data->totalreceiptprice = abs( ls_data->totalreceiptprice ) + abs( ls_amount_receipt->debitamountincocodecrcy ).
      ENDIF.

      READ TABLE lt_amout_issue REFERENCE INTO DATA(ls_amount_issue) WITH KEY material = ls_data->material
                                                                              plant    = ls_data->plant BINARY SEARCH.
      IF sy-subrc = 0.
        ls_data->totalissueprice = abs( ls_data->totalissueprice ) + abs( ls_amount_issue->creditamountincocodecrcy ).
      ENDIF.

      ls_data->closingstock = ls_data->openingstock +  ls_data->totalreceiptqty   - ls_data->totalissueqty.
      ls_data->closingprice =  ls_data->openingprice +  ls_data->totalreceiptprice - ls_data->totalissueprice .

      IF ls_data->closingstock <> 0.
        ls_data->dongiacuoiky = ls_data->closingprice / ls_data->closingstock.
      ENDIF.

      IF ( ls_data->closingstock + ls_data->openingstock + ls_data->totalreceiptqty + ls_data->totalissueqty ) = 0.
        DELETE et_data.
      ENDIF.

    ENDLOOP.
    CLEAR: ls_data.

    SORT et_data BY material plant.

  ENDMETHOD.


  METHOD get_instance.
    IF instance IS INITIAL.
      CREATE OBJECT instance.
    ENDIF.
    ro_instance = instance.
  ENDMETHOD.


  METHOD get_price.

    DATA:
      ls_entity_key    TYPE zmd_fi_fmlt_price=>tys_yy_1_i_fmlt_price_paramete,
      lt_business_data TYPE TABLE OF zmd_fi_fmlt_price=>tys_yy_1_i_fmlt_price_type,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    TYPES:
      "! CurrencyRole
      currency_role TYPE c LENGTH 2,
      "! Ledger
      ledger        TYPE c LENGTH 2,
      "! FiscalYear
      fiscal_year   TYPE c LENGTH 4.
    DATA:
      lo_filter_factory      TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_1       TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_2       TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_3       TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_4       TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root    TYPE REF TO /iwbep/if_cp_filter_node,
      lt_range_currency_role TYPE RANGE OF currency_role,
      lt_range_ledger        TYPE RANGE OF ledger,
      lt_range_fiscal_year   TYPE RANGE OF fiscal_year.

    APPEND VALUE #( sign = 'I' option = 'EQ' low = '10' ) TO lt_range_currency_role.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = '0L' ) TO lt_range_ledger.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = iv_year ) TO lt_range_fiscal_year.

    TRY.
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                                     comm_scenario  = 'ZCORE_CS_SAP'
                                                     service_id     = 'Z_API_SAP_REST' ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZMD_FI_FMLT_PRICE'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = 'sap/opu/odata/sap/YY1_I_FMLT_PRICE_CDS' ).

        ASSERT lo_http_client IS BOUND.

        ls_entity_key = VALUE #(
          p_calendar_date   = iv_date ).

        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'YY_1_I_FMLT_PRICE' )->navigate_with_key( ls_entity_key )->navigate_to_many( 'SET' )->create_request_for_read( ).

        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).

        lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'CURRENCY_ROLE'
                                                                it_range             = lt_range_currency_role ).
        lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'LEDGER'
                                                                it_range             = lt_range_ledger ).
        lo_filter_node_3  = lo_filter_factory->create_by_range( iv_property_path     = 'FISCAL_YEAR'
                                                                it_range             = lt_range_fiscal_year ).
        lo_filter_node_4  = lo_filter_factory->create_by_range( iv_property_path     = 'MATERIAL'
                                                                it_range             = it_matnr ).

        lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 )->and( lo_filter_node_3 )->and( lo_filter_node_4 ).
        lo_request->set_filter( lo_filter_node_root ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.
      CATCH cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

    gt_price = lt_business_data.
  ENDMETHOD.
ENDCLASS.
