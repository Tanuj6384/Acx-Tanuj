pageextension 60034 OutwardGateEntryListExt extends "Outward Gate Entry List"
{
    trigger OnOpenPage()
    var
        GenJourTemplateSubType: Enum "Gen. Jour. Template SubType";
    begin
        GenJnlManagement.TemplateSelectionForOutwardGate(18610, GenJourTemplateSubType::GOR, Rec, JnlSelected, GenJnlTemplateCode);
        if not JnlSelected then
            Error('Journal template not selected.');

        recInventorySetup.Get();
        recInventorySetup."Gate Entry Template Temp" := GenJnlTemplateCode;
        recInventorySetup.Modify();
    end;

    trigger OnClosePage()
    begin
        recInventorySetup.Get();
        recInventorySetup."Gate Entry Template Temp" := '';
        recInventorySetup.Modify();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate("Gen. Journal Template Code", GenJnlTemplateCode);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You cannot delete this document.');
    end;

    var
        GenJnlManagement: Codeunit "Gen. Jour. Template Management";
        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
        recInventorySetup: Record "Inventory Setup";
}


