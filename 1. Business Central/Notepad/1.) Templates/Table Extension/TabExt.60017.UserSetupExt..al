tableextension 60017 UserSetupExt extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Security Center Filter"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Security Centers".Code;
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