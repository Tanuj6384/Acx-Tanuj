pageextension 60037 SalesLineDiscountsExt extends "Sales Line Discounts"
{
    layout
    {
        addbefore("Line Discount %")
        {
            field("Cash Discount(Rs in Kg)"; Rec."Cash Discount(Rs in Kg)")
            {
                ApplicationArea = All;

            }
            field("Price Protection Discount(Rs in KG)"; Rec."Price Protection Discount(Rs in KG)")
            {
                ApplicationArea = All;

            }
            field("Other Discount(Rs in KG)"; Rec."Other Discount(Rs in KG)")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    var
        myInt: Integer;
}