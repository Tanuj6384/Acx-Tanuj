table 50011 StudentTable
{
    DataClassification = ToBeClassified;


    fields
    {

        // field(15; "Addmission No. Series"; Code[20])
        // {
        //     Caption = 'Addmission No. Series';
        //     TableRelation = "No. Series";

        // }
        field(1; "Addmission No."; code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
            // InitValue = 'Tanuj ';
            trigger OnValidate()
            var
                studentLedgerEntries: Record StudentLedgerEntries;
            begin
                studentLedgerEntries.Reset();
                studentLedgerEntries.SetRange("Addmission No.", Rec."Addmission No.");
                if studentLedgerEntries.FindFirst() then begin
                    studentLedgerEntries."Student Name" := rec.Name;
                    studentLedgerEntries.Modify();
                end;
            end;


        }
        field(3; "Parent Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; DOB; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(5; Address; Text[200])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF XRec.Address <> Rec.Address then begin
                    Rec.Lulu := true;
                    Rec.Modify();
                end;

                if Rec.Address = '' then begin
                    Rec.Lulu := false;
                    Rec.Modify();
                end;
            end;

        }
        field(6; Address2; Text[200])
        {
            DataClassification = ToBeClassified;
        }

        field(7; "PostalCode"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            trigger OnValidate()
            begin
                recPostCode.Reset();
                recPostCode.SetFilter(Code, Rec.PostalCode);
                if recPostCode.FindFirst() then begin
                    Rec.city := recPostCode.City;
                end;
            end;
        }
        field(8; city; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Mobile No."; Text[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Length := StrLen(Rec."Mobile No.");
                if (Length <> 10) then
                    Error('Length Should be 10 Digit');

                Pos := CopyStr(Rec."Mobile No.", 1, 1);
                if (Pos IN ['1' .. '5']) then
                    Error('Intial Should be 6,7,8,9');
            end;

        }
        field(10; Transportation; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; class; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; balance; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("StudentLedgerEntries"."Remaning  Amount" where("Addmission No." = field("Addmission No."))); // , open = const(true)

        }
        field(13; Status; Option)
        {
            OptionMembers = "Open","Release";
            DataClassification = ToBeClassified;
        }

        field(14; MyWork; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Month; Enum MonthEnum)
        {

        }

        field(16; Lulu; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if xRec.Address <> Rec.Address then
                    Rec.Lulu := true;
            end;
        }
    }

    keys
    {
        key(Key1; "Addmission No.")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    // AddmissionNo: Code[20];
    begin
        SalesSetup.Get();
        "Addmission No." := NoSeriesMgt.GetNextNo(SalesSetup."No Series Add", 0D, true);
        // Validate("Addmission No.", AddmissionNo);
    end;


    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        Length: Integer;
        Pos: Text;
        recPostCode: Record "Post Code";
}