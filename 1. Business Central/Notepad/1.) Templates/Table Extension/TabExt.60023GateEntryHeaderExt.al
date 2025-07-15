tableextension 60023 GateEntryHeaderExt extends "Gate Entry Header"

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

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnInsert()
    var
        recGenJournalTemplate: Record "Gen. Journal Template";
        IsHandled: Boolean;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesCode: Code[40];


    begin
        IsHandled := true;
        begin
            recGenJournalTemplate.Get(Rec."Gen. Journal Template Code");
            Rec."No." := NoSeriesMgt.GetNextNo(recGenJournalTemplate."No. Series", 0D, true);
            recGenJournalTemplate.TestField("No. Series");
            NoSeriesCode := recGenJournalTemplate."No. Series";
            Rec.Validate("Location Code", recGenJournalTemplate."Location Code");
            Rec.Validate("No. Series", recGenJournalTemplate."No. Series");
            Rec.Validate("Posting No. Series", recGenJournalTemplate."Posting No. Series");
        end;
    end;
    
    var
        myInt: Integer;
}