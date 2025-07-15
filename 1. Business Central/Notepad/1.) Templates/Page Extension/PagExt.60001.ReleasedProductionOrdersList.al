pageextension 60001 "PageExtReleasedProdOrderList" extends "Released Production Orders"
{
    trigger OnOpenPage()
    var
        GenJourTemplateSubType: Enum "Gen. Jour. Template SubType";
    begin
        GenJnlManagement.TemplateSelectionForProduction(99000831, GenJourTemplateSubType::"Rel. Prod. Order", Rec, JnlSelected, GenJnlTemplateCode);
        IF NOT JnlSelected THEN ERROR('');
        recManufactureSetup.GET();
        recManufactureSetup."Prod. Template Temp" := GenJnlTemplateCode;
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