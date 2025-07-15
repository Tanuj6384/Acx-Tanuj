tableextension 60014 "NoSeriesRelationShipExt" extends "No. Series Relationship"
{
    fields
    {
        field(60000; "Security Center Codes"; Code[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Security Center Codes';
        }
    }
    var
        myInt: Integer;
}
