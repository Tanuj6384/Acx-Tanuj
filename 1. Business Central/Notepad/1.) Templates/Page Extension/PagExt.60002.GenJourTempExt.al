pageextension 60002 GenJonTemExt extends "General Journal Templates"
{
    layout
    {

        addafter("Bal. Account No.")
        {
            field("Sub Type"; Rec."Sub Type")
            {
                ApplicationArea = all;
            }

            field("Order Template Code"; Rec."Order Template Code")
            {
                ApplicationArea = All;
            }

            field("Template Convert"; Rec."Template Convert")
            {
                ApplicationArea = All;
            }

            field("Security Center Codes"; Rec."Security Center Codes")
            {
                ApplicationArea = All;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
            }
            field("Page ID1"; Rec."Page ID")
            {
                ApplicationArea = All;
                Caption = '"Page ID';
            }
            field("Source Code1"; Rec."Source Code")
            {
                ApplicationArea = All;
                Caption = 'Source Code';
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
            }

        }
    }
}