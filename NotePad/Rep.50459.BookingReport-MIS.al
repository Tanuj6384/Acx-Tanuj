report 50470 "BookingReport-MISTK"
{
    // //IF "No." <> '105102' THEN
    //   // CurrReport.SKIP;
    //  line item are skipped when quatity and invoiced qty is equal(27-04-16,by Sourav, pricing)
    //  DefaultLayout = RDLC;
    // RDLCLayout = 'BookingReportOPS.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Booking Report-MISTk';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING(Status)
                                WHERE("Document Type" = FILTER(Order));
            RequestFilterFields = "Released Date", "Shortcut Dimension 1 Code", "Salesperson Code", "Order Type", Status;

            dataitem("Sales Line"; "Sales Line")
            {
                CalcFields = "Reserved Quantity";
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                     WHERE(Type = FILTER(Item),
                                            "No." = filter('<>'));

                RequestFilterFields = "No.";
                dataitem(DataItem1000000022; "Text File Info")
                {
                    DataItemLink = "Sales Order No." = FIELD("Document No."),
                                   "No." = FIELD("No.");

                    trigger OnAfterGetRecord()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        CLEAR(credittime1);
                        CLEAR(pricingtime1);
                        CLEAR(bookingtime1);
                        CLEAR(releasingtime1);
                        PostedApprovalEntry1.RESET;
                        PostedApprovalEntry1.SETRANGE("Document No.", SaleInvHeaRec."No.");
                        IF PostedApprovalEntry1.FINDFIRST THEN BEGIN
                            bookingtime1 := PostedApprovalEntry1."Date-Time Sent for Approval";
                            pricingtime1 := PostedApprovalEntry1."Pricing App Datetime";
                            releasingtime1 := PostedApprovalEntry1."Last Date-Time Modified";
                            credittime1 := PostedApprovalEntry1."Credit Control App Datetime";
                            finheadapp1 := PostedApprovalEntry1."Finance Head  App Datetime"; //jitender 25-08-22
                                                                                              //  MESSAGE('%1\%2\%3',bookingtime1,pricingtime1,credittime1);
                        END;



                        CLEAR(CutStatus);
                        CLEAR(RejComm);

                        //Jitender
                        CLEAR(RejComm);
                        SaleComment := '';
                        CLEAR(comt);
                        PostedApprovalCommentLine.RESET;
                        PostedApprovalCommentLine.SETRANGE("Table ID", 112);
                        PostedApprovalCommentLine.SETRANGE("Document No.", SaleInvHeaRec."No.");
                        IF PostedApprovalCommentLine.FIND('-') THEN BEGIN
                            RejComm := PostedApprovalCommentLine."Reject Commnet";
                            comt := PostedApprovalCommentLine.Comment;
                        END;
                        ///jitender

                        CLEAR(CustPODt);
                        IF NOT SalesHeader.GET(SalesHeader."Document Type"::Order, SaleInvHeaRec."Order No.") THEN BEGIN
                            CustPODt := SaleInvHeaRec."Cust. P.O. Date";
                            invODAdate := SaleInvHeaRec."LR/RR Date";
                            //invreleased=:SaleInvHeaRec."Released Date";
                            SaleComment := '';
                        END ELSE
                            CurrReport.SKIP;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    //shri
                    CLEAR(UKinvdate);
                    CLEAR(UKinvnum);
                    CLEAR(shipment_no);
                    CLEAR(includedate);

                    mrn.RESET;
                    //mrn.SETRANGE("Table ID",36);
                    mrn.SETRANGE(mrn."Document Type", mrn."Document Type"::Order);
                    mrn.SETRANGE("Sales Order No.", "Document No.");
                    mrn.SETRANGE("Item No.", "No.");
                    IF mrn.FINDLAST THEN BEGIN
                        UKinvdate := mrn."Date And Time";
                        UKinvnum := mrn."Invoice No.";
                        shipment_no := mrn."Shipment No. from UK";
                        includedate := mrn."Include Date";
                    END;

                    //shri

                    InvDate := 0D;
                    Invtqy := 0;
                    InvNo := '';
                    SaleInvHeaRec.RESET;
                    SaleInvHeaRec.SETRANGE(SaleInvHeaRec."Order No.", "Sales Line"."Document No.");
                    IF SaleInvHeaRec.FIND('-') THEN begin
                        SaleInvLineRec.RESET;
                        SaleInvLineRec.SETRANGE(SaleInvLineRec."Document No.", SaleInvHeaRec."No.");
                        SaleInvLineRec.SETRANGE(SaleInvLineRec."Posting Date", SaleInvHeaRec."Posting Date");
                        SaleInvLineRec.SETRANGE(SaleInvLineRec."No.", "Sales Header"."No.");
                        IF SaleInvLineRec.FIND('-') THEN BEGIN
                            InvNo := SaleInvLineRec."Document No.";
                            InvDate := SaleInvLineRec."Posting Date";
                            Invtqy := SaleInvLineRec.Quantity;
                        END;
                    end;
                    IF Invtqy <= 0 THEN BEGIN
                        InvNo := '';
                        InvDate := 0D;
                    END;

                    CLEAR(spcd);
                    CLEAR(brnch);
                    CLEAR(UnitPrice);
                    IF Quantity <> 0 THEN BEGIN
                        UnitPrice := ("Line Amount" / Quantity);
                        spcd := "sales Header"."Salesperson Code";
                        brnch := "Shortcut Dimension 1 Code";
                    END;
                    CLEAR(PendQty);
                    CLEAR(QtyRec);
                    CLEAR(Mrndate);
                    //PurchReceHead.RESET;
                    // PurchReceHead.SETRANGE(PurchReceHead."Order No.","Purchase Order No.");
                    // IF PurchReceHead.FINDFIRST THEN
                    /*     PurchaseRecLine.RESET;
                         PurchaseRecLine.SETRANGE(PurchaseRecLine."No.","No.");
                         PurchaseRecLine.SETRANGE(PurchaseRecLine."S.O. No.","Document No.");
                           IF PurchaseRecLine.FIND('-') THEN BEGIN
                           Mrndate :=PurchaseRecLine."Posting Date";
                           QtyRec:=PurchaseRecLine."Qty. Rcd. Not Invoiced";
                    
                          END;
                    
                        IF (QtyRec =0) AND (Invtqy =0) THEN BEGIN
                          StatusNew := 'Pending';
                        END ELSE IF (PendQty =0) AND (Quantity = Invtqy)  THEN BEGIN
                          StatusNew := 'Invoiced';
                        END ELSE IF (Invtqy =0) AND (Quantity = QtyRec) THEN BEGIN
                           StatusNew := 'Received';
                         END ELSE IF (Invtqy =0) AND (Quantity <> QtyRec) THEN BEGIN
                           StatusNew := 'Partial Received';
                          END;   */
                    PendQty := 0;
                    finalamount := 0;
                    PendQty := "Sales Line".quantity - ("Sales Line"."Quantity Invoiced" + "Sales Line"."Qty. to Ship");
                    if "Sales Line".quantity <> 0 then begin
                        finalamount := PendQty * "Sales Line"."Line Amount" / "Sales Line".quantity
                    end;

                    ExporttoExcel := TRUE;
                    IF ExporttoExcel THEN BEGIN
                        ExcelBuf.NewRow;
                        ExcelBuf.AddColumn("Sales Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', 2); //1
                        ExcelBuf.AddColumn("Sales Line"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//2
                        ExcelBuf.AddColumn("Sales Header"."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//3
                        ExcelBuf.AddColumn("Sales Header"."Responsibility Center", FALSE, '', FALSE, FALSE, FALSE, '', 1); //4                          //
                        ExcelBuf.AddColumn("Sales Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//5
                        ExcelBuf.AddColumn("Sales Header"."Bill-to Name", FALSE, '', FALSE, FALSE, FALSE, '', 1); //6
                        ExcelBuf.AddColumn("Sales Header"."Released Date", FALSE, '', FALSE, FALSE, FALSE, '', 2); //7
                        ExcelBuf.AddColumn(includedate, FALSE, '', FALSE, FALSE, FALSE, '', 2);  //Invlude Date //8
                        ExcelBuf.AddColumn("Sales Header"."Order Type", FALSE, '', FALSE, FALSE, FALSE, '', 1);//9
                        TsetFileRec.RESET;
                        TsetFileRec.SETRANGE("Sales Order No.", "Sales Line"."Document No.");
                        TsetFileRec.SETRANGE("No.", "Sales Line"."No.");
                        IF NOT TsetFileRec.FINDLAST THEN
                            CLEAR(TsetFileRec);

                        ExcelBuf.AddColumn(TsetFileRec.Remarks, FALSE, '', FALSE, FALSE, FALSE, '', 1); //Remarks for rejection //10
                        ExcelBuf.AddColumn(TsetFileRec."UK P.O. No.", FALSE, '', FALSE, FALSE, FALSE, '', 1); //UK PO Number //11
                        ExcelBuf.AddColumn("Sales Expected Dispatch Date", FALSE, '', FALSE, FALSE, FALSE, '', 2);//12
                        IF "Sales Back Order Dispatch Date" = 0D THEN
                            ExcelBuf.AddColumn("Sales Expected Dispatch Date", FALSE, '', FALSE, FALSE, FALSE, '', 2)//13
                        ELSE
                            ExcelBuf.AddColumn("Sales Back Order Dispatch Date", FALSE, '', FALSE, FALSE, FALSE, '', 2);//13

                        ExcelBuf.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//14
                        ExcelBuf.AddColumn(Quantity, FALSE, '', FALSE, FALSE, FALSE, '', 0);//15
                        ExcelBuf.AddColumn("Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', 1);//16
                        ExcelBuf.AddColumn("Sales Line"."Line Amount" / "Sales Line".quantity, FALSE, '', FALSE, FALSE, FALSE, '', 1);//17
                    end;
                    // Acx-Tanuj 
                    ExcelBuf.AddColumn("Unit Price" - ("Sales Line"."Line Amount" / "Sales Line".quantity), FALSE, '', FALSE, FALSE, FALSE, '', 0);//Discount amount //18
                    ExcelBuf.AddColumn(("Unit Price" - ("Sales Line"."Line Amount" / "Sales Line".Quantity)) * "Quantity", FALSE, '', FALSE, FALSE, FALSE, '', 0);//Total Discount amount //19
                    ExcelBuf.AddColumn("Landed Cost", FALSE, '', FALSE, FALSE, FALSE, '', 0);////Landed cost //20
                    ExcelBuf.AddColumn("Landed Cost" * Quantity, FALSE, '', FALSE, FALSE, FALSE, '', 0);////Total Landed Cost //21

                    ExcelBuf.AddColumn("Sales Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', 0);//22
                    ExcelBuf.AddColumn("Sales Line"."Quantity Invoiced", FALSE, '', FALSE, FALSE, FALSE, '', 0);//23
                    ExcelBuf.AddColumn("Sales Line"."Qty. to Ship", FALSE, '', FALSE, FALSE, FALSE, '', 0);//24

                    ExcelBuf.AddColumn("Sales Line"."Quantity" - ("Sales Line"."Quantity Invoiced" + "Sales Line"."Qty. to Ship"), FALSE, '', FALSE, FALSE, FALSE, '', 0);//25
                    ExcelBuf.AddColumn(finalamount, FALSE, '', FALSE, FALSE, FALSE, '', 0);//26

                    IF "Quantity Invoiced" = 0 THEN BEGIN
                        ExcelBuf.AddColumn(FORMAT('Pending'), FALSE, '', FALSE, FALSE, FALSE, '', 1);//27
                    END ELSE BEGIN
                        IF "Sales Line"."Quantity Invoiced" = Quantity THEN
                            ExcelBuf.AddColumn(FORMAT('Invoiced'), FALSE, '', FALSE, FALSE, FALSE, '', 1)//27
                        ELSE
                            ExcelBuf.AddColumn(FORMAT('Partial Invoiced'), FALSE, '', FALSE, FALSE, FALSE, '', 1);//27
                    END;

                    ExcelBuf.AddColumn("Sales Header"."Customer Order No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//28
                    ExcelBuf.AddColumn("Sales Line"."Qty. to Ship" * ("Sales Line"."Line Amount" / "Sales Line".quantity), FALSE, '', FALSE, FALSE, FALSE, '', 0);//29
                    ExcelBuf.AddColumn(Remarks, FALSE, '', FALSE, FALSE, FALSE, '', 0);//30





                END;


                trigger OnPreDataItem()
                begin
                    CurrReport.CREATETOTALS(AMTLN);
                    CLEAR(OrDERNO);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(CutStatus);
                /*
                IF "Released Date Time" > 1400T THEN
                   CutStatus := 'After Cutoff'
                ELSE
                  CutStatus := 'Before Cutoff';
                 */
                CLEAR(RejComm);
                SaleComment := '';
                CLEAR(comt);
                SaleCommentRec.RESET;
                SaleCommentRec.SETRANGE("Table ID", 36);
                SaleCommentRec.SETRANGE("Document Type", SaleCommentRec."Document Type"::Order);
                SaleCommentRec.SETRANGE("Document No.", "No.");
                IF SaleCommentRec.FINDLAST THEN BEGIN
                    RejComm := SaleCommentRec."Reject Commnet";
                    comt := SaleCommentRec.Comment;

                END;

                SaleComment := '';
                Salescommentline.RESET;
                //Salescommentline.SETRANGE("Table ID",36);
                Salescommentline.SETRANGE("Document Type", Salescommentline."Document Type"::Order);
                Salescommentline.SETRANGE("No.", "No.");
                IF Salescommentline.FINDLAST THEN BEGIN
                    SaleComment := Salescommentline.Comment;
                END;
                CLEAR(credittime);
                CLEAR(pricingtime);
                CLEAR(bookingtime);
                CLEAR(releasingtime);
                approvalentry.RESET;
                approvalentry.SETRANGE("Document Type", approvalentry."Document Type"::Order);
                approvalentry.SETRANGE("Document No.", "No.");
                IF approvalentry.FINDLAST THEN BEGIN
                    bookingtime := approvalentry."Date-Time Sent for Approval";
                    pricingtime := approvalentry."Pricing App Datetime";
                    //  releasingtime := approvalentry."Last Date-Time Modified";
                    credittime := approvalentry."Credit Control App Datetime";
                    finheadapp := approvalentry."Finance Head  App Datetime";
                END;
                CLEAR(CustPODt);
                CustPODt := "Cust. P.O. Date";
                releasingtime := "Released Date Time";
                odarecdate := "Sales Header"."LR/RR Date";
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(LNLC, LNMRP, AMTLN);
            end;
        }
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Order Date";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = where(Quantity = filter('<>0'));


                trigger OnAfterGetRecord()
                begin
                    InvDate := 0D;
                    Invtqy := 0;
                    InvNo := '';
                    InvNo := "Sales Invoice Line"."Document No.";
                    InvDate := "Sales Invoice Line"."Posting Date";
                    Invtqy := "Sales Invoice Line".Quantity;
                    CLEAR(spcd);
                    CLEAR(brnch);
                    CLEAR(UnitPrice);
                    IF "Sales Invoice Line".Quantity <> 0 THEN BEGIN
                        UnitPrice := ("Sales Invoice Line"."Line Amount" / "Sales Invoice Line".Quantity);
                        spcd := "Sales Invoice Header"."Salesperson Code";
                        brnch := "Sales Invoice Header"."Shortcut Dimension 1 Code";
                    END;
                    CLEAR(PendQty);
                    CLEAR(QtyRec);
                    CLEAR(Mrndate);
                    StatusNew := 'Invoiced';

                    //ACXLK
                    TsetFileRec.RESET;
                    TsetFileRec.SETRANGE("Sales Order No.", "Sales Invoice Header"."Order No.");
                    IF NOT TsetFileRec.FINDLAST THEN
                        CLEAR(TsetFileRec);
                    CLEAR(UKinvdate);
                    CLEAR(UKinvnum);
                    CLEAR(shipment_no);
                    CLEAR(includedate);

                    mrn.RESET;
                    mrn.SETRANGE(mrn."Document Type", mrn."Document Type"::Order);
                    mrn.SETRANGE("Sales Order No.", "Sales Invoice Line"."Order No.");
                    mrn.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                    IF mrn.FINDLAST THEN BEGIN
                        UKinvdate := mrn."Date And Time";
                        UKinvnum := mrn."Invoice No.";
                        shipment_no := mrn."Shipment No. from UK";
                        includedate := mrn."Include Date";
                    END;

                    ExporttoExcel := TRUE;
                    IF ExporttoExcel THEN BEGIN
                        //Acx-Tanuj 
                        ExcelBuf.NewRow;
                        ExcelBuf.AddColumn("Sales Invoice Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', 2);//1
                        ExcelBuf.AddColumn("Sales Invoice Header"."Order No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//2
                        ExcelBuf.AddColumn("Sales Invoice Header"."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', 1);//3
                        ExcelBuf.AddColumn("Sales Invoice Header"."Responsibility Center", FALSE, '', FALSE, FALSE, FALSE, '', 1);//4
                        ExcelBuf.AddColumn("Sales Invoice Line"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//5
                        ExcelBuf.AddColumn("Sales Invoice Header"."Bill-to Name", FALSE, '', FALSE, FALSE, FALSE, '', 1);//6
                        ExcelBuf.AddColumn("Sales Invoice Header"."Released Date", FALSE, '', FALSE, FALSE, FALSE, '', 2);//7
                        ExcelBuf.AddColumn(includedate, FALSE, '', FALSE, FALSE, FALSE, '', 2);  //Invlude Date //8
                        ExcelBuf.AddColumn(FORMAT("Sales Invoice Header"."Order Type"), FALSE, '', FALSE, FALSE, FALSE, '', 1);//9
                        ExcelBuf.AddColumn(TsetFileRec.Remarks, FALSE, '', FALSE, FALSE, FALSE, '', 1); //Remarks for rejection //10

                        ExcelBuf.AddColumn('Uk po number', FALSE, '', FALSE, FALSE, FALSE, '', 2);//11
                        ExcelBuf.AddColumn('expected dis date', FALSE, '', FALSE, FALSE, FALSE, '', 2);//12
                        ExcelBuf.AddColumn(' Back Order date', FALSE, '', FALSE, FALSE, FALSE, '', 2);//13

                        ExcelBuf.AddColumn("Sales Invoice Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);  //14
                        ExcelBuf.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', 0);//15
                        ExcelBuf.AddColumn("Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', 1);//16

                        if "Sales Invoice Line".Quantity <> 0 then begin
                            ExcelBuf.AddColumn("Sales Invoice Line"."Line Amount" / "Sales Invoice Line"."Quantity", FALSE, '', FALSE, FALSE, FALSE, '', 1); //17
                        end else begin
                            ExcelBuf.AddColumn('0', FALSE, '', FALSE, FALSE, FALSE, '', 1); //17

                        end;
                        if Quantity <> 0 then begin
                            ExcelBuf.AddColumn("Unit Price" - ("Sales Invoice Line"."Line Amount" / "Sales Invoice Line".quantity), FALSE, '', FALSE, FALSE, FALSE, '', 0);//Discount amount //18
                        end;
                        if Quantity <> 0 then begin
                            ExcelBuf.AddColumn(("Unit Price" - ("Sales Invoice Line"."Line Amount" / "Sales Invoice Line".Quantity)) * "Quantity", FALSE, '', FALSE, FALSE, FALSE, '', 0);//Total Discount amount //19
                        end;
                        ExcelBuf.AddColumn("Landed Cost", FALSE, '', FALSE, FALSE, FALSE, '', 0);//20
                        ExcelBuf.AddColumn("Landed Cost" * Quantity, FALSE, '', FALSE, FALSE, FALSE, '', 0);//21
                        ExcelBuf.AddColumn("Sales Invoice Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', 0);//22
                        ExcelBuf.AddColumn("Sales Invoice Line"."Quantity", FALSE, '', FALSE, FALSE, FALSE, '', 0);//23
                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', 0);//24
                        ExcelBuf.AddColumn('0', FALSE, '', FALSE, FALSE, FALSE, '', 0);//25
                        ExcelBuf.AddColumn("Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', 0);//26
                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', 1);//27
                        ExcelBuf.AddColumn("Sales Invoice Header"."Customer Order No.", FALSE, '', FALSE, FALSE, FALSE, '', 1);//28
                        ExcelBuf.AddColumn('0', FALSE, '', FALSE, FALSE, FALSE, '', 0);//29
                        ExcelBuf.AddColumn(Remarks, FALSE, '', FALSE, FALSE, FALSE, '', 0);//30

                        ExcelBuf.AddColumn("Sales Invoice Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', 0);//31
                        ExcelBuf.AddColumn("Sales Invoice Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', 0);//32
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            var
            // SalesHeader: Record "Sales Header";
            begin
                CLEAR(credittime1);
                CLEAR(pricingtime1);
                CLEAR(bookingtime1);
                CLEAR(releasingtime1);
                PostedApprovalEntry1.RESET;
                PostedApprovalEntry1.SETRANGE("Table ID", 112);
                PostedApprovalEntry1.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                IF PostedApprovalEntry1.FINDLAST THEN BEGIN
                    bookingtime1 := PostedApprovalEntry1."Date-Time Sent for Approval";
                    pricingtime1 := PostedApprovalEntry1."Pricing App Datetime";
                    releasingtime1 := PostedApprovalEntry1."Last Date-Time Modified";
                    credittime1 := PostedApprovalEntry1."Credit Control App Datetime";
                    finheadapp1 := PostedApprovalEntry1."Finance Head  App Datetime"; //jitender 25-08-22
                                                                                      //  MESSAGE('%1\%2\%3',bookingtime1,pricingtime1,credittime1);
                END;



                CLEAR(CutStatus);
                CLEAR(RejComm);

                //Jitender
                CLEAR(RejComm);
                SaleComment := '';
                CLEAR(comt);
                PostedApprovalCommentLine.RESET;
                PostedApprovalCommentLine.SETRANGE("Table ID", 112);
                PostedApprovalCommentLine.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                IF PostedApprovalCommentLine.FINDLAST THEN BEGIN
                    RejComm := PostedApprovalCommentLine."Reject Commnet";
                    comt := PostedApprovalCommentLine.Comment;
                END;
                ///jitender

                CLEAR(CustPODt);
                IF NOT "Sales Header".GET("Sales Header"."Document Type"::Order, "Sales Invoice Header"."Order No.") THEN BEGIN
                    CustPODt := "Sales Invoice Header"."Cust. P.O. Date";
                    invODAdate := "Sales Invoice Header"."LR/RR Date";
                    // invreleased=:SaleInvHeaRec."Released Date";
                    SaleComment := '';
                END ELSE
                    CurrReport.SKIP;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Print to Excel")
                {
                    field("Export To Excel"; ExporttoExcel)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //Details := FALSE;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        //CLEAR(Details);
    end;

    trigger OnPostReport()
    begin
        IF ExporttoExcel THEN
            ExcelBuf.CreateNewBook('Booking Report-MIS');
        ExcelBuf.WriteSheet('Booking Report-MIS', CompanyName(), UserId());
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename('Booking Report-MIS');
        ExcelBuf.OpenExcel();
    end;

    trigger OnPreReport()
    begin
        ExporttoExcel := TRUE;
        IF ExporttoExcel THEN BEGIN
            //MakeExcelInfo;
            ExcelBuf.DELETEALL;
            MakeExcelDataHeader;
        END;
    end;

    var
        LNLC: Decimal;
        LNLC1: Decimal;
        LNMRP: Decimal;
        LNMRP1: Decimal;
        PF: Record "Price List";
        AMTLN: Decimal;
        la1: Decimal;
        a: Decimal;
        b: Decimal;
        c: Decimal;
        e: Decimal;
        f: Decimal;
        g: Decimal;
        text001: Label '***';
        rmrk: Text[10];
        ItemRec: Record "Item";
        brnch: Code[10];
        spcd: Code[10];
        pcode: Code[10];
        oddt: Date;
        stn: Text[50];
        stc: Text[30];
        Ulc: Decimal;
        Ulc1: Decimal;
        Umrp: Decimal;
        Manufacturer: Record "Manufacturer";
        Umrp1: Decimal;
        Details: Boolean;
        CustPO: Text[50];
        CustPODt: Date;
        Pterm: Code[10];
        FCde: Code[10];
        ODA: Code[20];
        Document_NoCaptionLbl: Label 'Document No';
        Line_AmountCaptionLbl: Label 'Line Amount';
        SPCaptionLbl: Label 'SP';
        BranchCaptionLbl: Label 'Branch';
        ODA_Release_DateCaptionLbl: Label 'ODA Release Date';
        Customer_NameCaptionLbl: Label 'Customer Name';
        LocationCaptionLbl: Label 'Location';
        Form_CodeCaptionLbl: Label 'Form Code';
        Payment_TermsCaptionLbl: Label 'Payment Terms';
        Customer_PO_DateCaptionLbl: Label 'Customer PO Date';
        Customer_PO_NoCaptionLbl: Label 'Customer PO No';
        Order_DateCaptionLbl: Label 'Order Date';
        Document_NoCaption_Control1000000008Lbl: Label 'Document No';
        Item_NoCaptionLbl: Label 'Item No';
        QuantityCaptionLbl: Label 'Quantity';
        Line_AmountCaption_Control1000000013Lbl: Label 'Line Amount';
        SPCaption_Control1000000040Lbl: Label 'SP';
        BranchCaption_Control1000000041Lbl: Label 'Branch';
        ODA_Release_DateCaption_Control1000000053Lbl: Label 'ODA Release Date';
        Customer_NameCaption_Control1000000054Lbl: Label 'Customer Name';
        LocationCaption_Control1000000055Lbl: Label 'Location';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        Form_CodeCaption_Control1000000073Lbl: Label 'Form Code';
        Customer_PO_DateCaption_Control1000000074Lbl: Label 'Customer PO Date';
        Customer_PO_NoCaption_Control1000000076Lbl: Label 'Customer PO No';
        Payment_TermsCaption_Control1000000078Lbl: Label 'Payment Terms';
        Total_for_OrderCaptionLbl: Label 'Total for Order';
        Posting_DateCaptionLbl: Label 'Posting Date';
        Document_NoCaption_Control1000000045Lbl: Label 'Document No';
        Line_AmountCaption_Control1000000051Lbl: Label 'Line Amount';
        SPCaption_Control1000000052Lbl: Label 'SP';
        BranchCaption_Control1000000056Lbl: Label 'Branch';
        Customer_NameCaption_Control1000000057Lbl: Label 'Customer Name';
        LocationCaption_Control1000000059Lbl: Label 'Location';
        Customer_PO_NoCaption_Control1000000096Lbl: Label 'Customer PO No';
        Customer_PO_DateCaption_Control1000000097Lbl: Label 'Customer PO Date';
        Payment_TermsCaption_Control1000000098Lbl: Label 'Payment Terms';
        Form_CodeCaption_Control1000000099Lbl: Label 'Form Code';
        ODA_NoCaptionLbl: Label 'ODA No';
        Order_DateCaption_Control1000000103Lbl: Label 'Order Date';
        Document_NoCaption_Control1000000061Lbl: Label 'Document No';
        Item_NoCaption_Control1000000062Lbl: Label 'Item No';
        QuantityCaption_Control1000000063Lbl: Label 'Quantity';
        Line_AmountCaption_Control1000000066Lbl: Label 'Line Amount';
        SPCaption_Control1000000067Lbl: Label 'SP';
        BranchCaption_Control1000000068Lbl: Label 'Branch';
        Posting_DateCaption_Control1000000070Lbl: Label 'Posting Date';
        Customer_NameCaption_Control1000000071Lbl: Label 'Customer Name';
        LocationCaption_Control1000000072Lbl: Label 'Location';
        Unit_PriceCaption_Control1000000075Lbl: Label 'Unit Price';
        Form_CodeCaption_Control1000000079Lbl: Label 'Form Code';
        Payment_TermsCaption_Control1000000080Lbl: Label 'Payment Terms';
        Customer_PO_DateCaption_Control1000000081Lbl: Label 'Customer PO Date';
        Customer_PO_NoCaption_Control1000000082Lbl: Label 'Customer PO No';
        ODA_NoCaption_Control1000000093Lbl: Label 'ODA No';
        Total_for_InvoiceCaptionLbl: Label 'Total for Invoice';
        Grand_TotalCaptionLbl: Label 'Grand Total';
        OrDERNO: Code[40];
        Status: Option Open,Released,"Pending Approval","Pending Prepayment",Cancel,Close,"Quote Close";
        SH3: Record "Sales Header";
        rdate: Date;
        spcd1: Code[10];
        pcode1: Code[10];
        oddt1: Date;
        stn1: Text[50];
        stc1: Text[50];
        CustPODt1: Date;
        Pterm1: Code[10];
        FCde1: Code[10];
        ODA1: Code[20];
        rdate1: Date;
        brnch1: Code[20];
        CustPO1: Text[50];
        ManfName: Text[50];
        ManfName1: Text[50];
        Mrp2: Decimal;
        CutStatus: Text[20];
        UnitPrice: Decimal;
        Ukinvno: Integer;
        PurchReceHead: Record "Purch. Rcpt. Header";
        Mrndate: Date;
        PurchaseRecLine: Record "Purch. Rcpt. Line";
        QtyRec: Integer;
        PendQty: Integer;
        StatusNew: Text;
        SaleCommentRec: Record "Approval Comment Line";
        SaleComment: Code[80];
        RejComm: Option " ","Low Margin","Credit Issue","Tax Structure","Stock No",Blocked,Misc;
        ExporttoExcel: Boolean;
        ExcelBuf: Record "Excel Buffer" temporary;
        SaleInvLineRec: Record "Sales Invoice Line";
        SaleInvHeaRec: Record "Sales Invoice Header";
        InvDate: Date;
        Invtqy: Integer;
        InvNo: Code[20];
        Salescommentline: Record "Sales Comment Line";
        Pendinv: Integer;
        comt: Text[100];
        approvalentry: Record "Approval Entry";
        credittime: DateTime;
        pricingtime: DateTime;
        releasingtime: DateTime;
        bookingtime: DateTime;
        reltime: DateTime;
        ptime: DateTime;
        PostedApprovalCommentLine: Record "Posted Approval Comment Line";
        odarecdate: Date;
        invODAdate: Date;
        invreleased: DateTime;
        PostedApprovalEntry: Record "Posted Approval Entry";
        mrn: Record "Purchase Inv File Info";
        UKinvnum: Code[10];
        UKinvdate: DateTime;
        PostedApprovalEntry1: Record "Posted Approval Entry";
        credittime1: DateTime;
        pricingtime1: DateTime;
        releasingtime1: DateTime;
        bookingtime1: DateTime;
        finheadapp: DateTime;
        finheadapp1: DateTime;
        shipment_no: Code[10];
        includedate: Date;
        TsetFileRec: Record "Text File Info";
        finalamount: Decimal;

    // //[Scope('Internal')]
    procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Order Date', FALSE, ' ', TRUE, FALSE, TRUE, ' ', ExcelBuf."Cell Type"::Text);//1
        ExcelBuf.AddColumn('Document No', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//2
        ExcelBuf.AddColumn('Salesperson', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//3
        ExcelBuf.AddColumn('PM Team', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//4
        ExcelBuf.AddColumn('Customer Code', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//5
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, TRUE, '', 1);//6
        ExcelBuf.AddColumn('Released Date', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//7
        ExcelBuf.AddColumn('Include Date', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//8
        ExcelBuf.AddColumn('Order Type', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//9
        ExcelBuf.AddColumn('UK Remarks', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//10
        ExcelBuf.AddColumn('UK PO Number', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//11
        ExcelBuf.AddColumn('Expected dispatch Date ', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//12
        ExcelBuf.AddColumn('Back Order Date ', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//13
        ExcelBuf.AddColumn('Item No', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//14
        ExcelBuf.AddColumn('Order Qty', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//15
        ExcelBuf.AddColumn('Web Prices', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//16
        ExcelBuf.AddColumn('Sales Price', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//17
        ExcelBuf.AddColumn('Discount Amount', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//18
        ExcelBuf.AddColumn('Total Discount Amount', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//19
        ExcelBuf.AddColumn('Landed Cost', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//20
        ExcelBuf.AddColumn('Total Landed Cost', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//21
        ExcelBuf.AddColumn('Line Amount', FALSE, ' ', TRUE, FALSE, TRUE, '', 1);//22
        ExcelBuf.AddColumn('Invoice Qty', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//23
        ExcelBuf.AddColumn('Received  Qty', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//24
        ExcelBuf.AddColumn('Pending Qty', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//25
        ExcelBuf.AddColumn('Final Amount', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//26
        ExcelBuf.AddColumn('Order Status', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//27
        ExcelBuf.AddColumn('PO Number', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//28
        ExcelBuf.AddColumn('RFD Amount', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//29
        ExcelBuf.AddColumn('Remarks', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//30
        ExcelBuf.AddColumn('Invoice No.', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//31
        ExcelBuf.AddColumn('Posting Date', FALSE, ' ', TRUE, FALSE, TRUE, ' ', 1);//32
    end;
}

