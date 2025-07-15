tableextension 60006 "TableExtSalesReceivableSetup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(60000;"Sales Template Temp";Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Template Temp';
            TableRelation = "Gen. Journal Template";
        }
    }
    var myInt: Integer;
}
