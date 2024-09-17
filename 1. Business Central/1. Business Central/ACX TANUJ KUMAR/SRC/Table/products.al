table 50121 Products
{
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1;ID; Integer)
        {
            DataClassification = ToBeClassified;            
        }
        field(2;Category; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3;Name ;Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(4; InStock;Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    
    keys
    {
        key(PK; ID)
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