pageextension 60025 "TransferOrderExt" extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //   if UserId<>'USHAYARN\ADMINISTRATOR' then begin

        IF xRec."No." <> '' THEN begin
            recTransferHeader.Reset();
            recTransferHeader.SetRange("No.", xRec."No.");
            if recTransferHeader.FindFirst() then Rec.Validate("Gen. Journal Template Code", recTransferHeader."Gen. Journal Template Code")
        END
        ELSE BEGIN
            recInventorySetup.GET();
            Rec.Validate("Gen. Journal Template Code", recInventorySetup."Transfer Template Temp");
            recInventorySetup."Transfer Template Temp" := '';
            recInventorySetup.MODIFY;
        END;
    end;
    //  end;

    var
        UserMgt: Codeunit "User Setup Management";
        recInventorySetup: Record "Inventory Setup";
        recTransferHeader: Record "Transfer Header";
}
