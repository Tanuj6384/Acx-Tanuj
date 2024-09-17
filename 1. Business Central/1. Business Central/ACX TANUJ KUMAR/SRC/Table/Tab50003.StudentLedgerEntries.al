table 50003 StudentLedgerEntries
{
    Caption = 'StudentLedgerEntries';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Addmission No."; Code[20])
        {
            Caption = 'Addmission No.';
        }
        field(3; "Student Name"; Text[100])
        {
            Caption = 'Student Name';
        }
        field(4; Class; Code[20])
        {
            Caption = 'Class';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Payment Amount"; Decimal)
        {
            Caption = 'Payment Amount';
        }
        field(7; "Remaning  Amount"; Decimal)
        {
            Caption = 'Remaning  Amount';
        }
        field(8; Quarter; Option)
        {
            Caption = 'Quarter';
            OptionMembers = "Q1","Q2","Q3","Q4";
        }
        field(9; "Quarter Fee"; Decimal)
        {
            Caption = 'Quarter Fee';
        }
        field(10; "Financial Year"; Text[20])
        {
            Caption = 'Financial Year';
        }
        field(11; "Fee Type"; Option)
        {
            Caption = 'Fee Type';
            OptionMembers = "Year Fee","Quarter Fee";
        }
        field(12; Period; Option)
        {
            Caption = 'Period';
            OptionMembers = "Apr-jun","Jul-Sep","Oct-Dec","Jan-Mar";
        }
        field(13; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(14; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(15; Session; Text[30])
        {
            Caption = 'Session';
        }
        
    }
    keys
    {
        key(PK;"Addmission No.","Entry No.")
        {
            Clustered = true;
        }
    }
}
