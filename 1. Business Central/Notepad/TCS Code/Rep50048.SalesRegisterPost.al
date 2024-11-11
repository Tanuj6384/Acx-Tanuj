report 50548 SalesRegisterPost
{
    ApplicationArea = All;
    Caption = 'Sales Register Post';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date", "Sell-to Customer No.";

            CalcFields = "Booking Station", "Freight Type", "Shipping Agent Code Name", Document_Type;

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = SalesInvoiceHeader;
                DataItemLink = "Document No." = field("No.");



                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                var
                    SalesinvLine5: Record "Sales Invoice Line";
                begin
                    txtCGSTRateHSN := 0;
                    txtSGSTRateHSN := 0;
                    txtIGSTRateHSN := 0;
                    decTotaCGSTamtHSN := 0;
                    decTotaSGSTamtHSN := 0;
                    decTotaIGSTamtHSN := 0;
                    TotalGstAmount := 0;

                    recDetGSTLedHSN.Reset();
                    recDetGSTLedHSN.SetRange("Document No.", "Document No.");
                    recDetGSTLedHSN.SetRange("Document Line No.", "Line No.");
                    recDetGSTLedHSN.SetRange("No.", "No.");
                    recDetGSTLedHSN.SetRange("HSN/SAC Code", "HSN/SAC Code");
                    IF recDetGSTLedHSN.Find('-') then begin
                        repeat
                            IF recDetGSTLedHSN."GST Component Code" = 'CGST' then begin
                                decTotaCGSTamtHSN += Abs(recDetGSTLedHSN."GST Amount");
                                txtCGSTRateHSN := recDetGSTLedHSN."GST %";
                                IF decTotaCGSTamtHSN = 0 then
                                    txtCGSTRateHSN := 0;

                            End;
                            IF recDetGSTLedHSN."GST Component Code" = 'SGST' then begin
                                decTotaSGSTamtHSN += Abs(recDetGSTLedHSN."GST Amount");
                                txtSGSTRateHSN := recDetGSTLedHSN."GST %";
                                IF decTotaSGSTamtHSN = 0 then
                                    txtSGSTRateHSN := 0;
                            End;
                            IF recDetGSTLedHSN."GST Component Code" = 'IGST' then begin
                                decTotaIGSTamtHSN += Abs(recDetGSTLedHSN."GST Amount");
                                txtIGSTRateHSN := recDetGSTLedHSN."GST %";
                                IF decTotaIGSTamtHSN = 0 then
                                    txtIGSTRateHSN := 0;
                            End;
                        Until recDetGSTLedHSN.Next() = 0;
                        TotalGstAmount := decTotaCGSTamtHSN + decTotaSGSTamtHSN + decTotaIGSTamtHSN
                    end;

                    TCSAmount := 0;
                    TCSRate := 0;
                    recSalesinline.Reset();
                    recSalesinline.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    recSalesinline.SetRange("Line No.", "Sales Invoice Line"."Line No.");
                    if recSalesinline.FindFirst() then begin
                        TaxTransactionValue.Reset();
                        TaxTransactionValue.SetRange("Tax Record ID", recSalesinline.RecordId);
                        TaxTransactionValue.SetRange("Tax Type", 'TCS');
                        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                        if TaxTransactionValue.FindSet() then
                            TCSAmount := TaxTransactionValue.Amount;
                        TCSRate := TaxTransactionValue.Percent;
                    end;

                    // lPurchInvHeader: Record "Purch. Inv. Header";
                    // DGLE: Record "Detailed GST Ledger Entry";
                    // TaxTransactionValue: Record "Tax Transaction Value";
                    // GSTSetup: Record "GST Setup";
                    // puchinline: Record "Purch. Inv. Line";

                    // recsalesheader.Reset();
                    // recsalesheader.SetRange("No.", "Sales Line"."Document No.");
                    // if recsalesheader.FindFirst() then begin
                    //     OEMExport := recsalesheader."OEM/EXPORT";
                    //  end;

                    RecSate.Reset();
                    RecSate.SetRange(Code, SalesInvoiceHeader.State);
                    If RecSate.FindFirst() then begin
                        SateName := RecSate.Description;
                    end;
                    Item.Reset();
                    Item.SetRange("No.", "Sales Invoice Line"."No.");
                    if Item.FindFirst() then begin
                        // RecItemGroup := Item."Item Type";
                        // ProdcutGroup := Item.Product_GroupCode;
                        // InvenrtyGroup := Item."Inventory Posting Group";
                    end;
                    //shivam
                    "Sales Invoice Line".CalcFields("Sales Invoice Line"."Stage Type", "Sales Invoice Line"."Plan Type", "Sales Invoice Line"."Parent Group", "Sales Invoice Line"."Sub Parent Group", "Sales Invoice Line"."Child Group", "Sales Invoice Line"."Item Type", "Sales Invoice Line".Product_Group_Type);
                    stagetype := "Sales Invoice Line"."Stage Type";
                    plantype := "Sales Invoice Line"."Plan Type";
                    parentgroup := "Sales Invoice Line"."Parent Group";
                    subparent := "Sales Invoice Line"."Sub Parent Group";
                    child := "Sales Invoice Line"."Child Group";
                    itemtype := "Sales Invoice Line"."Item Type";
                    ProdcutGroup := "Sales Invoice Line".Product_Group_Type;
                    //shivam

                    magictxt := '';
                    SalesinvLine.Reset();
                    SalesinvLine.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    SalesinvLine.SetRange(Type, "Sales Invoice Line".Type::Item);
                    //   SalesinvLine.SetRange(Type, "Sales Invoice Line".Type::"G/L Account");
                    // SalesinvLine.SetFilter("No.", '<>%1', '4510000014');
                    SalesinvLine.SetRange("Line No.", "Sales Invoice Line"."Line No.");
                    if SalesinvLine.FindFirst() then begin



                        // if SalesinvLine.Type<>SalesinvLine.Type::"G/L Account" then begin    
                        //  magictxt := '';
                        repeat
                            // "Sales Invoice Line".CalcFields("Sales Invoice Line"."Parent Group");
                            // RecItemGroup := "Sales Invoice Line"."Parent Group";
                            SalesShipmentLine1.Reset();
                            SalesShipmentLine1.SetRange("Document No.", SalesinvLine."Shipment No.");
                            SalesShipmentLine1.SetRange("Order Line No.", SalesinvLine."Order Line No.");
                            if SalesShipmentLine1.FindFirst() then begin
                                //  if SalesinvLine.Type<>SalesinvLine.Type::"G/L Account" then
                                // begin

                                // repeat
                                itemDecription.Reset();
                                itemDecription.SetRange("No.", SalesShipmentLine1."Document No.");
                                // itemDecription.SetRange("Document Line No.", SalesShipmentLine1."Line No.");
                                itemDecription.SetRange("Document Line No.", SalesShipmentLine1."Order Line No.");

                                IF itemDecription.FindFirst() then begin
                                    repeat
                                        if magictxt <> '' then
                                            magictxt += '|';
                                        magictxt += itemDecription.Comment;
                                    until itemDecription.Next() = 0;
                                    // magictxt:=text1;
                                end;
                                // until SalesShipmentLine1.Next() = 0;
                            end;
                        // end;
                        until SalesinvLine.Next() = 0;

                    end;
                    //   


                    if (DocNo <> "Sales Invoice Line"."Document No.") then
                        if (DocNo <> '') then begin
                            MakeFooter();
                            Clear(TotalQuanity);
                            Clear(TotalSGST);
                            Clear(TotalCGST);
                            Clear(TotalIGST);
                            Clear(TotalUnitPrice);
                            Clear(TotalMRPPrice);
                            Clear(TotalDicAmount);
                            Clear(TotalNetRete);
                            Clear(TotalineAmount);
                            Clear(TotalTCS);
                        end;


                    DocNo := "Sales Invoice Line"."Document No.";
                    TotalQuanity += "Sales Invoice Line".Quantity;
                    TotalUnitPrice += "Sales Invoice Line"."Unit Price";
                    TotalDicAmount += "Sales Invoice Line"."Line Discount Amount";
                    TotalNetRete += "Sales Invoice Line"."Net Rate";
                    TotalineAmount += "Sales Invoice Line"."Line Amount";
                    TotalMRPPrice += "Sales Invoice Line"."MRP Unit Price";
                    TotalSGST += decTotaSGSTamtHSN;
                    TotalIGST += decTotaIGSTamtHSN;
                    TotalCGST += decTotaCGSTamtHSN;
                    TotalTCS += TCSAmount;
                    GrantTotal := TCSAmount + TotalGstAmount + "Line Amount";

                    Sno += 1;
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn(Sno, FALSE, '', FALSE, FALSE, FALSE, '', 1);//1
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Invoice Type", FALSE, '', FALSE, FALSE, FALSE, ' ', 1);//32
                    ExcelBuf.AddColumn("Document No.", FALSE, '', FALSE, FALSE, FALSE, ' ', 1);//2
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Posting Date", FALSE, '', FALSE, FALSE, FALSE, ' ', 1);//3
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, ' ', 1);//4
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', 1);//5
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to City", FALSE, '', FALSE, FALSE, FALSE, '', 1);//33
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to Post Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//37
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//6
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Customer GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//38
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Shipping Marking Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//39
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Delivery Type", FALSE, '', FALSE, FALSE, FALSE, '', 1);//40
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Freight Type", FALSE, '', FALSE, FALSE, FALSE, '', 1);//41
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', 1);//7
                    ExcelBuf.AddColumn(SalesInvoiceHeader."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//8
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//9
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//10
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Booking Station", FALSE, '', FALSE, FALSE, FALSE, '', 1);//11
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', 1);//35
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Currency Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//72
                    ExcelBuf.AddColumn(Type, FALSE, '', FALSE, FALSE, FALSE, '', 1);//12
                    ExcelBuf.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//13
                    ExcelBuf.AddColumn("Variant Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//14
                    ExcelBuf.AddColumn(Description, FALSE, '', FALSE, FALSE, FALSE, '', 1);//15
                    ExcelBuf.AddColumn("Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', 1);//34

                    ExcelBuf.AddColumn("Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//36
                    ExcelBuf.AddColumn("Customer Disc. Group", FALSE, '', FALSE, FALSE, FALSE, '', 1);//59
                    ExcelBuf.AddColumn("Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', 1);//60
                    ExcelBuf.AddColumn("Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', 1);//61
                    ExcelBuf.AddColumn(itemtype, FALSE, '', FALSE, FALSE, FALSE, '', 1);//62
                    ExcelBuf.AddColumn(ProdcutGroup, FALSE, '', FALSE, FALSE, FALSE, '', 1);//63
                    ExcelBuf.AddColumn(InvenrtyGroup, FALSE, '', FALSE, FALSE, FALSE, '', 1);//64
                    ExcelBuf.AddColumn(stagetype, FALSE, '', FALSE, FALSE, FALSE, '', 1);//54
                    ExcelBuf.AddColumn(plantype, FALSE, '', FALSE, FALSE, FALSE, '', 1);//55
                    ExcelBuf.AddColumn(parentgroup, FALSE, '', FALSE, FALSE, FALSE, '', 1);//56
                    ExcelBuf.AddColumn(subparent, FALSE, '', FALSE, FALSE, FALSE, '', 1);//57
                    ExcelBuf.AddColumn(child, FALSE, '', FALSE, FALSE, FALSE, '', 1);//58
                    ExcelBuf.AddColumn("Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', 1);//16
                    ExcelBuf.AddColumn(Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//17

                    ExcelBuf.AddColumn("MRP Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//18
                    ExcelBuf.AddColumn("Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//19
                    ExcelBuf.AddColumn("Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//20
                    ExcelBuf.AddColumn("Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//21
                    ExcelBuf.AddColumn("Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//22
                    ExcelBuf.AddColumn("Net Rate", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//23
                    ExcelBuf.AddColumn("Net Weight", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//69
                    ExcelBuf.AddColumn("GST Group Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//24
                    ExcelBuf.AddColumn("HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//25
                    ExcelBuf.AddColumn("GST Credit", FALSE, '', FALSE, FALSE, FALSE, '', 1);//26
                    ExcelBuf.AddColumn(decTotaSGSTamtHSN, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//27
                    ExcelBuf.AddColumn(decTotaCGSTamtHSN, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//28
                    ExcelBuf.AddColumn(decTotaIGSTamtHSN, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//29
                    ExcelBuf.AddColumn(TotalGstAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//70
                    ExcelBuf.AddColumn(TCSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//30
                    ExcelBuf.AddColumn(GrantTotal, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//72
                    ExcelBuf.AddColumn("Assessee Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//31
                    ExcelBuf.AddColumn(magictxt, FALSE, '', FALSE, FALSE, FALSE, '', 1);//71
                    ExcelBuf.AddColumn(magictxt1, FALSE, '', FALSE, FALSE, FALSE, '', 1);//72
                                                                                         // ExcelBuf.AddColumn(SalesInvoiceHeader."Shipping Marking Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//65
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to Name", FALSE, '', FALSE, FALSE, FALSE, '', 1);//66
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to Address", FALSE, '', FALSE, FALSE, FALSE, '', 1);//67
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to Address 2", FALSE, '', FALSE, FALSE, FALSE, '', 1);//68
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to City", FALSE, '', FALSE, FALSE, FALSE, '', 1);//49
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to Post Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//50
                    ExcelBuf.AddColumn(SateName, FALSE, '', FALSE, FALSE, FALSE, '', 1);//61
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to Contact", FALSE, '', FALSE, FALSE, FALSE, '', 1);//51
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to Phone No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//52

                    ExcelBuf.AddColumn(SalesInvoiceHeader."Mode of  Transport New", FALSE, '', FALSE, FALSE, FALSE, '', 1);//42     
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Vehicle No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//43    
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Vehicle Type", FALSE, '', FALSE, FALSE, FALSE, '', 1);//44    
                    ExcelBuf.AddColumn(EWayBillNo, FALSE, '', FALSE, FALSE, FALSE, '', 1);//45                                                                    // ExcelBuf.AddColumn('Line Net Amount (With Tax)', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//32
                    ExcelBuf.AddColumn(AcknowladgementNo, FALSE, '', FALSE, FALSE, FALSE, '', 1);//46
                    ExcelBuf.AddColumn(AcknowladgemetDate, FALSE, '', FALSE, FALSE, FALSE, '', 1);//47                                                                     // ExcelBuf.AddColumn('Line Net Amount (With Tax)', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//32
                                                                                                  //  ExcelBuf.AddColumn(SalesInvoiceHeader."Ship-to Customer", FALSE, '', FALSE, FALSE, FALSE, '', 1);//48

                    ExcelBuf.AddColumn(SalesInvoiceHeader."Work Description", FALSE, '', FALSE, FALSE, FALSE, '', 1);//53
                    ExcelBuf.AddColumn(SalesInvoiceHeader."Shipping Agent Code Name", FALSE, '', FALSE, FALSE, FALSE, '', 1);//53
                    ExcelBuf.AddColumn(SalesInvoiceHeader.Document_Type, FALSE, '', FALSE, FALSE, FALSE, '', 1);//53
                end;


            }
            trigger OnAfterGetRecord()
            begin

                magictxt1 := '';

                itemDecription.Reset();
                itemDecription.SetRange("No.", "Salesinvoiceheader"."No.");
                itemDecription.SetRange("Document Type", itemDecription."Document Type"::"Posted Invoice");
                itemDecription.SetRange("Document Line No.", 0);
                IF itemDecription.FindFirst() then begin
                    repeat
                        // if itemDecription."Document Line No." = 0 then begin
                        if magictxt1 <> '' then
                            magictxt1 += '|';
                        magictxt1 += itemDecription.Comment;
                    //  end;
                    until itemDecription.Next() = 0;
                end;

                EInvoice.Reset();
                EInvoice.SetRange("No.", SalesInvoiceHeader."No.");
                If EInvoice.FindFirst() then begin
                    EWayBillNo := EInvoice."E-Way Bill No.";
                    AcknowladgementNo := EInvoice."E-Invoice Acknowledge No.";
                    AcknowladgemetDate := EInvoice."E-Invoice Acknowledge Date";
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Item Type"; RecItemGroup)
                    {
                        ApplicationArea = All;
                        TableRelation = ItemType;
                    }
                    field("Prodcut Group"; ProdcutGroup)
                    {
                        ApplicationArea = All;
                        TableRelation = ProductGroupCode;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        //CLEAR(Details);
    end;

    trigger OnPostReport()
    begin
        MakeFooter();
        ExcelBuf.CreateNewBook('Sales Register Posted');
        ExcelBuf.WriteSheet('Sales Register Posted', CompanyName(), UserId());
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename('Sales Register Posted');
        ExcelBuf.OpenExcel();
    end;

    trigger OnPreReport()
    begin

        ExcelBuf.DELETEALL;
        MakeExcelDataHeader;
        Sno := 0;
    end;

    var
        TaxTransactionValue: Record "Tax Transaction Value";
        recSalesinline: Record "Sales Invoice Line";
        SaleINVHeader: Record "Sales Invoice Line";


        EInvoice: Record "E-Way Bill & E-Invoice";
        EWayBillNo: Code[50];
        AcknowladgementNo: Code[60];
        AcknowladgemetDate: Text;
        OEMExport: Option;
        SalesinvLine: Record "Sales Invoice Line";
        itemDecription: Record "Sales Comment Line";
        SalesShipmentLine1: Record "Sales Shipment Line";
        SalesShipmentHeader1: Record "Sales Shipment Header";
        Salesline: Record "Sales Line";
        // itemcom: code[500];
        magictxt: Text;
        magictxt1: Text;
        magictxt2: Text;
        magictxt4: text;
        txtCustState1: text;
        shippingAddress: Code[100];
        shippingAddress1: Code[100];
        ShippingName: Code[100];
        ExcelBuf: Record "Excel Buffer" temporary;
        Sno: Integer;
        recDetGSTLedHSN: Record "Detailed GST Ledger Entry";
        decTotaIGSTamtHSN: Decimal;
        decTotaSGSTamtHSN: Decimal;
        decTotaCGSTamtHSN: Decimal;
        txtIGSTRateHSN: Decimal;
        txtSGSTRateHSN: Decimal;
        txtCGSTRateHSN: Decimal;
        recTCSEntry: Record "TCS Entry";
        TCSAmount: Decimal;
        TCSRate: Decimal;
        TotalGstAmount: Decimal;

        SateName: Code[50];
        RecSate: Record State;
        Item: Record Item;
        InvenrtyGroup: Code[50];
        RecItemGroup: Code[50];
        ProdcutGroup: Code[50];
        DocNo: Code[20];
        TotalQuanity: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TotalCGST: Decimal;
        TotalDicAmount: Decimal;
        TotalUnitPrice: Decimal;
        TotalTCS: Decimal;
        TotalNetRete: Decimal;
        TotalineAmount: Decimal;
        TotalMRPPrice: Decimal;
        stagetype: Code[100];
        plantype: Code[100];
        parentgroup: code[100];
        subparent: code[100];
        child: code[100];
        itemtype: code[100];
        productgroup: code[100];

        GrantTotal: Decimal;

    procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Sr No.', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//1
        ExcelBuf.AddColumn('Document Type', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//32
        ExcelBuf.AddColumn('Document No', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//2
        ExcelBuf.AddColumn('Posting Date', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//3
        ExcelBuf.AddColumn('Customer No', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//4
        ExcelBuf.AddColumn('Customer Name', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//5
        ExcelBuf.AddColumn('City', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//33
        ExcelBuf.AddColumn('PinCode', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//37
        ExcelBuf.AddColumn('Ship to Code', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//6
        ExcelBuf.AddColumn('Customer GST No.', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//38
        ExcelBuf.AddColumn('Shipping Marka', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//39
        ExcelBuf.AddColumn('Delivery Type', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//40
        ExcelBuf.AddColumn('Freight Type', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//41

        ExcelBuf.AddColumn('Order Date', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//7
        ExcelBuf.AddColumn('External Doc No', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//8
        ExcelBuf.AddColumn('Salesperson', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//9
        ExcelBuf.AddColumn('Location', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//10
        ExcelBuf.AddColumn('Booking Station', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//11
        ExcelBuf.AddColumn('Customer Posting Group', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//35
        ExcelBuf.AddColumn('Currency Code', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//72
        ExcelBuf.AddColumn('Type', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//12
        ExcelBuf.AddColumn('Item No', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//13
        ExcelBuf.AddColumn('Variant', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//14
        ExcelBuf.AddColumn('Description', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//15
        ExcelBuf.AddColumn('Gen. Bus. Posting Group', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//34

        ExcelBuf.AddColumn('Item Category Code', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//53
        ExcelBuf.AddColumn('Customer Disc. Group', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//59
        ExcelBuf.AddColumn('Customer Price Group ', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//60
        ExcelBuf.AddColumn('Gen. Prod. Posting Group  ', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//61
        ExcelBuf.AddColumn('Item Type  ', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//62
        ExcelBuf.AddColumn('Product Group  ', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//63
        ExcelBuf.AddColumn('Inventory Group  ', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//64
        ExcelBuf.AddColumn('Stage Type', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//54
        ExcelBuf.AddColumn('Plan Type', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//55
        ExcelBuf.AddColumn('Parent Group', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//56
        ExcelBuf.AddColumn('Sub Parent Group', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//57
        ExcelBuf.AddColumn('Child Group', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//58
        ExcelBuf.AddColumn('UOM', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//16
        ExcelBuf.AddColumn('Quantity', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//17

        ExcelBuf.AddColumn('MRP Unit price', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//18
        ExcelBuf.AddColumn('Unit Price', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//19
        ExcelBuf.AddColumn('Discount %', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//20
        ExcelBuf.AddColumn('Discount Amt', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//21
        ExcelBuf.AddColumn('Amount After Discount', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//22
        ExcelBuf.AddColumn('Net Rate', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//23
        ExcelBuf.AddColumn('Weight', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//69
        ExcelBuf.AddColumn('GST Group', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//24
        ExcelBuf.AddColumn('HSN/SAC', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//25
        ExcelBuf.AddColumn('GSt Credit', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//26
        ExcelBuf.AddColumn('SGST', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//27
        ExcelBuf.AddColumn('CGST', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//28
        ExcelBuf.AddColumn('IGST', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//29
        ExcelBuf.AddColumn('GST Amount', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//70
        ExcelBuf.AddColumn('TCS', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//30
        ExcelBuf.AddColumn('Total Amount Inc.GST', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//73
        ExcelBuf.AddColumn('Section Code', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//31
        ExcelBuf.AddColumn('Line Remark', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//71
        ExcelBuf.AddColumn('Order Remark', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//72
                                                                                 // ExcelBuf.AddColumn('Shpping Marking Code', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//65
        ExcelBuf.AddColumn('Shipping Customer Name', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//66
        ExcelBuf.AddColumn('Shipping Address', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//67
        ExcelBuf.AddColumn('Shipping Address', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//68
        ExcelBuf.AddColumn('Shipping City', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//49
        ExcelBuf.AddColumn('Shipping PinCode', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//50
        ExcelBuf.AddColumn('State', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//61
        ExcelBuf.AddColumn('Customer concern Person', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//51
        ExcelBuf.AddColumn('Customer contact No.', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//52

        ExcelBuf.AddColumn('Mode of transport', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//42
        ExcelBuf.AddColumn('Vehicle No.', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//43
        ExcelBuf.AddColumn('Vechile Type', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//44
        ExcelBuf.AddColumn('E-Way Bill No.', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//45
        ExcelBuf.AddColumn('Acknowledgement No.', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//46
        ExcelBuf.AddColumn('Acknowledgement Date', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//47
                                                                                         // ExcelBuf.AddColumn('Shipping Customer Name', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//48
        ExcelBuf.AddColumn('Remarks/Reason', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//53
        ExcelBuf.AddColumn('Transporter Name', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//53
        ExcelBuf.AddColumn('Document Type', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//53

    end;

    procedure MakeFooter()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total ' + DocNo, FALSE, '', true, FALSE, FALSE, '', 1);//1
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, ' ', 1);//32
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, ' ', 1);//2
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, ' ', 1);//3
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, ' ', 1);//4
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//5
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//33
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//37
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//6
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//38
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//39
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//40
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//41
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//7
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//8
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//9
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//10
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//11
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//35
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//72
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//12
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//13
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//14
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//15
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//34

        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//36
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//59
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//60
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//61
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//62
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//63
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//64
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//54
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//55
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//56
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//57
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//58
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//16
        ExcelBuf.AddColumn(TotalQuanity, FALSE, '', true, FALSE, FALSE, '', 1);//17

        ExcelBuf.AddColumn(TotalMRPPrice, FALSE, '', true, FALSE, FALSE, '', 1);//18
        ExcelBuf.AddColumn(TotalUnitPrice, FALSE, '', true, FALSE, FALSE, '', 1);//19
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//20
        ExcelBuf.AddColumn(TotalDicAmount, FALSE, '', true, FALSE, FALSE, '', 1);//21
        ExcelBuf.AddColumn(TotalineAmount, FALSE, '', true, FALSE, FALSE, '', 1);//22
        ExcelBuf.AddColumn(TotalNetRete, FALSE, '', true, FALSE, FALSE, '', 1);//23
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//69
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//24
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//25
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//26
        ExcelBuf.AddColumn(TotalSGST, FALSE, '', true, FALSE, FALSE, '', 1);//27
        ExcelBuf.AddColumn(TotalCGST, FALSE, '', true, FALSE, FALSE, '', 1);//28
        ExcelBuf.AddColumn(TotalIGST, FALSE, '', true, FALSE, FALSE, '', 1);//29
        ExcelBuf.AddColumn(' ', FALSE, '', true, FALSE, FALSE, '', 1);//70
        ExcelBuf.AddColumn(TotalTCS, FALSE, '', true, FALSE, FALSE, '', 1);//30
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//31
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//71
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//72
                                                                       //  ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//65
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//66
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//67
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//68
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//48
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//49
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//61
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//51 
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//52
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//42     
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//43    
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//44    
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//45                                                                    // ExcelBuf.AddColumn('Line Net Amount (With Tax)', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//32
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//46
        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//47                                                                     // ExcelBuf.AddColumn('Line Net Amount (With Tax)', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//32

        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//50

        ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', 1);//53

    end;
}
