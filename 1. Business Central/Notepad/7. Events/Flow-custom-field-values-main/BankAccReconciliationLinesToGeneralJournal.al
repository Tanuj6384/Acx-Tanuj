codeunit 50122 EventHandler
{
    [EventSubscriber(ObjectType::Report, Report::"Trans. Bank Rec. to Gen. Jnl.", OnBeforeGenJnlLineInsert, '', false, false)]
    local procedure "Trans. Bank Rec. to Gen. Jnl._OnBeforeGenJnlLineInsert"(var GenJournalLine: Record "Gen. Journal Line"; BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        GenJournalLine."ZY Test" := BankAccReconciliationLine."ZY Test";
    end;
}

tableextension 50119 BankAccReconciliationLineExt extends "Bank Acc. Reconciliation Line"
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
pageextension 50119 BankAccReconciliationLinesExt extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter("Transaction Date")
        {
            field("ZY Test"; Rec."ZY Test")
            {
                ApplicationArea = All;
            }
        }
    }
}
tableextension 50120 GenJournalLineExt extends "Gen. Journal Line"
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

pageextension 50121 GeneralJournalExt extends "General Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("ZY Test"; Rec."ZY Test")
            {
                ApplicationArea = All;
            }
        }
    }
}
