table 50006 "Purchase Inv File Info"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = ' ,Order';
            OptionMembers = " ","Order";
        }
        field(2; "P.O. No."; Code[20])
        {
            TableRelation = "Purchase Header"."No.";

            trigger OnValidate()
            begin
                //VTS_ANUBHAV
                RecPurchHdr.RESET;
                RecPurchHdr.SETRANGE(RecPurchHdr."No.", "P.O. No.");
                IF RecPurchHdr.FINDFIRST THEN BEGIN
                    RecPurchRecHdr.RESET;
                    RecPurchRecHdr.SETRANGE(RecPurchRecHdr."No.", RecPurchHdr."Last Receiving No.");
                    IF RecPurchRecHdr.FINDFIRST THEN BEGIN
                        "MRN Date" := RecPurchRecHdr."Posting Date";
                        Rec.MODIFY;
                    END;

                END;
                //VTS_ANUBHAV
            end;
        }
        field(3; "Item No."; Code[20])
        {
        }
        field(4; "Line No."; Integer)
        {
        }
        field(5; Quantity; Decimal)
        {
        }
        field(6; "Unit of Measure"; Code[10])
        {
        }
        field(7; "Unit Price"; Decimal)
        {
            DecimalPlaces = 4 : 4;
        }
        field(8; "Line Value"; Decimal)
        {
        }
        field(9; "Sales Order No."; Code[20])
        {
            TableRelation = "Sales Header"."No.";
        }
        field(10; "Invoice No."; Code[20])
        {
        }
        field(11; "Shipment No. from UK"; Code[20])
        {
        }
        field(12; "Entry No."; Integer)
        {
        }
        field(13; "Date And Time"; DateTime)
        {

            trigger OnValidate()
            begin
                //IF "Date And Time" <> 0DT THEN
                //  "Filter Date" := COPYSTR("Date And Time",1,10);
            end;
        }
        field(14; "User Id"; Code[30])
        {
        }
        field(15; "Include Date"; Date)
        {
        }
        field(16; "SO INR Value"; Decimal)
        {
        }
        field(17; "Filter Date"; Date)
        {
        }
        field(18; "MRN Date"; Date)
        {
        }
        field(19; "HSN\SAC Code"; Code[8])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Item No.", "Entry No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Line Value", "SO INR Value";
        }
        key(Key2; "P.O. No.")
        {
        }
        key(Key3; "Entry No.")
        {
        }
        key(Key4; "P.O. No.", "Item No.", "Line No.")
        {
        }
        key(Key5; "Sales Order No.")
        {
            SumIndexFields = "Line Value", "SO INR Value";
        }
        key(Key6; "Sales Order No.", "Include Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RecPurchHdr: Record "Purchase Header";
        RecPurchRecHdr: Record "Purch. Rcpt. Header";
}

