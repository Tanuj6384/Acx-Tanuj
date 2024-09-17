pageextension 50016 "Posted Sales InvoicesExtention" extends "Posted Sales Invoices"
{
    actions
    {
        addafter(Dimensions)
        {
            action("Sales Invoice Report")
            {
                Image = "Report";
                Caption = 'Sales Invoice Report';
                ApplicationArea = all;



                trigger OnAction()
                var
                    recSales: Record "Sales Invoice Header";
                begin
                    recSales.Reset();
                    recSales.SetRange("No.", Rec."No.");
                    if recSales.FindFirst() then
                        if (recSales."Invoice Type" = recSales."Invoice Type"::Taxable) and (recSales."GST Customer Type" = recSales."GST Customer Type"::Registered) then begin
                            if Rec."IRN Hash" <> '' then
                                Report.Run(98060, true, false, recSales)
                            else
                                Message('First generate E-Invoice then print Invoice');
                        end
                        else
                            Report.Run(98060, true, false, recSales);
                end;
            }
        }

        //Acx-Tanuj 08042024
        addbefore(Print)
        {
            action("Sales E Invoicing Multi")
            {
                ApplicationArea = all;
                Image = Invoice;

                trigger OnAction()
                var
                    RecPosSaleInv: Record "Sales Invoice Header";
                begin
                    RecPosSaleInv.SETRECFILTER; // Set filter on RecPosSaleInv
                    CurrPage.SetSelectionFilter(RecPosSaleInv); // Set selection filter on the current page
                    REPORT.RUN(98062, TRUE, FALSE, RecPosSaleInv); // Run report with filter
                    RecPosSaleInv.RESET;
                end;
            }
        }
        addafter(Print_Promoted)
        {
            actionref(SalesEInvoicingMulti_promoted; "Sales E Invoicing Multi")
            {
            }
        }
        // Acx-Tanuj 08042024


    }


}

