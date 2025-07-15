tableextension 60555 genjourline extends "Gen. Journal Line"
{
    fields
    {
        // field(60023; "Posting Group_"; Code[20])
        // {

        //     Caption = 'Posting Group';

        //     TableRelation = if ("Account Type" = const(Customer)) "Customer Posting Group"
        //     else
        //     if ("Account Type" = const(Vendor)) "Vendor Posting Group"
        //     else
        //     if ("Account Type" = const("Fixed Asset")) "FA Posting Group"
        //     else
        //     if ("Account Type" = const(Employee)) "Employee Posting Group";
        // }
        modify("Posting Group")
        {
            TableRelation = if ("Account Type" = const(Customer)) "Customer Posting Group"
            else
            if ("Account Type" = const(Vendor)) "Vendor Posting Group"
            else
            if ("Account Type" = const("Fixed Asset")) "FA Posting Group"
            else
            if ("Account Type" = const(Employee)) "Employee Posting Group";
        }
    }
    trigger OnInsert()
    begin

    end;

    var
}
