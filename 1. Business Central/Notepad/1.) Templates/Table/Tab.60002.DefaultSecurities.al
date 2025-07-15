table 60002 "Default Securities"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Default Security";
    DrillDownPageId = "Default Security";

    fields
    {
        field(1; "Table ID"; Integer)
        {
            DataClassification = ToBeClassified;

            //TableRelation = Object.ID where(Type = const(Table));
            trigger OnValidate()
            begin
                CalcFields("Table Name");
            end;

            trigger OnLookup()
            begin
                CLEAR(DefaultSecuritiesTableID);
                IF PAGE.RUNMODAL(50106, DefaultSecuritiesTableID) = ACTION::LookupOK THEN BEGIN
                    "Table ID" := DefaultSecuritiesTableID."Table ID";
                    VALIDATE("Table ID");
                END;
            end;
        }
        field(2; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Table ID" = CONST(15)) "G/L Account"
            ELSE
            IF ("Table ID" = CONST(18)) Customer
            ELSE
            IF ("Table ID" = CONST(23)) Vendor
            ELSE
            IF ("Table ID" = CONST(27)) Item
            ELSE
            IF ("Table ID" = CONST(270)) "Bank Account"
            ELSE
            IF ("Table ID" = CONST(14)) Location
            ELSE
            IF ("Table ID" = CONST(80)) "Gen. Journal Template"
            ELSE
            IF ("Table ID" = CONST(82)) "Item Journal Template";
            //  ELSE IF("Table ID"=CONST(99001470))"LSC Store";
            //ELSE IF ("Table ID" = CONST(16585)) "Tax Journal Template" ELSE
            //IF ("Table ID" = CONST(16586)) "Tax Journal Batch";
        }
        field(3; "Security Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Security Centers"."Code";
        }
        field(4; "Security Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Security Centers".Name WHERE(Code = FIELD("Security Code")));
        }
        field(5; "Table Name"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table), "Object ID" = FIELD("Table ID")));
        }
        field(6; "No. 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Table ID", "No.", "No. 2", "Security Code")
        {
            Clustered = true;
        }
        key(key2; "Security Code")
        {
        }
    }
    procedure UpdateGlobalSecurity(TableID: Integer;
    Code: Code[20];
    Code2: Code[20];
    NewSecurityCode: Code[20];
    blnInsert: Boolean);
    var
        GLAcc: Record "G/L Account";
        Cust: Record "Customer";
        Vend: Record "Vendor";
        Item: Record "Item";
        BankAcc: Record "Bank Account";
        Location: Record "Location";
        GenJournalTemplate: Record "Gen. Journal Template";
        ItemJournalTemplate: Record "Item Journal Template";
        NoSeries: Record "No. Series";
        NoSeriesRel: Record "No. Series Relationship";
        cdSecurity: Code[250];
        blnFirstSemiColon: Boolean;
        DefaultSecurity: Record "Default Securities";
        recProductionBomHeader: Record "Production BOM Header";
    // recStore: Record "LSC Store";
    //TaxjourTemplate: Record "Tax Journal Template";
    //TaxjourBatch: Record "Tax Journal Batch";
    begin
        cdSecurity := '';
        blnFirstSemiColon := FALSE;
        DefaultSecurity.RESET;
        DefaultSecurity.SETRANGE("Table ID", TableID);
        DefaultSecurity.SETRANGE("No.", Code);
        IF Code2 <> '' THEN DefaultSecurity.SETRANGE("No. 2", Code2);
        IF DefaultSecurity.FIND('-') THEN BEGIN
            REPEAT
                IF DefaultSecurity."Security Code" <> NewSecurityCode THEN BEGIN
                    IF NOT blnFirstSemiColon THEN cdSecurity := ';';
                    cdSecurity := cdSecurity + DefaultSecurity."Security Code" + ';';
                    blnFirstSemiColon := TRUE;
                END;
            UNTIL DefaultSecurity.NEXT = 0;
        END;
        IF blnInsert THEN BEGIN
            IF NOT blnFirstSemiColon THEN cdSecurity := cdSecurity + ';';
            cdSecurity := cdSecurity + NewSecurityCode + ';';
        END;
        CASE "Table ID" OF
            DATABASE::"G/L Account":
                BEGIN
                    IF GLAcc.GET(Code) THEN BEGIN
                        GLAcc."Security Center Codes" := cdSecurity;
                        GLAcc.MODIFY(TRUE);
                    END;
                END;
            DATABASE::Customer:
                BEGIN
                    IF Cust.GET(Code) THEN BEGIN
                        Cust."Security Center Codes" := cdSecurity;
                        Cust.MODIFY(TRUE);
                    END;
                END;
            DATABASE::Vendor:
                BEGIN
                    IF Vend.GET(Code) THEN BEGIN
                        Vend."Security Center Codes" := cdSecurity;
                        Vend.MODIFY(TRUE);
                    END;
                END;
            DATABASE::Location:
                BEGIN
                    IF Location.GET(Code) THEN BEGIN
                        Location."Security Center Codes" := cdSecurity;
                        Location.MODIFY(TRUE);
                    END;
                END;
            DATABASE::"Gen. Journal Template":
                BEGIN
                    IF GenJournalTemplate.GET(Code) THEN BEGIN
                        GenJournalTemplate."Security Center Codes" := cdSecurity;
                        GenJournalTemplate.MODIFY(TRUE);
                    END;
                END;
            DATABASE::"Item Journal Template":
                BEGIN
                    IF ItemJournalTemplate.GET(Code) THEN BEGIN
                        ItemJournalTemplate."Security Center Codes" := cdSecurity;
                        ItemJournalTemplate.MODIFY(TRUE);
                    END;
                END;
            DATABASE::Item:
                BEGIN
                    IF Item.GET(Code) THEN BEGIN
                        Item."Security Center Codes" := cdSecurity;
                        Item.MODIFY(TRUE);
                    END;
                END;
            DATABASE::"Bank Account":
                BEGIN
                    IF BankAcc.GET(Code) THEN BEGIN
                        BankAcc."Security Center Codes" := cdSecurity;
                        BankAcc.MODIFY(TRUE);
                    END;
                END;
            DATABASE::"Production BOM Header":
                BEGIN
                    IF recProductionBomHeader.GET(Code) THEN BEGIN
                        recProductionBomHeader."Security Center Codes" := cdSecurity;
                        recProductionBomHeader.MODIFY(TRUE);
                    END;
                END;
            DATABASE::"No. Series":
                BEGIN
                    IF NoSeries.GET(Code) THEN BEGIN
                        NoSeries."Security Center Codes" := cdSecurity;
                        NoSeries.MODIFY(TRUE);
                    END;
                END;
            DATABASE::"No. Series Relationship":
                BEGIN
                    IF NoSeriesRel.GET(Code, Code2) THEN BEGIN
                        NoSeriesRel."Security Center Codes" := cdSecurity;
                        NoSeriesRel.MODIFY(TRUE);
                    END;
                END;
        // DATABASE::"LSC Store": BEGIN
        //     IF recStore.GET("No.")THEN BEGIN
        //         recStore."Security Center Codes":=cdSecurity;
        //         recStore.MODIFY(TRUE);
        //     END;
        // END;
        /*
        DATABASE::"Tax Journal Template":
            BEGIN
                IF TaxjourTemplate.GET(Code) THEN BEGIN
                    TaxjourTemplate."Security Center Codes" := cdSecurity;
                    TaxjourTemplate.MODIFY(TRUE);
                END;
            END;

        DATABASE::"Tax Journal Batch":
            BEGIN
                IF TaxjourBatch.GET(Code) THEN BEGIN
                    TaxjourBatch."Security Center Codes" := cdSecurity;
                    TaxjourBatch.MODIFY(TRUE);
                END;
            END;
        */
        END;
    end;

    var //TempObject: Record Object;
        DefaultSecuritiesTableID: Record "Default Securities Table ID";
        Text000: Label 'You cannect rename a %1.';

    trigger OnInsert()
    begin
        UpdateGlobalSecurity("Table ID", "No.", "No. 2", "Security Code", TRUE);
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
        UpdateGlobalSecurity("Table ID", "No.", "No. 2", "Security Code", TRUE);
    end;

    trigger OnRename()
    begin
        ERROR(Text000, TABLECAPTION);
    end;
}
