codeunit 60003 EventSubscriberAcx
{
    var
        recGenJournalTemplate: Record "Gen. Journal Template";
        NoSeriesMgt: codeunit NoSeriesManagement;
        SalesSetup: Record "Sales & Receivables Setup";


    ///Gen Journal Template for Purchase/////
    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnBeforeInitRecord', '', false, false)]
    local procedure OnBeforeInitRecord(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; xPurchaseHeader: Record "Purchase Header"; PurchSetup: Record "Purchases & Payables Setup"; GLSetup: Record "General Ledger Setup")
    begin
        IsHandled := true;
        if recGenJournalTemplate.Get(PurchaseHeader."Gen. Journal Template Code") then
            case PurchaseHeader."Document Type" of
                PurchaseHeader."Document Type"::Quote, PurchaseHeader."Document Type"::"Blanket Order":
                    begin
                        NoSeriesMgt.SetDefaultSeries(PurchaseHeader."No. Series", recGenJournalTemplate."Purchase Order No. Series");
                        // PurchaseHeader."No. Series" := recGenJournalTemplate."Purchase Order No. Series";
                        PurchaseHeader."No. Series" := recGenJournalTemplate."No. Series";
                    end;
                PurchaseHeader."Document Type"::Order:
                    begin
                        NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Posting No. Series", PurchSetup."Posted Invoice Nos.");
                        NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Receiving No. Series", PurchSetup."Posted Receipt Nos.");
                        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
                            NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Prepayment No. Series", PurchSetup."Posted Prepmt. Inv. Nos.");
                            NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Prepmt. Cr. Memo No. Series", PurchSetup."Posted Prepmt. Cr. Memo Nos.");
                        end;
                    end;
                PurchaseHeader."Document Type"::Invoice:
                    begin
                        if (PurchaseHeader."No. Series" <> '') and (PurchSetup."Invoice Nos." = PurchSetup."Posted Invoice Nos.") then
                            PurchaseHeader."Posting No. Series" := PurchaseHeader."No. Series"
                        else
                            NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Posting No. Series", PurchSetup."Posted Invoice Nos.");
                        if PurchSetup."Receipt on Invoice" then NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Receiving No. Series", PurchSetup."Posted Receipt Nos.");
                    end;
                PurchaseHeader."Document Type"::"Return Order":
                    begin
                        NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Posting No. Series", PurchSetup."Posted Credit Memo Nos.");
                        NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Return Shipment No. Series", PurchSetup."Posted Return Shpt. Nos.");
                    end;
                PurchaseHeader."Document Type"::"Credit Memo":
                    begin
                        if (PurchaseHeader."No. Series" <> '') and (PurchSetup."Credit Memo Nos." = PurchSetup."Posted Credit Memo Nos.") then
                            PurchaseHeader."Posting No. Series" := PurchaseHeader."No. Series"
                        else
                            NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Posting No. Series", PurchSetup."Posted Credit Memo Nos.");
                        if PurchSetup."Return Shipment on Credit Memo" then NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Return Shipment No. Series", PurchSetup."Posted Return Shpt. Nos.");
                    end;
            end;
        IsHandled := true;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnCreatePurchHeaderOnBeforeInitRecord', '', false, false)]
    // local procedure OnCreatePurchHeaderOnBeforeInitRecord(var PurchOrderHeader: Record "Purchase Header";
    // var PurchHeader: Record "Purchase Header")
    // begin
    //     recGenJournalTemplate.Get(PurchHeader."Gen. Journal Template Code");
    //     PurchOrderHeader."No." := NoSeriesMgt.GetNextNo(recGenJournalTemplate."Purchase Order No. Series", PurchHeader."Posting Date", TRUE);
    //     PurchHeader."No. Series" := '';
    // end;
    //Purchase Quote to Purchase Order
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", OnCreatePurchHeaderOnBeforePurchOrderHeaderInsert, '', False, false)]
    local procedure OnCreatePurchHeaderOnBeforePurchOrderHeaderInsert(var PurchHeader: Record "Purchase Header"; var PurchOrderHeader: Record "Purchase Header")
    begin
        // Check if Gen. Journal Template Code is set
        if PurchOrderHeader."Gen. Journal Template Code" = '' then
            exit;

        // Get the template
        if not recGenJournalTemplate.Get(PurchHeader."Gen. Journal Template Code") then
            exit;
        if recGenJournalTemplate.Get(PurchHeader."Gen. Journal Template Code") then;
        // Assign Order Template Code
        PurchOrderHeader.Validate("Gen. Journal Template Code", recGenJournalTemplate."Template Convert");

        // Set No. from Purchase Order No. Series only for Blanket Order or Quote
        if (PurchOrderHeader."Document Type" in [PurchOrderHeader."Document Type"::"Blanket Order", PurchOrderHeader."Document Type"::Order]) then begin

            // // Check if Purchase Order No. Series is available
            // if recGenJournalTemplate."Purchase Order No. Series" = '' then
            //     Error('No Purchase Order No. Series defined in Gen. Journal Template.');
            if recGenJournalTemplate.Get(PurchOrderHeader."Gen. Journal Template Code") then;

            PurchOrderHeader."No." :=
                NoSeriesMgt.GetNextNo(recGenJournalTemplate."No. Series", PurchOrderHeader."Posting Date", true);
            PurchOrderHeader."No. Series" := recGenJournalTemplate."No. Series"; // Optional, if needed
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnCreatePurchHeaderOnBeforePurchOrderHeaderModify', '', false, false)]
    // local procedure OnCreatePurchHeaderOnBeforePurchOrderHeaderModify(var PurchOrderHeader: Record "Purchase Header";
    // var PurchHeader: Record "Purchase Header")
    // begin
    //     recGenJournalTemplate.Get(PurchHeader."Gen. Journal Template Code");
    //     PurchOrderHeader.Validate("Gen. Journal Template Code", recGenJournalTemplate."Order Template Code");
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", 'OnCreatePurchHeaderOnBeforePurchOrderHeaderInitRecord', '', false, false)]
    local procedure OnCreatePurchHeaderOnBeforePurchOrderHeaderInitRecord(var PurchOrderHeader: Record "Purchase Header"; var PurchHeader: Record "Purchase Header")
    begin
        recGenJournalTemplate.Get(PurchHeader."Gen. Journal Template Code");
        PurchOrderHeader."No." := NoSeriesMgt.GetNextNo(recGenJournalTemplate."Purchase Order No. Series", PurchHeader."Posting Date", TRUE);
        PurchHeader."No. Series" := '';
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", 'OnBeforePurchOrderHeaderModify', '', false, false)]
    local procedure OnBeforePurchOrderHeaderModify(var PurchOrderHeader: Record "Purchase Header"; BlanketOrderPurchHeader: Record "Purchase Header")
    var
    begin
        recGenJournalTemplate.Get(BlanketOrderPurchHeader."Gen. Journal Template Code");
        PurchOrderHeader.Validate("Gen. Journal Template Code", recGenJournalTemplate."Order Template Code");
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnBeforeTestNoSeries', '', false, false)]
    local procedure OnBeforeTestNoSeries(var PurchaseHeader: Record "Purchase Header";
   var IsHandled: Boolean)
    begin
        IsHandled := true;
        if recGenJournalTemplate.Get(PurchaseHeader."Gen. Journal Template Code") then
            if IsHandled then
                case PurchaseHeader."Document Type" of
                    PurchaseHeader."Document Type"::Quote:
                        begin
                            recGenJournalTemplate.TestField("No. Series");
                            recGenJournalTemplate.TestField("Order Template Code");
                            recGenJournalTemplate.TestField("Purchase Order No. Series");
                        end;
                    PurchaseHeader."Document Type"::Order:
                        begin
                            recGenJournalTemplate.TestField("No. Series");
                            recGenJournalTemplate.TestField("Posting Invoice No. Series");
                            recGenJournalTemplate.TestField("Posting Shipment No. Series");
                        end;
                    PurchaseHeader."Document Type"::Invoice:
                        begin
                            recGenJournalTemplate.TESTFIELD("No. Series");
                            recGenJournalTemplate.TESTFIELD("Posting Invoice No. Series");
                            recGenJournalTemplate.TESTFIELD("Posting Shipment No. Series");
                        end;
                    PurchaseHeader."Document Type"::"Return Order":
                        begin
                            recGenJournalTemplate.TESTFIELD("No. Series");
                            recGenJournalTemplate.TESTFIELD("Posting Invoice No. Series");
                            recGenJournalTemplate.TESTFIELD("Posting Shipment No. Series");
                        end;
                    PurchaseHeader."Document Type"::"Credit Memo":
                        begin
                            recGenJournalTemplate.TESTFIELD("No. Series");
                            recGenJournalTemplate.TESTFIELD("Posting Invoice No. Series");
                            recGenJournalTemplate.TESTFIELD("Posting Shipment No. Series");
                        end;
                    PurchaseHeader."Document Type"::"Blanket Order":
                        begin
                            recGenJournalTemplate.TESTFIELD("No. Series");
                            recGenJournalTemplate.TESTFIELD("Order Template Code");
                        end;
                end;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCode(PurchSetup: Record "Purchases & Payables Setup";
    var NoSeriesCode: Code[20];
    var IsHandled: Boolean;
    var PurchaseHeader: Record "Purchase Header")
    var
        PurchPaySetup: Record "Purchases & Payables Setup";
    begin
        IsHandled := true;

        if recGenJournalTemplate.GET(PurchaseHeader."Gen. Journal Template Code") then
            NoSeriesCode := recGenJournalTemplate."No. Series";
    end;


    [EventSubscriber(ObjectType::Table, Database::"purchase Header", 'OnBeforeInitInsert', '', false, false)]
    local procedure OnBeforeInitInsertPurch(var PurchaseHeader: Record "Purchase Header"; var xPurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        IsHandled := true;
        NoSeriesMgt.InitSeries(PurchaseHeader.GetNoSeriesCode(), xPurchaseHeader."No. Series", PurchaseHeader."Posting Date", PurchaseHeader."No.", PurchaseHeader."No. Series");
    end;


    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure OnAfterGetNoSeriesCode(var PurchHeader: Record "Purchase Header";
    PurchSetup: Record "Purchases & Payables Setup";
    var NoSeriesCode: Code[20])
    begin
        recGenJournalTemplate.GET(PurchHeader."Gen. Journal Template Code");
        NoSeriesCode := recGenJournalTemplate."No. Series";
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure OnAfterCopyBuyFromVendorFieldsFromVendor(var PurchaseHeader: Record "Purchase Header";
    Vendor: Record Vendor;
    xPurchaseHeader: Record "Purchase Header")
    begin
        if recGenJournalTemplate.Get(PurchaseHeader."Gen. Journal Template Code") then begin
            if PurchaseHeader."Shortcut Dimension 1 Code" = '' then begin
                PurchaseHeader."Shortcut Dimension 1 Code" := recGenJournalTemplate."Shortcut Dimension 1 Code";
                //   PurchaseHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");
            end
            else begin
                PurchaseHeader."Shortcut Dimension 1 Code" := recGenJournalTemplate."Shortcut Dimension 1 Code";

                //  PurchaseHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");
                //  PurchaseHeader.Modify();
            end;
            // if PurchaseHeader."Shortcut Dimension 2 Code" = '' then begin
            //     PurchaseHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code");
            // end
            // else begin
            //     PurchaseHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code");
            //     PurchaseHeader.Modify();
            // end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnBeforeUpdateLocationCode', '', false, false)]
    local procedure OnBeforeUpdateLocationCode(var PurchaseHeader: Record "Purchase Header";
    LocationCode: Code[10];
    var IsHandled: Boolean)
    begin
        IsHandled := true;
        if recGenJournalTemplate.Get(PurchaseHeader."Gen. Journal Template Code") then begin
            PurchaseHeader.Validate("Location Code", recGenJournalTemplate."Location Code");
            IsHandled := true;
        end;
    end;

    ///Gen Journal Template For Purchase/////
    /// 
    ///Gen Journal Template For Sale/////
    /// tanuj
    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeTestNoSeries', '', false, false)]
    local procedure OnBeforeTestNoSeriesSales(var SalesHeader: Record "Sales Header";
          var IsHandled: Boolean)
    begin
        IsHandled := true;
        recGenJournalTemplate.Get(SalesHeader."Gen. Journal Template Code");
        if IsHandled then
            case SalesHeader."Document Type" of
                SalesHeader."Document Type"::Quote:
                    begin
                        recGenJournalTemplate.TestField("No. Series");
                        recGenJournalTemplate.TestField("Order Template Code");
                    end;
                SalesHeader."Document Type"::Order:
                    begin
                        recGenJournalTemplate.TestField("No. Series");
                        recGenJournalTemplate.TestField("Posting Invoice No. Series");
                        recGenJournalTemplate.TestField("Posting Shipment No. Series");
                    end;
                SalesHeader."Document Type"::Invoice:
                    begin
                        recGenJournalTemplate.TESTFIELD("No. Series");
                        recGenJournalTemplate.TESTFIELD("Posting Invoice No. Series");
                        recGenJournalTemplate.TESTFIELD("Posting Shipment No. Series");
                    end;
                SalesHeader."Document Type"::"Return Order":
                    begin
                        recGenJournalTemplate.TESTFIELD("No. Series");
                        recGenJournalTemplate.TESTFIELD("Posting Invoice No. Series");
                        recGenJournalTemplate.TESTFIELD("Posting Shipment No. Series");
                    end;
                SalesHeader."Document Type"::"Credit Memo":
                    begin
                        recGenJournalTemplate.TESTFIELD("No. Series");
                        recGenJournalTemplate.TESTFIELD("Posting Invoice No. Series");
                        recGenJournalTemplate.TESTFIELD("Posting Shipment No. Series");
                    end;
                SalesHeader."Document Type"::"Blanket Order":
                    begin
                        recGenJournalTemplate.TESTFIELD("No. Series");
                        recGenJournalTemplate.TESTFIELD("Order Template Code");
                    end;
            end;
        IsHandled := true;
    end;


    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure OnAfterGetNoSeriesCodeSales(var SalesHeader: Record "Sales Header";
    SalesReceivablesSetup: Record "Sales & Receivables Setup";
    var NoSeriesCode: Code[20])
    begin
        recGenJournalTemplate.GET(SalesHeader."Gen. Journal Template Code");
        NoSeriesCode := recGenJournalTemplate."No. Series";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header";
    SellToCustomer: Record Customer;
    CurrentFieldNo: Integer;
    var SkipBillToContact: Boolean)
    begin
        if recGenJournalTemplate.Get(SalesHeader."Gen. Journal Template Code") then begin
            if SalesHeader."Shortcut Dimension 1 Code" = '' then begin
                SalesHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code")
            end
            else begin
                SalesHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");
                SalesHeader.Modify();
            end;
            if SalesHeader."Shortcut Dimension 2 Code" = '' then begin
                SalesHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code")
            end
            else begin
                SalesHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code");
                SalesHeader.Modify();
            end;
            if SalesHeader."Location Code" = '' then begin
                SalesHeader.Validate("Location Code", recGenJournalTemplate."Location Code");
                SalesHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");   //New                
                SalesHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code");
            end
            else begin
                SalesHeader.Validate("Location Code", recGenJournalTemplate."Location Code");
                SalesHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");   //New                
                SalesHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code");
                SalesHeader.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification(var SalesHeader: Record "Sales Header";
    xSalesHeader: Record "Sales Header")
    begin
        if recGenJournalTemplate.Get(SalesHeader."Gen. Journal Template Code") then begin
            if SalesHeader."Shortcut Dimension 1 Code" = '' then begin
                SalesHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code")
            end
            else begin
                SalesHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");
                SalesHeader.Modify();
            end;
            if SalesHeader."Shortcut Dimension 2 Code" = '' then begin
                SalesHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code")
            end
            else begin
                SalesHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code");
                SalesHeader.Modify();
            end;
            if SalesHeader."Location Code" = '' then begin
                SalesHeader.Validate("Location Code", recGenJournalTemplate."Location Code");
                SalesHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");   //New                
                SalesHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code");
            end
            else begin
                SalesHeader.Validate("Location Code", recGenJournalTemplate."Location Code");
                SalesHeader.validate("Shortcut Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");   //New
                SalesHeader.validate("Shortcut Dimension 2 Code", recGenJournalTemplate."Shortcut Dimension 2 Code");
                SalesHeader.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeUpdateLocationCode', '', false, false)]
    local procedure OnBeforeUpdateLocationCodeSale(var SalesHeader: Record "Sales Header";
    LocationCode: Code[10];
    var IsHandled: Boolean)
    begin
        IsHandled := true;
        if recGenJournalTemplate.Get(SalesHeader."Gen. Journal Template Code") then begin
            recGenJournalTemplate.TestField("Location Code");
            SalesHeader.Validate("Location Code", recGenJournalTemplate."Location Code");
            IsHandled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeInitRecord', '', false, false)]
    local procedure OnBeforeInitRecordSale(var SalesHeader: Record "Sales Header";
    var IsHandled: Boolean;
    xSalesHeader: Record "Sales Header")
    begin
        recGenJournalTemplate.Get(SalesHeader."Gen. Journal Template Code");
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Quote, SalesHeader."Document Type"::"Blanket Order":
                begin
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."No. Series", recGenJournalTemplate."Purchase Order No. Series");
                    // SalesHeader."No. Series" := recGenJournalTemplate."Purchase Order No. Series";
                    SalesHeader."No. Series" := recGenJournalTemplate."No. Series";
                end;
            SalesHeader."Document Type"::Order:
                begin
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SalesSetup."Posted Invoice Nos.");
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Shipping No. Series", SalesSetup."Posted Shipment Nos.");
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                        NoSeriesMgt.SetDefaultSeries(SalesHeader."Prepayment No. Series", SalesSetup."Posted Prepmt. Inv. Nos.");
                        NoSeriesMgt.SetDefaultSeries(SalesHeader."Prepmt. Cr. Memo No. Series", SalesSetup."Posted Prepmt. Cr. Memo Nos.");
                    end;
                end;
            SalesHeader."Document Type"::Invoice:
                begin
                    if (SalesHeader."No. Series" <> '') and (SalesSetup."Invoice Nos." = SalesSetup."Posted Invoice Nos.") then
                        SalesHeader."Posting No. Series" := SalesHeader."No. Series"
                    else
                        NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SalesSetup."Posted Invoice Nos.");
                    if SalesSetup."Shipment on Invoice" then NoSeriesMgt.SetDefaultSeries(SalesHeader."Shipping No. Series", SalesSetup."Posted Shipment Nos.");
                end;
            SalesHeader."Document Type"::"Return Order":
                begin
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SalesSetup."Posted Credit Memo Nos.");
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Return Receipt No. Series", SalesSetup."Posted Return Receipt Nos.");
                end;
            SalesHeader."Document Type"::"Credit Memo":
                begin
                    if (SalesHeader."No. Series" <> '') and (SalesSetup."Credit Memo Nos." = SalesSetup."Posted Credit Memo Nos.") then
                        SalesHeader."Posting No. Series" := SalesHeader."No. Series"
                    else
                        NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SalesSetup."Posted Credit Memo Nos.");
                    if SalesSetup."Return Receipt on Credit Memo" then NoSeriesMgt.SetDefaultSeries(SalesHeader."Return Receipt No. Series", SalesSetup."Posted Return Receipt Nos.");
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Blanket Sales Order to Order", 'OnBeforeSalesOrderHeaderModify', '', false, false)]
    local procedure OnBeforeSalesOrderHeaderModify(var SalesOrderHeader: Record "Sales Header";
    BlanketOrderSalesHeader: Record "Sales Header")
    begin
        recGenJournalTemplate.Get(BlanketOrderSalesHeader."Gen. Journal Template Code");
        SalesOrderHeader.Validate("Gen. Journal Template Code", recGenJournalTemplate."Order Template Code");
    end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    // local procedure OnBeforeInsertSalesOrderHeader(var SalesOrderHeader: Record "Sales Header";
    // var SalesQuoteHeader: Record "Sales Header")
    // begin
    //     recGenJournalTemplate.Get(SalesQuoteHeader."Gen. Journal Template Code");
    //     SalesOrderHeader.Validate("Gen. Journal Template Code", recGenJournalTemplate."Order Template Code");
    //     if (SalesOrderHeader."Document Type" = SalesOrderHeader."Document Type"::"Blanket Order") or (SalesOrderHeader."Document Type" = SalesOrderHeader."Document Type"::Quote) then begin
    //         recGenJournalTemplate.Get(SalesQuoteHeader."Gen. Journal Template Code");
    //         SalesOrderHeader."No." := NoSeriesMgt.GetNextNo(recGenJournalTemplate."Purchase Order No. Series", SalesOrderHeader."Posting Date", TRUE);
    //         SalesOrderHeader."No. Series" := '';
    //     end;
    // end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure OnBeforeInsertSalesOrderHeader(
    var SalesOrderHeader: Record "Sales Header";
    var SalesQuoteHeader: Record "Sales Header")
    var
        recGenJournalTemplate: Record "Gen. Journal Template";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        // Check if Gen. Journal Template Code is set
        if SalesQuoteHeader."Gen. Journal Template Code" = '' then
            exit;

        // Get the template
        if not recGenJournalTemplate.Get(SalesQuoteHeader."Gen. Journal Template Code") then
            exit;
        if recGenJournalTemplate.Get(SalesQuoteHeader."Gen. Journal Template Code") then;
        // Assign Order Template Code
        SalesOrderHeader.Validate("Gen. Journal Template Code", recGenJournalTemplate."Template Convert");

        // Set No. from Purchase Order No. Series only for Blanket Order or Quote
        if (SalesOrderHeader."Document Type" in [SalesOrderHeader."Document Type"::"Blanket Order", SalesOrderHeader."Document Type"::Order]) then begin

            // // Check if Purchase Order No. Series is available
            // if recGenJournalTemplate."Purchase Order No. Series" = '' then
            //     Error('No Purchase Order No. Series defined in Gen. Journal Template.');
            if recGenJournalTemplate.Get(SalesOrderHeader."Gen. Journal Template Code") then;

            SalesOrderHeader."No." :=
                NoSeriesMgt.GetNextNo(recGenJournalTemplate."No. Series", SalesOrderHeader."Posting Date", true);
            SalesOrderHeader."No. Series" := recGenJournalTemplate."No. Series"; // Optional, if needed
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Blanket Sales Order to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure OnBeforeInsertSalesOrderHeader1(var SalesOrderHeader: Record "Sales Header"; var BlanketOrderSalesHeader: Record "Sales Header")
    begin
        recGenJournalTemplate.Get(BlanketOrderSalesHeader."Gen. Journal Template Code");
        SalesOrderHeader."No." := NoSeriesMgt.GetNextNo(recGenJournalTemplate."Purchase Order No. Series", BlanketOrderSalesHeader."Posting Date", TRUE);
        BlanketOrderSalesHeader."No. Series" := '';
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCodeSales(var SalesHeader: Record "Sales Header";
       SalesSetup: Record "Sales & Receivables Setup";
       var NoSeriesCode: Code[20];
       var IsHandled: Boolean)
    begin
        IsHandled := true;
        recGenJournalTemplate.GET(SalesHeader."Gen. Journal Template Code");
        NoSeriesCode := recGenJournalTemplate."No. Series";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInitInsert', '', false, false)]
    local procedure OnBeforeInitInsert(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
    begin
        IsHandled := true;
        NoSeriesMgt.InitSeries(SalesHeader.GetNoSeriesCode(), xSalesHeader."No. Series", SalesHeader."Posting Date", SalesHeader."No.", SalesHeader."No. Series");
    end;

    [EventSubscriber(ObjectType::Table, database::"Production Order", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCodePro(var ProductionOrder: Record "Production Order";
    MfgSetup: Record "Manufacturing Setup";
    var NoSeriesCode: Code[20];
    var IsHandled: Boolean)
    begin
        IsHandled := true;
        case ProductionOrder.Status of
            ProductionOrder.Status::Simulated:
                NoSeriesCode := MfgSetup."Simulated Order Nos.";
            ProductionOrder.Status::Planned:
                NoSeriesCode := MfgSetup."Planned Order Nos.";
            ProductionOrder.Status::"Firm Planned":
                begin
                    recGenJournalTemplate.Get(ProductionOrder."Gen. Journal Template Code");
                    recGenJournalTemplate.TestField("No. Series");
                    NoSeriesCode := recGenJournalTemplate."No. Series";
                    ProductionOrder.Validate("Location Code", recGenJournalTemplate."Location Code");
                    ProductionOrder.Validate("No. Series", recGenJournalTemplate."No. Series");
                end;
            ProductionOrder.Status::Released:
                begin
                    recGenJournalTemplate.Get(ProductionOrder."Gen. Journal Template Code");
                    recGenJournalTemplate.TestField("No. Series");
                    NoSeriesCode := recGenJournalTemplate."No. Series";
                    ProductionOrder.Validate("Location Code", recGenJournalTemplate."Location Code");
                    ProductionOrder.Validate("No. Series", recGenJournalTemplate."No. Series");
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCodeTransfer(

   var TransferHeader: Record "Transfer Header";
      InventorySetup: Record "Inventory Setup";
      var NoSeriesCode: Code[20];
      var IsHandled: Boolean)
    begin
        IsHandled := true;
        begin
            recGenJournalTemplate.Get(TransferHeader."Gen. Journal Template Code");
            recGenJournalTemplate.TestField("No. Series");
            NoSeriesCode := recGenJournalTemplate."No. Series";
            TransferHeader.Validate("Transfer-from Code", recGenJournalTemplate."Location Code");
            TransferHeader.Validate("No. Series", recGenJournalTemplate."No. Series");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Fixed Asset", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertFixedAsset(var Rec: Record "Fixed Asset"; RunTrigger: Boolean)
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        // Try to get the Gen. Journal Template
        if not GenJournalTemplate.Get(Rec."Gen. Journal Template Code") then
            exit;

        Rec.Validate("Location Code", GenJournalTemplate."Location Code");
        Rec.Validate("No. Series", GenJournalTemplate."No. Series");
        Rec.Validate("Global Dimension 1 Code", GenJournalTemplate."Shortcut Dimension 1 Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", 'OnAfterSalesQuoteToOrderRun', '', false, false)]
    local procedure MyOnAfterSalesQuoteToOrderRun(var SalesHeader2: Record "Sales Header"; var SalesHeader: Record "Sales Header")
    var
        GenJourTemp: Record "Gen. Journal Template";
    begin
        // Your custom logic here
        // Message('Sales Quote %1 has been converted to Sales Order %2.', SalesHeader2."No.", SalesHeader."No.");
        recGenJournalTemplate.Get(SalesHeader."Gen. Journal Template Code");
        if SalesHeader."Gen. Journal Template Code" = recGenJournalTemplate.Name then
            recGenJournalTemplate.Name := recGenJournalTemplate."Template Convert";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeCheckPostingGroupChange, '', false, false)]
    local procedure OnBeforeCheckPostingGroupChange(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        PostingGroupChangeInterface: Interface "Posting Group Change Method";
    begin
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Employee then
            IsHandled := true;
    end;

    //Sales Line To Unit of Measure
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnValidateUnitOfMeasureCodeOnAfterGetItemData, '', false, false)]
    local procedure "Sales Line_OnValidateUnitOfMeasureCodeOnAfterGetItemData"(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; Item: Record Item)
    var
        ItemUnitOfMeasureRec: Record "Item Unit of Measure";
        SalesLineDiscountRec: Record "Sales Line Discount";
        UnitofMeasure: Record "Unit of Measure";
        CalculateTax: Codeunit "Calculate Tax";
    begin
        if SalesLine.Type = SalesLine.Type::Item then begin
            ItemUnitOfMeasureRec.Reset();
            ItemUnitOfMeasureRec.SetRange("Item No.", SalesLine."No.");
            ItemUnitOfMeasureRec.SetRange(Code, SalesLine."Unit of Measure Code");
            if ItemUnitOfMeasureRec.FindFirst() then begin
                SalesLine."UOM Conversion" := ItemUnitOfMeasureRec."Qty. per Unit of Measure";
            end;
        end;
    end;



    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeUpdateAmounts, '', false, false)]
    // local procedure "Sales Line_OnBeforeUpdateAmounts"(var SalesLine: Record "Sales Line")
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Insert G/L Account", OnAfterRun, '', false, false)]
    local procedure "FA Insert G/L Account_OnAfterRun"(var FALedgerEntry: Record "FA Ledger Entry"; var TempFAGLPostingBuffer: Record "FA G/L Posting Buffer" temporary; var NumberOfEntries: Integer; var OrgGenJnlLine: Boolean; var NetDisp: Boolean; var FAGLPostingBuffer: Record "FA G/L Posting Buffer"; var DisposalEntry: Boolean; var BookValueEntry: Boolean; var NextEntryNo: Integer; var GLEntryNo: Integer; var DisposalEntryNo: Integer; var DisposalAmount: Decimal; var GainLossAmount: Decimal; var FAPostingGroup2: Record "FA Posting Group")
    begin
    end;
    
    // begin
    //     SalesLine."Line Discount Amount" := (SalesLine."Total Cash Discount" + SalesLine."Total P.P Discount" + SalesLine."Total Other Discount");

    // end;


    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnValidateQuantityOnBeforeResetAmounts, '', false, false)]
    // local procedure "Sales Line_OnValidateQuantityOnBeforeResetAmounts"(var SalesLine: Record "Sales Line")
    // begin
    //     SalesLine."Line Discount Amount" := (SalesLine."Total Cash Discount" + SalesLine."Total P.P Discount" + SalesLine."Total Other Discount");
    // end;

}


