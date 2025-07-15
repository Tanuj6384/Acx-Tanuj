pageextension 60022 "SalesReturnOrderListExt" extends "Sales Return Order List"
{
    trigger OnOpenPage()
    var
        GenJourTemplateSubType: Enum "Gen. Jour. Template SubType";
    begin
        GenJnlManagement.TemplateSelectionForSales(6630, GenJourTemplateSubType::"Return Order", Rec, JnlSelected, GenJnlTemplateCode);
        IF NOT JnlSelected THEN ERROR('');
        recSalesSetup.GET();
        recSalesSetup."Sales Template Temp" := GenJnlTemplateCode;
        recSalesSetup.MODIFY;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You Can Not Delete Document');
    end;

    trigger OnClosePage()
    begin
        recSalesSetup.GET();
        recSalesSetup."Sales Template Temp" := '';
        recSalesSetup.MODIFY;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.validate("Gen. Journal Template Code", GenJnlTemplateCode);
    end;

    var
        SecCtrMgmt: Codeunit "Security Center Management";
        cdSecurityCtr: Code[20];
        cdSecurityCtrGD1: Code[20];
        recSalesSetup: Record "Sales & Receivables Setup";
        recGenJournalTemplate: Record "Gen. Journal Template";
        GenJnlManagement: Codeunit "Gen. Jour. Template Management";
        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
}