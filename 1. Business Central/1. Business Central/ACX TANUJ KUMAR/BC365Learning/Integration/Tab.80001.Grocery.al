table 80001 GroceryStore
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "id"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; category; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; name; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(4;inStock; Text[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; id)
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