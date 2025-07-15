pageextension 60033 WarehouseReceiptsCardExt extends "Warehouse Receipt"
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
            recWareHouseHeader.Reset();
            recWareHouseHeader.SetRange("No.", xRec."No.");
            if recWareHouseHeader.FindFirst() then Rec.Validate("Gen. Journal Template Code", recWareHouseHeader."Gen. Journal Template Code")
        END
        ELSE BEGIN
            recWarehouseSetup.GET();
            Rec.Validate("Gen. Journal Template Code", recWarehouseSetup."Warehouse Receipt Template Temp");
            recWarehouseSetup."Warehouse Receipt Template Temp" := '';
            recWarehouseSetup.MODIFY;
        END;
    end;
    //  end;

    var
        UserMgt: Codeunit "User Setup Management";
        recWarehouseSetup: Record "Warehouse Setup";
        recWareHouseHeader: Record "Warehouse Receipt Header";
}
