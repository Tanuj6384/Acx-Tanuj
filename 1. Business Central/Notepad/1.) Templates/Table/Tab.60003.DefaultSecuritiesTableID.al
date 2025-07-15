table 60003 "Default Securities Table ID"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table Name"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Table ID Option';
            OptionMembers = " ","G/L Account","Customer","Vendor","Item","Bank Account","Location","Gen. Journal Template","Item Journal Template","Tax Journal Template","Tax Journal Batch","LSC Store";
            OptionCaption = ' ,G/L Account,Customer,Vendor,Item,Bank Account,Location,Gen. Journal Template,Item Journal Template,Tax Journal Template,Tax Journal Batch,LSC Store';

            trigger OnValidate()
            begin
                if "Table Name" = Rec."Table Name"::" " then begin
                    "Table ID Option" := Rec."Table ID Option"::"0";
                    "Table ID" := 0;
                end
                else if "Table Name" = Rec."Table Name"::"G/L Account" then begin
                    "Table ID Option" := Rec."Table ID Option"::"15";
                    "Table ID" := 15;
                end
                else if "Table Name" = Rec."Table Name"::Customer then begin
                    "Table ID Option" := Rec."Table ID Option"::"18";
                    "Table ID" := 18;
                end
                else if "Table Name" = Rec."Table Name"::Vendor then begin
                    "Table ID Option" := Rec."Table ID Option"::"23";
                    "Table ID" := 23;
                end
                else if "Table Name" = Rec."Table Name"::Item then begin
                    "Table ID Option" := Rec."Table ID Option"::"27";
                    "Table ID" := 27;
                end
                else if "Table Name" = Rec."Table Name"::"Bank Account" then begin
                    "Table ID Option" := Rec."Table ID Option"::"270";
                    "Table ID" := 270;
                end
                else if "Table Name" = Rec."Table Name"::Location then begin
                    "Table ID Option" := Rec."Table ID Option"::"14";
                    "Table ID" := 14;
                end
                else if "Table Name" = Rec."Table Name"::"Gen. Journal Template" then begin
                    "Table ID Option" := Rec."Table ID Option"::"80";
                    "Table ID" := 80;
                end
                else if "Table Name" = Rec."Table Name"::"Item Journal Template" then begin
                    "Table ID Option" := Rec."Table ID Option"::"82";
                    "Table ID" := 82;
                end
                else if "Table Name" = Rec."Table Name"::"Tax Journal Template" then begin
                    "Table ID Option" := Rec."Table ID Option"::"16585";
                    "Table ID" := 16585;
                end
                else if "Table Name" = Rec."Table Name"::"Tax Journal Batch" then begin
                    "Table ID Option" := Rec."Table ID Option"::"16586";
                    "Table ID" := 16586;
                end
                else if "Table Name" = Rec."Table Name"::"LSC Store" then begin
                    "Table ID Option" := Rec."Table ID Option"::"99001470";
                    "Table ID" := 99001470;
                end;
            end;
        }
        field(2; "Table ID Option"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Table ID Option';
            OptionMembers = "0","15","18","23","27","270","14","80","82","16585","16586","99001470";
            OptionCaption = '0,15,18,23,27,270,14,80,82,16585,16586,99001470';
        }
        field(3; "Table ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Table Name", "Table ID Option")
        {
            Clustered = true;
        }
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
