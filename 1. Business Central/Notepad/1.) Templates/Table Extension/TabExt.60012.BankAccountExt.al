tableextension 60012 "BankAccountExt" extends "Bank Account"
{
    fields
    {
        field(60000;"Security Center Codes";Code[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Security Center Codes';
        }
    }
    var myInt: Integer;
}
