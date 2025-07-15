pageextension 60028 "FixedAssetListExt" extends "Fixed Asset List"
{
    layout
    {
        // Add changes to page layout here
    }


    trigger OnOpenPage()
    var
        GenJourTemplateSubType: Enum "Gen. Jour. Template SubType";
    begin
        GenJnlManagement.TemplateSelectionForFixedAsset(5600, GenJourTemplateSubType::"Fixed Asset", Rec, JnlSelected, GenJnlTemplateCode);
        if not JnlSelected then
            Error('Journal template not selected.');
        recFixedAssetSetup.Get();
        recFixedAssetSetup."FA Template Temp" := GenJnlTemplateCode;
        recFixedAssetSetup.Modify();
    end;

    trigger OnClosePage()
    begin
        recFixedAssetSetup.GET();
        recFixedAssetSetup."FA Template Temp" := '';
        recFixedAssetSetup.MODIFY;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.validate("Gen. Journal Template Code", GenJnlTemplateCode);
    end;

    var
        GenJnlManagement: Codeunit "Gen. Jour. Template Management";
        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
        recFixedAssetSetup: Record "FA Setup";
}
