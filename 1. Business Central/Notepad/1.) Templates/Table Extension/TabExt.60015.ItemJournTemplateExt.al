tableextension 60015 "ItemJournTemplateExt" extends "Item Journal Template"
{
    fields
    {
        field(60000;"Security Center Codes";Code[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Security Center Codes';
        }
        field(60001;"Location Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(60002;"Shortcut Dimension 1 Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(1));
        }
        field(60003;"Shortcut Dimension 2 Code";Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(2));
        }
        field(60007;"Sub Type";Enum "Gen. Jour. Template SubType")
        {
            DataClassification = ToBeClassified;
            Caption = 'Sub Type';
        }
        field(60008;Production; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Production';
        }
    }
    var myInt: Integer;
}
