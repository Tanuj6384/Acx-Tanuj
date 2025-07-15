tableextension 60003 JenJenTempExt extends "Gen. Journal Template"
{
    fields
    {
        field(60000; "Security Center Codes"; Code[260])
        {
            DataClassification = ToBeClassified;
            Caption = 'Security Center Codes';
        }
        field(60001; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(60002; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(60003; "Shortcut Dimension 2 Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(60004; "Posting Invoice No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Invoice No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN FIELDERROR("Posting No. Series", STRSUBSTNO(Text001, "Posting No. Series"));
            end;
        }
        field(60005; "Posting Shipment No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Shipment No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN FIELDERROR("Posting No. Series", STRSUBSTNO(Text001, "Posting No. Series"));
            end;
        }
        field(60006; "Order Template Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Template Code';
            TableRelation = "Gen. Journal Template";
        }

        field(60007; "Sub Type"; Enum "Gen. Jour. Template SubType")
        {
            DataClassification = ToBeClassified;
            Caption = 'Sub Type';

            trigger OnValidate()
            begin
                SourceCodeSetup.GET;
                CASE "Sub Type" OF
                    "Sub Type"::"Cash Receipt Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Cash Receipt Voucher");
                            "Source Code" := SourceCodeSetup."Cash Receipt Voucher";
                            "Page ID" := PAGE::"Cash Receipt Voucher";
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Cash Payment Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Cash Payment Voucher");
                            "Source Code" := SourceCodeSetup."Cash Payment Voucher";
                            "Page ID" := PAGE::"Cash Payment Voucher";
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Bank Receipt Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Bank Receipt Voucher");
                            "Source Code" := SourceCodeSetup."Bank Receipt Voucher";
                            "Page ID" := PAGE::"Bank Receipt Voucher";
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Bank Payment Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Bank Payment Voucher");
                            "Source Code" := SourceCodeSetup."Bank Payment Voucher";
                            "Page ID" := PAGE::"Bank Payment Voucher";
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Contra Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Contra Voucher");
                            "Source Code" := SourceCodeSetup."Contra Voucher";
                            "Page ID" := PAGE::"Contra Voucher";
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Journal Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Journal Voucher");
                            "Source Code" := SourceCodeSetup."Journal Voucher";
                            "Page ID" := PAGE::"Journal Voucher";
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                END;
            end;
        }
        field(60008; "Purchase Order No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Purchase Order No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN FIELDERROR("Posting No. Series", STRSUBSTNO(Text001, "Posting No. Series"));
            end;
        }
        field(60009; "Template Convert"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }

    }
    var
        Text000: Label 'Only the %1 field can be filled in on recurring journals.';
        Text001: Label 'must not be %1';
        SourceCodeSetup: Record "Source Code Setup";
}
