page 70001 ReopenHistory
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Reopen History';
    UsageCategory = Lists;
    SourceTable = ReopenHistory;


    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field("PO No"; Rec."PO No")
                {
                    ApplicationArea = All;
                }
                field("Buy From Vendor Name"; Rec."Buy From Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("Sell To customer Name"; Rec."Sell To customer Name")
                {
                    ApplicationArea = all;
                }
                field("Reason To Reopen"; Rec."Reason To Reopen")
                {
                    ApplicationArea = all;
                }
                field("Reason To Reopen Date"; Rec."Reason To Reopen Date")
                {
                    ApplicationArea = all;
                }
                field("Serial No"; Rec."Serial No")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Direct test")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = XMLFile;


                trigger OnAction()
                begin
                    testing.name();
                end;
            }
            action("Procedure Testing")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = DataEntry;


                trigger OnAction()
                begin
                    NewMSG();
                end;
            }

        }
    }

    var
        myInt: Integer;
        testing: Codeunit testing;
        MyCodeUnit: Codeunit MyCodeUnit;

    procedure NewMSG()
    begin
        // Message('Hi Tanuj Kumar');
        // Message('You Are Happy');
        Error('Nikal');
    end;

    procedure KLMN()
    begin
    KLMN();
    end;

}