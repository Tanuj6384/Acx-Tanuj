tableextension 60005 PurchaseSetupExt extends "Purchases & Payables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(60000; "Purch Template Temp"; Code[10])
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