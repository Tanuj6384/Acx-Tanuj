table 70001 ReopenHistory
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "PO No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Buy From Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Sell To customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Reason To Reopen Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Reason To Reopen"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Serial No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "PO No", "Reason To Reopen")
        {
            Clustered = true;
        }

    }

    fieldgroups
    {
        // Add changes to field groups here
    }


    var
        myInt: Integer;
    trigger OnInsert()
    var
        CurrReopenHist: Record ReopenHistory;

    begin
        CurrReopenHist.Reset();
        CurrReopenHist.SetRange("PO No", Rec."PO No");
        if CurrReopenHist.FindLast() then
            "Serial No" := CurrReopenHist."Serial No" + 1
        else
            "Serial No" := 1;

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

}