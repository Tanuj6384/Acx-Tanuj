pageextension 60029 "FixedAssetExt" extends "Fixed Asset Card"
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
            recFixedAssetHdr.Reset();
            recFixedAssetHdr.SetRange("No.", xRec."No.");
            if recFixedAssetHdr.FindFirst() then Rec.Validate("Gen. Journal Template Code", recFixedAssetHdr."Gen. Journal Template Code")
        END
        ELSE BEGIN
            recFixedAssetSetup.GET();
            Rec.Validate("Gen. Journal Template Code", recFixedAssetSetup."FA Template Temp");
            recFixedAssetSetup."FA Template Temp" := '';
            recFixedAssetSetup.MODIFY;
        END;
    end;
    //  end;

    var
        UserMgt: Codeunit "User Setup Management";
        recFixedAssetSetup: Record "FA Setup";
        recFixedAssetHdr: Record "Fixed Asset";
}
