tableextension 60008 CustomersExt extends "Customer"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Security Center Codes"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    
    keys
    {
        // Add changes to keys here
    }
    
    fieldgroups
    {
        // Add changes to field groups here
    }
    
    var
        myInt: Integer;
}