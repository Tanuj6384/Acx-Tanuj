codeunit 50122 EventHandler
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer);
    begin
        NewItemLedgEntry."ZY Test" := ItemJournalLine."ZY Test";
    end;
}

tableextension 50122 ItemJournalLineExt extends "Item Journal Line"
{
    fields
    {
        field(50000; "ZY Test"; Text[100])
        {
            Caption = 'ZY Test';
            DataClassification = CustomerContent;
        }
    }
}

pageextension 50122 ItemJournalExt extends "Item Journal"
{
    layout
    {
        addafter(Description)
        {
            field("ZY Test"; Rec."ZY Test")
            {
                ApplicationArea = All;
            }
        }
    }
}

tableextension 50113 ItemLedgerEntryExt extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "ZY Test"; Text[100])
        {
            Caption = 'ZY Test';
            DataClassification = CustomerContent;
        }
    }
}

pageextension 50113 ItemLedgerEntriesExt extends "Item Ledger Entries"
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
