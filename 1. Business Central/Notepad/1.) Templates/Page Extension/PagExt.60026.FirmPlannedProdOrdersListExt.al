pageextension 60026 FirmPlannedProdOrdersListExt extends "Firm Planned Prod. Orders"
{
    trigger OnOpenPage()
    var
        GenJourTemplateSubType: Enum "Gen. Jour. Template SubType";
    begin
        // GenJnlManagement.TemplateSelectionForFirmPlan(99000829, GenJourTemplateSubType::"Firm Planned Prod. Order", Rec, JnlSelected, GenJnlTemplateCode);
        GenJnlManagement.TemplateSelectionForFirmPlan(9325, GenJourTemplateSubType::"Firm Planned Prod. Order", Rec, JnlSelected, GenJnlTemplateCode);
        IF NOT JnlSelected THEN ERROR('');
        recManufactureSetup.GET();
        recManufactureSetup."firm Plan Template Temp" := GenJnlTemplateCode;
        recManufactureSetup.MODIFY;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You Can Not Delete Document');
    end;

    trigger OnClosePage()
    begin
        recManufactureSetup.GET();
        recManufactureSetup."Prod. Template Temp" := '';
        recManufactureSetup.MODIFY;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Message('new Record');
        Rec.validate("Gen. Journal Template Code", GenJnlTemplateCode);
    end;

    var
        GenJnlManagement: Codeunit "Gen. Jour. Template Management";
        GenJnlTemplateCode: Code[10];
        JnlSelected: Boolean;
        recManufactureSetup: Record "Manufacturing Setup";
}