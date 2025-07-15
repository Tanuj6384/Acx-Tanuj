pageextension 60035 OutwardGateEntryExt extends "Outward Gate Entry"
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
            recGateEntryHeader.Reset();
            recGateEntryHeader.SetRange("No.", xRec."No.");
            if recGateEntryHeader.FindFirst() then Rec.Validate("Gen. Journal Template Code", recGateEntryHeader."Gen. Journal Template Code")
        END
        ELSE BEGIN
            recInventorySetup.GET();
            Rec.Validate("Gen. Journal Template Code", recInventorySetup."Gate Entry Template Temp");
            recInventorySetup."Gate Entry Template Temp" := '';
            recInventorySetup.MODIFY;
        END;
    end;
    //  end;

    var
        UserMgt: Codeunit "User Setup Management";
        recInventorySetup: Record "Inventory Setup";
        recGateEntryHeader: Record "Gate Entry Header";
}
