pageextension 60010 "purchaseinvoice Ext" extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
    }

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FILTERGROUP(0);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        recPurchaseHeader: Record "Purchase Header";
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;
        IF xRec."No." <> '' THEN begin
            recPurchaseHeader.Reset();
            recPurchaseHeader.SetRange("No.", xRec."No.");
            recPurchaseHeader.SetRange("Document Type", xRec."Document Type");
            if recPurchaseHeader.FindFirst() then Rec.Validate("Gen. Journal Template Code", recPurchaseHeader."Gen. Journal Template Code")
        END
        ELSE BEGIN
            recPurchSetup.GET();
            Rec.validate("Gen. Journal Template Code", recPurchSetup."Purch Template Temp");
            recPurchSetup."Purch Template Temp" := '';
            recPurchSetup.MODIFY;
        END;
        Rec.Validate("Shortcut Dimension 1 Code");
    end;

    var
        UserMgt: Codeunit "User Setup Management";
        recPurchSetup: Record "Purchases & Payables Setup";

    var
        myInt: Integer;


}