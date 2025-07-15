tableextension 60004 PurchaseHeaderExt extends "Purchase Header"

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
        recGenJournalTemp: Record "Gen. Journal Template";
    begin
        Message('tesing');
        recGenJournalTemp.Get(Rec."Gen. Journal Template Code");
        Rec.Validate("Location Code", recGenJournalTemp."Location Code");
    end;

    var
        myInt: Integer;
        nsf:Page "Purchase Quote";
}