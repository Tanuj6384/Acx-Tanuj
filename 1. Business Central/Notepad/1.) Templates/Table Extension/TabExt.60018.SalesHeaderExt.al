tableextension 60018 SalesHeaderEXt extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Gen. Journal Template Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60002; "Total Cash Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60003; "Total P.P Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60004; "Total Other Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
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

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        Message('testing');
    end;
}