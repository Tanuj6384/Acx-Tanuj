pageextension 60555 ExtendsBankPayVoucher extends "Bank Payment Voucher"
{
    layout
    {
     
         addafter("Account No.")
     {
         field("Posting Group";Rec."Posting Group")
         {
             ApplicationArea = All;
             Editable=EditField;
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
    EditField:Boolean;
 
}
 

