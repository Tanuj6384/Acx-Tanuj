codeunit 50122 EventHandler
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeSalesShptHeaderInsert, '', false, false)]
    local procedure OnBeforeSalesShptHeaderInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; WhseShip: Boolean; InvtPickPutaway: Boolean);
    begin
        SalesShptHeader."ZY Test" := TempWhseShptHeader."ZY Test";
    end;
}

tableextension 50119 WarehouseShipmentHeaderExt extends "Warehouse Shipment Header"
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

pageextension 50119 WarehouseShipmentExt extends "Warehouse Shipment"
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

tableextension 50120 SalesShipmentHeaderExt extends "Sales Shipment Header"
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

pageextension 50120 PostedSalesShipmentExt extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Posting Date")
        {
            field("ZY Test"; Rec."ZY Test")
            {
                ApplicationArea = All;
            }
        }
    }
}
