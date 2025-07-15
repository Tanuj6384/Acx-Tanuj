pageextension 60018 "SalesInvoiceListExt" extends "Sales Invoice List"
{
    trigger OnOpenPage()
    var
        GenJourTemplateSubType: Enum "Gen. Jour. Template SubType";
    begin
        //if UserId<>'USHAYARN\ADMINISTRATOR' then begin

        GenJnlManagement.TemplateSelectionForSales(43, GenJourTemplateSubType::Invoice, Rec, JnlSelected, GenJnlTemplateCode);
        IF NOT JnlSelected THEN ERROR('');
        recSalesSetup.GET();
        recSalesSetup."Sales Template Temp" := GenJnlTemplateCode;
        recSalesSetup.MODIFY;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You Can Not Delete Document');
    end;
    //  end;

    trigger OnClosePage()
    begin
        //  // if UserId<>'USHAYARN\ADMINISTRATOR' then begin

        recSalesSetup.GET();
        recSalesSetup."Sales Template Temp" := '';
        recSalesSetup.MODIFY;
    end;
    //  end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // if UserId<>'USHAYARN\ADMINISTRATOR' then begin

        Rec.validate("Gen. Journal Template Code", GenJnlTemplateCode);
    end;
    // end;

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