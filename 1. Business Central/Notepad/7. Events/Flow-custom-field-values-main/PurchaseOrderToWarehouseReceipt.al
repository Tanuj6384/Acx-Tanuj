codeunit 50122 EventHandler
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", OnAfterFindWarehouseRequestForPurchaseOrder, '', false, false)]
    local procedure OnAfterFindWarehouseRequestForPurchaseOrder(var WarehouseRequest: Record "Warehouse Request"; PurchaseHeader: Record "Purchase Header");
    begin
        WarehouseRequest."ZY Test" := PurchaseHeader."ZY Test";
        WarehouseRequest.Modify(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", OnAfterCreateWhseReceiptHeaderFromWhseRequest, '', false, false)]
    local procedure OnAfterCreateWhseReceiptHeaderFromWhseRequest(var WhseReceiptHeader: Record "Warehouse Receipt Header"; var WarehouseRequest: Record "Warehouse Request"; var GetSourceDocuments: Report "Get Source Documents");
    begin
        if WhseReceiptHeader."No." <> '' then begin
            WhseReceiptHeader."ZY Test" := WarehouseRequest."ZY Test";
            WhseReceiptHeader.Modify(true);
        end;
    end;
}
tableextension 50119 PurchaseHeaderExt extends "Purchase Header"
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

pageextension 50119 SalesOrderExt extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field("ZY Test"; Rec."ZY Test")
            {
                ApplicationArea = All;
            }

        }
    }
}

tableextension 50120 WarehouseRequestExt extends "Warehouse Request"
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

tableextension 50121 WarehouseReceiptHeaderExt extends "Warehouse Receipt Header"
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

pageextension 50121 WarehouseReceiptExt extends "Warehouse Receipt"
{
    layout
    {
        addafter("Document Status")
        {
            field("ZY Test"; Rec."ZY Test")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
