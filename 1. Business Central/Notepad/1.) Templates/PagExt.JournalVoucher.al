pageextension 60556 JournalVoucherExt extends "Journal Voucher"
{
    layout
    {
        //Acx-Tanuj Start
        addafter("Account No.")
        {
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = all;
                Editable = editfield;
            }
        }
        
        modify("Account Type")
        {
            trigger OnAfterValidate()
            begin
                Rec."Posting Group" := '';
                if Rec."Account Type" <> Rec."Account Type"::Employee then begin
                    EditField := false;
                end else begin
                    EditField := true;
                end;
            end;
        }
        // //Acx-Tanuj End

    }

    var
        EditField: Boolean;
}
