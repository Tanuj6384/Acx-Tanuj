pageextension 60007 "PurchaseReturnOrderListExt" extends "Purchase Return Order List"
{
    trigger OnOpenPage()
    var
        GenJourTemplateSubType: Enum "Gen. Jour. Template SubType";
    begin
        GenJnlManagement.TemplateSelectionForPurchase(6640, GenJourTemplateSubType::"Return Order", Rec, JnlSelected, GenJnlTemplateCode);
        IF NOT JnlSelected THEN ERROR('');
        recPurchSetup.GET();
        recPurchSetup."Purch Template Temp" := GenJnlTemplateCode;
        recPurchSetup.MODIFY;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You Can Not Delete Document');
    end;

    trigger OnClosePage()
    begin
        recPurchSetup.GET();
        recPurchSetup."Purch Template Temp" := '';
        recPurchSetup.MODIFY;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.validate("Gen. Journal Template Code", GenJnlTemplateCode);
    end;

    var
        SecCtrMgmt: Codeunit "Security Center Management";
        cdSecurityCtr: Code[20];
        cdSecurityCtrGD1: Code[20];
        recPurchSetup: Record "Purchases & Payables Setup";
        recGenJournalTemplate: Record "Gen. Journal Template";
        GenJnlManagement: Codeunit "Gen. Jour. Template Management";
        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
}