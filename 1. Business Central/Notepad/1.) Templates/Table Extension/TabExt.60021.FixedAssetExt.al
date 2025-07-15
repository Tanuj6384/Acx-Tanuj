tableextension 60021 FixedAssetExt extends "Fixed Asset"

{
    fields
    {
        // Add changes to table fields here
        field(60001; "Gen. Journal Template Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Gen. Journal Template Code';
        }
    }

    keys
    {
        // Add changes to keys here
    }
  
    trigger OnInsert()
    var
        recGenJournalTemplate: Record "Gen. Journal Template";
        IsHandled: Boolean;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesCode: Code[40];

        recDefaultDim: Record "Default Dimension";
        recLocation: Record Location;
        begin

            recGenJournalTemplate.Get(Rec."Gen. Journal Template Code");
            Rec."No." := NoSeriesMgt.GetNextNo(recGenJournalTemplate."No. Series", 0D, true);
            recGenJournalTemplate.TestField("No. Series");
            NoSeriesCode := recGenJournalTemplate."No. Series";
        end;


    // Rec.TestField("Location Code");
    // if not recGenJournalTemplate.Get("Gen. Journal Template Code") then
    //     exit;
    // recDefaultDim.SetRange("No.", Rec."Location Code");
    // if recDefaultDim.FindFirst() then begin
    //     if recDefaultDim."Dimension Value Code" = recGenJournalTemplate."Shortcut Dimension 1 Code" then begin
    //         Rec."Global Dimension 1 Code" := recGenJournalTemplate."Shortcut Dimension 1 Code";
    //         Rec.Validate("Global Dimension 1 Code", recGenJournalTemplate."Shortcut Dimension 1 Code");
    //     end;
    // end;


    var
        myInt: Integer;
}