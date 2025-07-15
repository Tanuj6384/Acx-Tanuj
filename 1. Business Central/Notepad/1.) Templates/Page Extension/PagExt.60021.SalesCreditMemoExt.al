pageextension 60021 SalesCreditMemoExt extends "Sales Credit Memo"
{
    trigger OnOpenPage()
    begin
        //   if UserId<>'USHAYARN\ADMINISTRATOR' then begin

        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FILTERGROUP(0);
        END;
    end;
    // end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        recSalesHeader: Record "Sales Header";
    begin
        //     if UserId<>'USHAYARN\ADMINISTRATOR' then begin

        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
        IF xRec."No." <> '' THEN begin
            recSalesHeader.Reset();
            recSalesHeader.SetRange("No.", xRec."No.");
            recSalesHeader.SetRange("Document Type", xRec."Document Type");
            if recSalesHeader.FindFirst() then Rec.Validate("Gen. Journal Template Code", recSalesHeader."Gen. Journal Template Code")
        END
        ELSE BEGIN
            recSalesSetup.GET();
            Rec.Validate("Gen. Journal Template Code", recSalesSetup."Sales Template Temp");
            recSalesSetup."Sales Template Temp" := '';
            recSalesSetup.MODIFY;
        END;
    end;
    //  end;

    var
        UserMgt: Codeunit "User Setup Management";
        recSalesSetup: Record "Sales & Receivables Setup";


    var
        myInt: Integer;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You Can Not Delete Document');
    end;
}