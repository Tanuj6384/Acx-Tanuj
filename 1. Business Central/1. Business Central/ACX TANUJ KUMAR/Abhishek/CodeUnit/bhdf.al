codeunit 70000 jisdf
{
    trigger OnRun()
    begin
        
    end;

    procedure ImportPurchaseInvoice()
    var
        FileNameSource: Text[1024];
        FSource: File;
        Content: Code[1024];
        LineCnt: Integer;
        PurchOrdNo: Code[20];
        Dlg: Dialog;
        recTextFileInfo: Record "50006";
        PONo: Code[20];
        recPurchLine: Record "39";
        InvNo: Code[20];
        Shptno: Code[20];
        recTextFileInfo1: Record "50006";
        Cnt: Integer;
        InclDate: Date;
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        SalesOrderLine: Record "37";
        SalesHeader: Record "36";
        XShipNo: Code[20];
        XInvNo: Code[20];
    begin
        recTextFileInfo1.DeleteAll();
        FileNameSource := 'E:\INV_GB01_11878133_2215255302_20240628_153451 1.txt';

        IF FileNameSource = '' THEN
            EXIT;

        Cnt := 0;
        recTextFileInfo1.RESET;
        recTextFileInfo1.SETCURRENTKEY("Entry No.");
        IF recTextFileInfo1.FINDLAST THEN
            Cnt := recTextFileInfo1."Entry No.";

        IF GUIALLOWED THEN
            Dlg.OPEN('Progress \' + '@1@@@@@@@@@@@@@@@@@@@@@@');
        FSource.OPEN(FileNameSource);
        FSource.TEXTMODE(TRUE);
        IF FSource.LEN > 0 THEN
            REPEAT

                FSource.READ(Content);

                LineCnt += 1;

                IF COPYSTR(Content, 1, 2) = 'FH' THEN BEGIN
                    EVALUATE(DD, COPYSTR(Content, 6, 2));
                    EVALUATE(MM, COPYSTR(Content, 9, 2));
                    EVALUATE(YYYY, COPYSTR(Content, 12, 4));

                    InclDate := DMY2DATE(DD, MM, YYYY);
                END;
                // ERROR('%1',InclDate);
                IF GUIALLOWED THEN
                    Dlg.UPDATE(1, ROUND(FSource.POS * 10000 / FSource.LEN, 1));
                IF LineCnt > 1 THEN BEGIN                              // We are skipping the first line of the text file.
                    IF COPYSTR(Content, 1, 2) = 'IV' THEN BEGIN
                        Shptno := COPYSTR(Content, 3, 6);
                        InvNo := COPYSTR(Content, 12, 9);
                        XShipNo := COPYSTR(Content, 3, 10);
                        XInvNo := COPYSTR(Content, 13, 10);
                    END;

                    IF COPYSTR(Content, 1, 2) = 'OI' THEN BEGIN          // it means that it is a New Item

                        recTextFileInfo.INIT;

                        // PurchOrdNo := COPYSTR(Content,3,9);
                        PurchOrdNo := COPYSTR(Content, 3, 18);

                        recTextFileInfo."Document Type" := recTextFileInfo."Document Type"::Order;
                        recTextFileInfo."P.O. No." := PurchOrdNo;
                        IF COPYSTR(Content, 1, 3) = 'OIX' THEN
                            recTextFileInfo."Invoice No." := XInvNo
                        ELSE
                            recTextFileInfo."Invoice No." := InvNo;
                        recTextFileInfo."Item No." := COPYSTR(Content, 39, 8);
                        IF COPYSTR(Content, 1, 3) = 'OIX' THEN
                            recTextFileInfo."Shipment No. from UK" := XShipNo
                        ELSE
                            recTextFileInfo."Shipment No. from UK" := Shptno;

                        EVALUATE(recTextFileInfo.Quantity, COPYSTR(Content, 62, 12));
                        IF EVALUATE(recTextFileInfo."Line No.", COPYSTR(Content, 32, 3)) THEN
                            recTextFileInfo."Line No." := recTextFileInfo."Line No." * 10000
                        ELSE
                            recTextFileInfo."Line No." := 0;


                        EVALUATE(recTextFileInfo."Unit of Measure", COPYSTR(Content, 75, 6));
                        EVALUATE(recTextFileInfo."Unit Price", COPYSTR(Content, 81, 12));
                        recTextFileInfo."Line Value" := recTextFileInfo.Quantity * recTextFileInfo."Unit Price";
                        recTextFileInfo."Include Date" := InclDate;
                        recTextFileInfo."HSN\SAC Code" := COPYSTR(Content, 136, 8); //<<Dd
                        PONo := PurchOrdNo;

                        // recPurchLine.SETFILTER("Line No.",'%1',recTextFileInfo."Line No.");

                        Cnt += 1;
                        recTextFileInfo."Entry No." := Cnt;
                        recTextFileInfo."Date And Time" := CURRENTDATETIME;
                        IF recTextFileInfo."Date And Time" <> 0DT THEN
                            recTextFileInfo."Filter Date" := DT2DATE(recTextFileInfo."Date And Time");    //18/08/2017

                        recTextFileInfo."User Id" := USERID;
                        recTextFileInfo.INSERT;
                        
                    END;
                END;
            UNTIL FSource.POS = FSource.LEN;
        FSource.CLOSE;
        IF GUIALLOWED THEN
            Dlg.CLOSE;
        //MESSAGE('Data has been inserted successfully');
    end;
    
    var
        myInt: Integer;
}