page 50004 Extra
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Extra;
    Editable = true;

    layout
    {
        area(Content)
        {
            group("Student Details")
            {

                field("Roll No."; Rec."Roll No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Mobile No"; Rec."Mobile No")
                {
                    ApplicationArea = All;
                }
                field(Love; Rec.Love)
                {
                    ApplicationArea = All;
                }
            }

            group("Employe Details")
            {
                
                field("Employe Id"; Rec."Employe Id")
                {
                    ApplicationArea = All;
                }

                field("Employe Name"; Rec."Employe Name")
                {
                    ApplicationArea = all;
                }
                field("Employe Number"; Rec."Employe Number")
                {
                    ApplicationArea = all;
                }
                field("Current Status"; Rec."Current Status")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}