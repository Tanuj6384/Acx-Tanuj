tableextension 50001 StudentNoseries extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(101; "No Series Add"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
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