table 50004 Extra
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Roll No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Mobile No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Love; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(5; "Employe Id"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Employe Name"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Employe Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Current Status"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Roll No.")
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
    begin

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