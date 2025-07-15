tableextension 60013 "NoSeriesExt" extends "No. Series"
{
    fields
    {
        field(60000;"Security Center Codes";Code[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Security Center Codes';
        }
        // field(60001;"qualityheader";Text[100])
        // {
        //     DataClassification = ToBeClassified;
        // }
    }
    var myInt: Integer;
}
