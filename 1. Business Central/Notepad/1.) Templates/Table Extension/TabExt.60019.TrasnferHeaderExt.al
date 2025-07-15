tableextension 60019 "TransferHeaderExt" extends "Transfer Header"
{
    fields
    {

        field(60001; "Gen. Journal Template Code"; Code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Gen. Journal Template Code';
            TableRelation = "Gen. Journal Template";
        }
        // field(60002; "Responsibility Center"; Code[10])
        // {
        //     Caption = 'Responsibility Center';
        //     TableRelation = "Responsibility Center";

        // }

    }
}