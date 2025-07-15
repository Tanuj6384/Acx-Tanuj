pageextension 60039 SalesOrderSubformExt extends "Sales Order Subform"
{
    layout
    {

        // Add changes to page layout here
        addbefore("Line Discount %")
        {

            field("Cash Discount(Rs in Kg)"; Rec."Cash Discount(Rs in Kg)")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Total Cash Discount"; Rec."Total Cash Discount")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Price Protection Discount(Rs in KG)"; Rec."Price Protection Discount(Rs in KG)")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("Total P.P Discount"; Rec."Total P.P Discount")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("Other Discount(Rs in KG)"; Rec."Other Discount(Rs in KG)")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("Total Other Discount"; Rec."Total Other Discount")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        addafter(Quantity)
        {
            field("Billed Quantity"; Rec."Billed Quantity")
            {
                ApplicationArea = All;
            }
        }
        addafter("Unit of Measure")
        {
            field("UOM Conversion"; Rec."UOM Conversion")
            {
                ApplicationArea = All;
            }
        }
        addafter("Unit Price")
        {
            field("Price/Pcs"; Rec."Price/Pcs")
            {
                ApplicationArea = All;
            }

        }
        addafter("UOM Conversion")
        {
            field("Discount in UOM"; Rec."Discount in UOM")
            {
                ApplicationArea = All;
            }
        }

        // moveafter("Line Discount %"; "Line Discount Amount")

        // modify("Unit Price")
        // {
        // trigger OnAfterValidate()
        // var
        //     CalculateTax: Codeunit "Calculate Tax";
        //     OriginalLineAmount: Decimal;
        //     TotalAmtOthcash: Decimal;
        // begin
        //     // ItemUnitOfMeasureRec.Reset();
        //     TotalAmtOthcash := Rec."Total Cash Discount" + Rec."Total Other Discount" + Rec."Total P.P Discount";
        //     //--------------------------------------------------------------------------------------------

        //     // Step 1: Store Original Line Amount Before First Discount is Applied
        //     if (TotalAmtOthcash = 0) then
        //         OriginalLineAmount := Rec."Line Amount"
        //     else
        //         OriginalLineAmount := Rec."Line Amount" - TotalAmtOthcash;

        //     // Step 2: Apply Discount Based on Original Value
        //     if TotalAmtOthcash = 0 then
        //         Rec."Line Amount" := OriginalLineAmount // Restore Original Value
        //     else
        //         Rec.Validate("Line Amount", OriginalLineAmount);

        //     // Step 3: Ensure Line Discount is Recalculated if Needed
        //     if TotalAmtOthcash = 0 then begin
        //         Rec.Validate("Line Discount Amount", ((Rec."Unit Price" * Rec.Quantity * Rec."Line Discount %") / 100));
        //         Rec.Validate("Line Amount", ((Rec."Unit Price" * Rec.Quantity) - Rec."Line Discount Amount"));
        //     end;

        //     // Ensure Line Discount % is Maintained
        //     if TotalAmtOthcash <> 0 then begin
        //         Rec."Line Discount %" := xRec."Line Discount %";
        //     end;

        //     Rec.Modify();
        //     CalculateTax.CallTaxEngineOnSalesLine(Rec, xRec);
        //     CurrPage.Update();
        // end;
        // }


        // modify(Quantity)
        // {
            
        // }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin

            end;
        }


    }

    actions
    {
        // Add changes to page actions here

    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ItemUnitOfMeasureRec: Record "Item Unit of Measure";
        SalesLineDiscountRec: Record "Sales Line Discount";
        UnitofMeasure: Record "Unit of Measure";
        CalculateTax: Codeunit "Calculate Tax";
    begin
        if Rec.Type = Rec.Type::Item then begin
            SalesLineDiscountRec.Reset();
            SalesLineDiscountRec.SetRange(Code, Rec."No.");
            SalesLineDiscountRec.SetRange("Sales Code", Rec."Sell-to Customer No.");
            if SalesLineDiscountRec.FindFirst() then begin
                Rec."Discount in UOM" := SalesLineDiscountRec."Unit of Measure Code";
                Rec."Cash Discount(Rs in Kg)" := SalesLineDiscountRec."Cash Discount(Rs in Kg)";
                Rec."Price Protection Discount(Rs in KG)" := SalesLineDiscountRec."Price Protection Discount(Rs in KG)";
                Rec."Other Discount(Rs in KG)" := SalesLineDiscountRec."Other Discount(Rs in KG)";
                // Rec.UpdateAmounts();
            end;
        end;
    end;    



    var
        myInt: Integer;
        // CalculateTax: Codeunit "Calculate Tax";
        OriginalLineAmount: Decimal;
        CalculateTax: Codeunit "Calculate Tax";
        TotalAmtOthcash: Decimal;
    // SalesLineDiscountRec: Record "Sales Line Discount";

}
