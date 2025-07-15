tableextension 60002 "ProductionOrderExt" extends "Production Order"
{
    fields
    {
        field(60001; "Gen. Journal Template Code"; Code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Gen. Journal Template Code';
            TableRelation = "Gen. Journal Template";
        }
    }

}