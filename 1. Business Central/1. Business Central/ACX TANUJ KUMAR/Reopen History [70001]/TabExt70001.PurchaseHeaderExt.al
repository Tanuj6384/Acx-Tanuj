tableextension 70001 PurchOrderExt extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Reason To ReOpen"; Text[70])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Rec.TestField(Status, Rec.Status::Open);
            end;
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