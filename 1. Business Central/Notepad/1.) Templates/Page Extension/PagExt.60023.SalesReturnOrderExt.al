pageextension 60023 "SalesReturnOrderExt" extends "Sales Return Order"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Location Code")
        modify("Shortcut Dimension 1 Code")
        {
            Editable = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = false;
        }
    }
    trigger OnOpenPage()
    begin
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FILTERGROUP(0);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        recSalesHeader: Record "Sales Header";
    begin
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

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You Can Not Delete Document');
    end;

    var
        UserMgt: Codeunit "User Setup Management";
        recSalesSetup: Record "Sales & Receivables Setup";
}