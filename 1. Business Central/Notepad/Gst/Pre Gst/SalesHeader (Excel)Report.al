report 98454 SaleseHeader
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Sales Header Report.rdl';
    Caption = 'Sales Header Report';
    ProcessingOnly=true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(Document_Type; "Document Type") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Order_Date; "Order Date") { }
            column(Posting_Date; "Posting Date") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(Amount; Amount) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Gen__Bus__Posting_Group; "Gen. Bus. Posting Group") { }

            column(Payment_Method_Code; "Payment Method Code") { }
            column(Shipping_Agent_Code; "Shipping Agent Code") { }
            column(Status; Status) { }
            column(Doc__No__Occurrence; "Doc. No. Occurrence") { }
            column(AmountToCust; "Sales Line"."Line Amount") { }//+ gst
            column(Payment_Term_Change_To; "Payment Term Change To") { }
            column(Customer_Type; "Customer Type") { }
            column(RFD; RFD) { }
            column(Order_Type; "Order Type") { }
            column(CFD_Status; "CFD Status") { }
            column(CFD_Pending_Reason; "CFD Pending Reason") { }
            column(Cust__P_O__Date; "Cust. P.O. Date") { }
            column(Released_Date; "Released Date") { }
            column(Customer_Order_No_; "Customer Order No.") { }
            column(Old_ODA_No_; "Old ODA No.") { }
            column(Responsibility_Center; "Responsibility Center") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");

                trigger OnAfterGetRecord()
                begin

                    IGST_Perc := 0;
                    IGST_Amt := 0;
                    CGST_Perc := 0;
                    CGST_Amt := 0;
                    SGST_Perc := 0;
                    SGST_Amt := 0;


                    if ("Sales Line".Type <> "Sales Line".Type::" ") then begin
                        j := 1;
                        TaxTransactionValue.Reset();
                        TaxTransactionValue.SetRange("Tax Record ID", "Sales Line".RecordId);
                        TaxTransactionValue.SetRange("Tax Type", 'GST');
                        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                        if TaxTransactionValue.FindSet() then
                            repeat
                                j := TaxTransactionValue."Value ID";
                                GSTComponentCode[j] := TaxTransactionValue."Value ID";
                                TaxTrnasactionValue1.Reset();
                                TaxTrnasactionValue1.SetRange("Tax Record ID", "Sales Line".RecordId);
                                TaxTrnasactionValue1.SetRange("Tax Type", 'GST');
                                TaxTrnasactionValue1.SetRange("Value Type", TaxTrnasactionValue1."Value Type"::COMPONENT);
                                TaxTrnasactionValue1.SetRange("Value ID", GSTComponentCode[j]);
                                if TaxTrnasactionValue1.FindSet() then
                                    repeat
                                        if j = 6 then begin
                                            SGST_Perc := TaxTrnasactionValue1.Percent;
                                            SGST_Amt := TaxTrnasactionValue1.Amount;
                                        end;

                                        if j = 2 then begin
                                            CGST_Perc := TaxTrnasactionValue1.Percent;
                                            CGST_Amt := TaxTrnasactionValue1.Amount
                                        end;

                                        if j = 3 then begin
                                            IGST_Perc := TaxTrnasactionValue1.Percent;
                                            IGST_Amt := TaxTrnasactionValue1.Amount;
                                        end;

                                        Taxper := SGST_Perc + CGST_Perc + IGST_Perc;
                                    until TaxTrnasactionValue1.Next() = 0;
                                j += 1;
                                TotalTaxAmount += Abs(IGST_Amt + CGST_Amt + SGST_Amt);
                            until TaxTransactionValue.Next() = 0;
                    end;

                    PrintToExcel := TRUE;
                    IF PrintToExcel THEN BEGIN
                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn("Sales Header"."Document Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//1
                        TempExcelBuffer.AddColumn("Sales Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//2
                        TempExcelBuffer.AddColumn("Sales Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//3
                        TempExcelBuffer.AddColumn("Sales Header"."Bill-to Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//4
                        TempExcelBuffer.AddColumn("Sales Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//5
                        TempExcelBuffer.AddColumn("Sales Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//6
                        TempExcelBuffer.AddColumn("Sales Header"."Payment Terms Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//7
                        TempExcelBuffer.AddColumn("Sales Header"."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//8
                        TempExcelBuffer.AddColumn("Sales Header"."Amount", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);//0
                        TempExcelBuffer.AddColumn("Sales Header"."Amount Including VAT", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);//9
                        TempExcelBuffer.AddColumn("Sales Header"."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//10
                        TempExcelBuffer.AddColumn("Sales Header"."Payment Method Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//11
                        TempExcelBuffer.AddColumn("Sales Header"."Shipping Agent Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//12
                        TempExcelBuffer.AddColumn("Sales Header"."Status", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//13
                        TempExcelBuffer.AddColumn("Sales Header"."Doc. No. Occurrence", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//14
                        TempExcelBuffer.AddColumn("Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);//15
                        TempExcelBuffer.AddColumn("Sales Header"."Payment Term Change To", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//16
                        TempExcelBuffer.AddColumn("Sales Header"."Customer Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//17
                        TempExcelBuffer.AddColumn("Sales Header"."RFD", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//18
                        TempExcelBuffer.AddColumn("Sales Header"."Order Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//19
                        TempExcelBuffer.AddColumn("Sales Header"."CFD Status", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//20
                        TempExcelBuffer.AddColumn("Sales Header"."CFD Pending Reason", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//21
                        TempExcelBuffer.AddColumn("Sales Header"."Cust. P.O. Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//22
                        TempExcelBuffer.AddColumn("Sales Header"."Released Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//23
                        TempExcelBuffer.AddColumn("Sales Header"."Customer Order No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//24
                        TempExcelBuffer.AddColumn("Sales Header"."Old ODA No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//25
                        TempExcelBuffer.AddColumn("Sales Header"."Responsibility Center", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//26
                    END;

                end;
            }

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
                    field(PrintToExcel; PrintToExcel)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }
    }



    trigger OnInitReport()
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
    end;

    trigger OnPreReport()
    begin
        IF PrintToExcel then
            MakeHeader();
    end;

    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
            CreateExcelbook;
    end;

    procedure CreateExcelbook()
    begin
        TempExcelBuffer.CreateNewBook('Sales Header Report');
        TempExcelBuffer.WriteSheet('Sales Header Report', CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Sales Header Report');
        TempExcelBuffer.OpenExcel();
    end;

    var
        myInt: Integer;
        //Gst
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTrnasactionValue1: Record "Tax Transaction Value";
        GSTComponentCode: array[20] of Integer;
        Item1: Record Item;
        j: Integer;
        Taxper: Decimal;


        DetailedGSTEntryBuffer: Record "Detailed GST Ledger Entry";
        IGST_Perc: Decimal;
        IGST_Amt: Decimal;
        CGST_Perc: Decimal;
        CGST_Amt: Decimal;
        SGST_Perc: Decimal;
        SGST_Amt: Decimal;
        Total_Value: Decimal;





        TotalTaxAmount: Decimal;
        GrandTotal: Decimal;
        AmountInWords: Text[100];

        SalesCommentLine: Record "Sales Comment Line";
        RecComment: text[100];


        GSTComponentCodeHeader: array[20] of Code[10];
        GSTCompAmountHeader: array[20] of Decimal;
        GSTComponentCodeLine: array[20] of Code[10];
        GSTCompAmountLine: array[20] of Decimal;
        GSTCompPercentLine: array[20] of Decimal;

        TempExcelBuffer: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;

    local procedure MakeHeader()
    var
        myInt: Integer;
    begin
        // TempExcelBuffer.SetUseInfoSheet;  Don't know yet
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//1
        TempExcelBuffer.AddColumn('Sell-to Customer No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//2
        TempExcelBuffer.AddColumn('No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//3
        TempExcelBuffer.AddColumn('Bill-to Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//4
        TempExcelBuffer.AddColumn('Order Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//5
        TempExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//6
        TempExcelBuffer.AddColumn('Payment Terms Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//7
        TempExcelBuffer.AddColumn('Salesperson Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//8
        TempExcelBuffer.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//0
        TempExcelBuffer.AddColumn('Amount Including VAT', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//9
        TempExcelBuffer.AddColumn('Gen. Bus. Posting Group', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//10
        TempExcelBuffer.AddColumn('Payment Method Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//11
        TempExcelBuffer.AddColumn('Shipping Agent Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//12
        TempExcelBuffer.AddColumn('Status', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//13
        TempExcelBuffer.AddColumn('Doc. No. Occurrence', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//14
        TempExcelBuffer.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//15
        TempExcelBuffer.AddColumn('Payment Term_Change_To', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//16
        TempExcelBuffer.AddColumn('Customer Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//17
        TempExcelBuffer.AddColumn('RFD', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//18
        TempExcelBuffer.AddColumn('Order Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//19
        TempExcelBuffer.AddColumn('CFD Status', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//20
        TempExcelBuffer.AddColumn('CFD Pending Reason', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//21
        TempExcelBuffer.AddColumn('Cust P.O. Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//22
        TempExcelBuffer.AddColumn('Released_Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//23
        TempExcelBuffer.AddColumn('Customer Order No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//24
        TempExcelBuffer.AddColumn('Old ODA No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//25
        TempExcelBuffer.AddColumn('Responsibility Center', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//26
    end;




    local procedure GetGSTAmountsLine(SalesLine: Record "Sales Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        recSalesLine: record "Sales Line";
    begin
        if not GSTSetup.Get() then
            exit;

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", SalesLine."Document Type");
        recSalesLine.SetRange("Document No.", SalesLine."Document No.");
        recSalesLine.SetRange("Line No.", SalesLine."Line No.");
        if recSalesLine.FindSet() then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", SalesLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then begin
                case TaxTransactionValue."Value ID" of
                    6:
                        begin
                            GSTCompPercentLine[1] := TaxTransactionValue.Percent;
                            GSTCompAmountLine[1] := TaxTransactionValue.Amount;
                            if GSTComponentCodeLine[1] = '' then
                                GSTComponentCodeLine[1] := 'SGST';
                        end;
                    2:
                        begin
                            GSTCompPercentLine[2] := TaxTransactionValue.Percent;
                            GSTCompAmountLine[2] := TaxTransactionValue.Amount;
                            if GSTComponentCodeLine[2] = '' then
                                GSTComponentCodeLine[2] := 'CGST';
                        end;
                    3:
                        begin
                            GSTCompPercentLine[3] := TaxTransactionValue.Percent;
                            GSTCompAmountLine[3] := TaxTransactionValue.Amount;
                            if GSTComponentCodeLine[3] = '' then
                                GSTComponentCodeLine[3] := 'IGST';
                        end;
                    4:
                        begin
                            GSTCompPercentLine[4] := TaxTransactionValue.Percent;
                            GSTCompAmountLine[4] := TaxTransactionValue.Amount;
                            if GSTComponentCodeLine[4] = '' then
                                GSTComponentCodeLine[4] := 'CESS';
                        end;
                end;
            end;
        end;
    end;


}