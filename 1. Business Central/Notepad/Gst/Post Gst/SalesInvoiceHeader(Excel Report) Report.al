report 98453 SalesInvoiceHeader
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Sales Invoice Header Report.rdl';
    Caption = 'Sales Invoice Header Report';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Posting Date";

            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Released_Date; "Released Date") { }
            column(Order_Date; "Order Date") { }
            column(Customer_Order_No_; "Customer Order No.") { }
            column(Cust__P_O__Date; "Cust. P.O. Date") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Order_No_; "Order No.") { }
            column(Dispatch_Date; "Dispatch Date") { }
            column(Customer_Delivery_Date; "Customer Delivery Date") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Shipping_Agent_Code; "Shipping Agent Code") { }
            column(Package_Tracking_No_; "Package Tracking No.") { }
            column(Amount; Amount + TotalGstAmount) { }// + gst
            column(Delivery_status; "Delivery status") { }
            column(Pending_Reason; "Pending Reason") { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Tracking_Status; "Tracking Status") { }
            column(Old_ODA_No_; "Old ODA No.") { }
            column(Location_State_Code; "Location State Code") { }
            column(Service_Zone_Code; "Service Zone Code") { }
            column(Web_Order; "Web Order") { }
            column(Responsibility_Center; "Responsibility Center") { }

            // Gst Start
            trigger OnAfterGetRecord()
            begin
                IGST_Perc := 0;
                CGST_Perc := 0;
                SGST_Perc := 0;
                IGST_Amt := 0;
                CGST_Amt := 0;
                SGST_Amt := 0;
                DetailedGSTEntryBuffer.RESET;
                DetailedGSTEntryBuffer.SETRANGE("Transaction Type", DetailedGSTEntryBuffer."Transaction Type"::Sales);
                DetailedGSTEntryBuffer.SETRANGE("Document No.", "No.");
                DetailedGSTEntryBuffer.SETRANGE("No.", "No.");
                // DetailedGSTEntryBuffer.SETRANGE("Document Line No.", "Line No.");
                IF DetailedGSTEntryBuffer.FINDSET THEN
                    REPEAT
                        IF DetailedGSTEntryBuffer."GST Component Code" = 'IGST' THEN BEGIN
                            IGST_Amt := DetailedGSTEntryBuffer."GST Amount";
                            IGST_Perc := DetailedGSTEntryBuffer."GST %";
                            GSTPerTotal := 0;
                            GSTPerTotal := DetailedGSTEntryBuffer."GST %";
                        END;
                        IF DetailedGSTEntryBuffer."GST Component Code" = 'SGST' THEN BEGIN
                            SGST_Amt := DetailedGSTEntryBuffer."GST Amount";
                            SGST_Perc := DetailedGSTEntryBuffer."GST %";
                            GSTPerTotal := 0;
                            GSTPerTotal := DetailedGSTEntryBuffer."GST %" * 2;
                        END;
                        IF DetailedGSTEntryBuffer."GST Component Code" = 'CGST' THEN BEGIN
                            CGST_Amt := DetailedGSTEntryBuffer."GST Amount";
                            CGST_Perc := DetailedGSTEntryBuffer."GST %";
                        END;
                    UNTIL DetailedGSTEntryBuffer.NEXT = 0;

                TotalGstperc := IGST_Perc + SGST_Perc + CGST_Perc;
                TotalGstAmount := IGST_Amt + SGST_Amt + CGST_Amt;
                // Gst End
                MAmount := 0;
                // recCustLedgerEntry.Reset();
                // recCustLedgerEntry.SetRange("Customer No.", "Sales Invoice Header"."Sell-to Customer No.");
                // recCustLedgerEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
                // if recCustLedgerEntry.FindFirst() then begin
                //     MAmount := recCustLedgerEntry.Amount;
                // end;


                TAmount := 0;
                recSaleInvLine.Reset();
                recSaleInvLine.SetRange("Document No.", "No.");
                if recSaleInvLine.FindFirst() then begin

                    repeat
                        MAmount := 0;
                        MAmount := recSaleInvLine."Line Amount";
                        TAmount += MAmount;
                    until recSaleInvLine.Next() = 0;
                end;


                PrintToExcel := TRUE;
                IF PrintToExcel THEN BEGIN
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);//1
                    TempExcelBuffer.AddColumn("Bill-to Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//2
                    TempExcelBuffer.AddColumn("Released Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//3
                    TempExcelBuffer.AddColumn("Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//4
                    TempExcelBuffer.AddColumn("Customer Order No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//5
                    TempExcelBuffer.AddColumn("Cust. P.O. Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//6
                    TempExcelBuffer.AddColumn("Payment Terms Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//7
                    TempExcelBuffer.AddColumn("Order No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//8
                    TempExcelBuffer.AddColumn("Dispatch Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//9
                    TempExcelBuffer.AddColumn("Customer Delivery Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);//10
                    TempExcelBuffer.AddColumn("Ship-to City", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//11
                    TempExcelBuffer.AddColumn("Ship-to Post Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//12
                    TempExcelBuffer.AddColumn("Shipping Agent Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//13
                    TempExcelBuffer.AddColumn("Package Tracking No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//14
                    TempExcelBuffer.AddColumn(TAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);//15
                    TempExcelBuffer.AddColumn("Delivery status", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//16
                    TempExcelBuffer.AddColumn("Pending Reason", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//17
                    TempExcelBuffer.AddColumn("Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//18
                    TempExcelBuffer.AddColumn("Bill-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//19
                    TempExcelBuffer.AddColumn("Tracking Status", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//20
                    TempExcelBuffer.AddColumn("Old ODA No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//21
                    TempExcelBuffer.AddColumn("Location State Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//22
                    TempExcelBuffer.AddColumn("Service Zone Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//23
                    TempExcelBuffer.AddColumn("Web Order", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//24
                    TempExcelBuffer.AddColumn("Responsibility Center", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//25
                END;
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
                    field(PrintToExcel; PrintToExcel)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }
    }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(LayoutName)
    //             {
    //                 ApplicationArea = All;

    //             }
    //         }
    //     }
    // }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = Excel;
    //         LayoutFile = 'mySpreadsheet.xlsx';
    //     }
    // }
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
        TempExcelBuffer.CreateNewBook('Sales Invoice Header Report');
        TempExcelBuffer.WriteSheet('Sales Invoice Header Report', CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Sales Invoice Header Report');
        TempExcelBuffer.OpenExcel();
    end;

    var
        myInt: Integer;
        //Gst
        DetailedGSTEntryBuffer: Record "Detailed GST Ledger Entry";
        IGST_Perc: Decimal;
        IGST_Amt: Decimal;
        CGST_Perc: Decimal;

        CGST_Amt: Decimal;
        SGST_Perc: Decimal;
        SGST_Amt: Decimal;

        GSTPerTotal: Decimal;

        TotalGstAmount: Decimal;
        TotalGstperc: Decimal;

        TempExcelBuffer: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;

        MAmount: Decimal;
        TAmount: Decimal;
        recCustLedgerEntry: Record "Cust. Ledger Entry";

        recSaleInvLine: Record "Sales Invoice Line";

    local procedure MakeHeader()
    var
        myInt: Integer;
    begin
        // TempExcelBuffer.SetUseInfoSheet;  Don't know yet
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//1
        TempExcelBuffer.AddColumn('Bill-to Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//2
        TempExcelBuffer.AddColumn('Released Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//3
        TempExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//4
        TempExcelBuffer.AddColumn('Customer Order No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//5
        TempExcelBuffer.AddColumn('Cust. P.O. Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//6
        TempExcelBuffer.AddColumn('Payment Terms Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//7
        TempExcelBuffer.AddColumn('Order No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//8
        TempExcelBuffer.AddColumn('Dispatch Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//9
        TempExcelBuffer.AddColumn('Customer Delivery Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//10
        TempExcelBuffer.AddColumn('Ship-to City', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//11
        TempExcelBuffer.AddColumn('Ship-to Post Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//12
        TempExcelBuffer.AddColumn('Shipping Agent Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//13
        TempExcelBuffer.AddColumn('Package Tracking No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//14
        TempExcelBuffer.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//15
        TempExcelBuffer.AddColumn('Delivery status', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//16
        TempExcelBuffer.AddColumn('Pending Reason', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//17
        TempExcelBuffer.AddColumn('Salesperson Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//18
        TempExcelBuffer.AddColumn('Bill-to Customer No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//19
        TempExcelBuffer.AddColumn('Tracking Status', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//20
        TempExcelBuffer.AddColumn('Old ODA No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//21
        TempExcelBuffer.AddColumn('Location State Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//22
        TempExcelBuffer.AddColumn('Service Zone Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//23
        TempExcelBuffer.AddColumn('Web Order', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//24
        TempExcelBuffer.AddColumn('Responsibility Center', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//25
    end;

}
