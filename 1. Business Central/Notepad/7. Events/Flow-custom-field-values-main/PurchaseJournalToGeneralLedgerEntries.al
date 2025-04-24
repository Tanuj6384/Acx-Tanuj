codeunit 50122 EventHandler
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line");
    begin
        GLEntry."ZY Test" := GenJournalLine."ZY Test";
    end;
}

tableextension 50119 GenJournalLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(50100; "ZY Test"; Text[100])
        {
            Caption = 'ZY Test';
            DataClassification = CustomerContent;
        }
    }
}

pageextension 50119 PurchaseJournalExt extends "Purchase Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("ZY Test"; Rec."ZY Test")
            {
                ApplicationArea = All;
            }

        }
    }
}

tableextension 50121 GLEntryExt extends "G/L Entry"
{
    fields
    {
        field(50100; "ZY Test"; Text[100])
        {
            Caption = 'ZY Test';
            DataClassification = CustomerContent;
        }
    }
}

pageextension 50121 GeneralLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("ZY Test"; Rec."ZY Test")
            {
                ApplicationArea = All;
            }
        }
    }
}
