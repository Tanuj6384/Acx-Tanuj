pageextension 60013 "Released Production Order" extends "Released Production Order"
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
            recProdOdr.Reset();
            recProdOdr.SetRange("No.", xRec."No.");
            if recProdOdr.FindFirst() then Rec.Validate("Gen. Journal Template Code", recProdOdr."Gen. Journal Template Code")
        END
        ELSE BEGIN
            ManufactureSetup.GET();
            Rec.Validate("Gen. Journal Template Code", ManufactureSetup."Prod. Template Temp");
            ManufactureSetup."Prod. Template Temp" := '';
            ManufactureSetup.MODIFY;
        END;
    end;
    //  end;

    var
        UserMgt: Codeunit "User Setup Management";
        ManufactureSetup: Record "Manufacturing Setup";
        recProdOdr: Record "Production Order";
}
