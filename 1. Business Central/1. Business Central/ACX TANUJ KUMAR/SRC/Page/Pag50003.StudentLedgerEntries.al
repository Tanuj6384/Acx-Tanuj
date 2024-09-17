page 50003 StudentLedgerEntries
{
    ApplicationArea = All;
    Caption = 'Student Ledger Entries';
    PageType = ListPart;
    AutoSplitKey=true;
    SourceTable = StudentLedgerEntries;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field("Entry No."; Rec."Entry No.")
                // {
                // }
                field("Addmission No."; Rec."Addmission No.")
                {

                }
                field("Student Name"; Rec."Student Name")
                {
                }
                field(Class; Rec.Class)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                }
                field("Remaning  Amount"; Rec."Remaning  Amount")
                {
                }
                field(Quarter; Rec.Quarter)
                {
                }
                field("Quarter Fee"; Rec."Quarter Fee")
                {
                }
                field("Financial Year"; Rec."Financial Year")
                {
                }
                field("Fee Type"; Rec."Fee Type")
                {
                }
                field(Period; Rec.Period)
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field(Open; Rec.Open)
                {
                }
                field(Session; Rec.Session)
                {
                }
            }
        }
    }
}
