codeunit 50123 EventHandler
{
    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", OnAfterCopyFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry");
    begin
        BankAccountLedgerEntry."ZY Test" := GenJournalLine."ZY Test";
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
pageextension 50126 PaymentJournalExt extends "Payment Journal"
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
tableextension 50121 BankAccountLedgerEntryExt extends "Bank Account Ledger Entry"
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
pageextension 50121 BankAccountLedgerEntriesExt extends "Bank Account Ledger Entries"
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
