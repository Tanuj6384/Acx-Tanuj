tableextension 60001 "manufacturing setup" extends "Manufacturing Setup"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Prod. Template Temp"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prod. Template Temp';
            TableRelation = "Gen. Journal Template";
        }
        field(60002; "Firm Plan Template Temp"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prod. Template Temp';
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