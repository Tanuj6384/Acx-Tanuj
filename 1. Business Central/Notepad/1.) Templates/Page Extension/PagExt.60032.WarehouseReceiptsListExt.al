pageextension 60032 WarehouseReceiptsListExt extends "Warehouse Receipts"
{
    layout
    {
        // Add changes to page layout here
    }


    trigger OnOpenPage()
    var
        GenJourTemplateSubType: Enum "Gen. Jour. Template SubType";
    begin

        GenJnlManagement.TemplateSelectionForWarehouseReceipt(5768, GenJourTemplateSubType::"Warehouse Receipt", Rec, JnlSelected, GenJnlTemplateCode);
        if not JnlSelected then
            Error('Journal template not selected.');
        recWarehouseSetup.Get();
        recWarehouseSetup."Warehouse Receipt Template Temp" := GenJnlTemplateCode;
        recWarehouseSetup.Modify();
    end;

    trigger OnClosePage()
    begin
        recWarehouseSetup.GET();
        recWarehouseSetup."Warehouse Receipt Template Temp" := '';
        recWarehouseSetup.MODIFY;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.validate("Gen. Journal Template Code", GenJnlTemplateCode);
        
    end;


    var
        GenJnlManagement: Codeunit "Gen. Jour. Template Management";
        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
        recWarehouseSetup: Record "Warehouse Setup";
}