table 60001 "Security Centers"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Security Center";
    DrillDownPageId = "Security Center";

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Address";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Address 2";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"City";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Post Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(7;"Country/Region Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(8;"Phone No.";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Fax No.";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Name 2";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Contact";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Global Dimension 1 Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(1));
        }
        field(13;"Global Dimension 2 Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(2));

            trigger OnValidate()begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(14;"Location Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit"=CONST(false));

            trigger OnValidate()begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(15;"County";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16;"E-Mail";Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Home Page";Text[90])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(19;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(20;"Contract Gain/Loss Amount";Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contract Gain/Loss Entry".Amount WHERE("Responsibility Center"=FIELD("Code"), "Change Date"=FIELD("Date Filter")));
        }
    }
    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }
    procedure ValidateShortcutDimCode(FieldNumber: Integer;
    VAR ShortcutDimCode: Code[20])begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        MODIFY;
    end;
    var PostCode: Record "Post Code";
    DimMgt: Codeunit "DimensionManagement";
    trigger OnInsert()begin
    end;
    trigger OnModify()begin
    end;
    trigger OnDelete()begin
    end;
    trigger OnRename()begin
    end;
}
