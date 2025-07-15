tableextension 60022 FASetupExt extends "FA Setup"
{
    fields
    {
        // Add changes to table fields here
        field(60000; "FA Template Temp"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch Template Temp';
            TableRelation = "Gen. Journal Template";
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

    var
        myInt: Integer;
}