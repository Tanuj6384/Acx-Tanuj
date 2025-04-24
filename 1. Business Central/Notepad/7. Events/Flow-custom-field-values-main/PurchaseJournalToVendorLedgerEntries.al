codeunit 50122 EventHandler
{
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterCopyVendLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    begin
        VendorLedgerEntry."ZY Test" := GenJournalLine."ZY Test";
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

tableextension 50121 VendorLedgerEntryExt extends "Vendor Ledger Entry"
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

pageextension 50121 VendorLedgerEntriesExt extends "Vendor Ledger Entries"
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
