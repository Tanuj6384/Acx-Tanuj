tableextension 60020 "InventorySetupExt" extends "Inventory Setup"
{
    fields
    {
        field(60000; "Transfer Template Temp"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Template Temp';
            TableRelation = "Gen. Journal Template";
        }
        field(60001; "Gate Entry Template Temp"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Template Temp';
            TableRelation = "Gen. Journal Template";
        }
    }

    var
        myInt: Integer;
}
