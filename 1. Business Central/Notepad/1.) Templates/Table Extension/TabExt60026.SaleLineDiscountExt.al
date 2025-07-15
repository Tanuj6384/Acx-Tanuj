tableextension 60026 SaleLineDiscountExt extends "Sales Line Discount"
{
    fields
    {
        field(60000; "Cash Discount(Rs in Kg)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60001; "Price Protection Discount(Rs in KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60002; "Other Discount(Rs in KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
}
    