codeunit 50122 EventHandler
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", OnBeforeValidateQtyToReceiveOnPurchaseLine, '', false, false)]
    local procedure OnBeforeValidateQtyToReceiveOnPurchaseLine(var PurchaseLine: Record "Purchase Line"; WarehouseReceiptLine: Record "Warehouse Receipt Line"; var IsHandled: Boolean);
    begin
        PurchaseLine."ZY Test" := WarehouseReceiptLine."ZY Test";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnPostItemJnlLineOnAfterCopyDocumentFields, '', false, false)]
    local procedure OnPostItemJnlLineOnAfterCopyDocumentFields(var ItemJournalLine: Record "Item Journal Line"; PurchaseLine: Record "Purchase Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; PurchRcptHeader: Record "Purch. Rcpt. Header");
    begin
        ItemJournalLine."ZY Test" := PurchaseLine."ZY Test";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer);
    begin
        NewItemLedgEntry."ZY Test" := ItemJournalLine."ZY Test";
    end;
}

tableextension 50115 WarehouseReceiptLineExt extends "Warehouse Receipt Line"
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

pageextension 50115 WhseReceiptSubformExt extends "Whse. Receipt Subform"
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

tableextension 50114 PurchaseLineExt extends "Purchase Line"
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

tableextension 50112 ItemJournalLineExt extends "Item Journal Line"
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
