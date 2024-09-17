pageextension 70001 PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Reason To ReOpen"; Rec."Reason To ReOpen")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Reopen)
        {
            trigger OnAfterAction()
            var
                myInt: Integer;
            begin
                if Rec."Reason To ReOpen" = '' then
                    Error('Reason should be mandatory');

                recPurchHeader.Reset();
                recReopenHistory.Reset();
                recReopenHistory.SetRange("PO No", Rec."No.");
                recReopenHistory.SetRange("Reason To ReOpen", Rec."Reason To ReOpen");
                if recReopenHistory.FindFirst() then
                    Error('Same Reason Should be reason to reopen plaese change');
                    
                recReopenHistory.Reset();
                recReopenHistory.Init();
                Evaluate(recReopenHistory."PO No", Rec."No.");
                Evaluate(recReopenHistory."Buy From Vendor Name", Rec."Buy-from Vendor Name");
                Evaluate(recReopenHistory."Sell To customer Name", Rec."Sell-to Customer No.");
                // (recReopenHistory."Reason To Reopen Date",Rec."Posting Date");
                recReopenHistory.Validate("Reason To Reopen Date", Rec."Posting Date");
                Evaluate(recReopenHistory."Sell To customer Name", Rec."Sell-to Customer No.");
                Evaluate(recReopenHistory."Reason To Reopen", Rec."Reason To ReOpen");
                // Evaluate(recReopenHistory."Serial No",Rec."");
                recReopenHistory.Insert(true);
            end;
        }
    }
    var
        myInt: Integer;
        recPurchHeader: Record "Purchase Header";
        recReopenHistory: Record ReopenHistory;
}