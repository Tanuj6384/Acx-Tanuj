page 60001 "Security Center"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Security Centers";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Name";Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Address";Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2";Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field("City";Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Post Code";Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code";Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Phone No.";Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Fax No.";Rec."Fax No.")
                {
                    ApplicationArea = All;
                }
                field("Name 2";Rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field("Contact";Rec.Contact)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code";Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code";Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Location Code";Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("County";Rec.County)
                {
                    ApplicationArea = All;
                }
                field("E-Mail";Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Home Page";Rec."Home Page")
                {
                    ApplicationArea = All;
                }
                field("Date Filter";Rec."Date Filter")
                {
                    ApplicationArea = All;
                }
                field("Contract Gain/Loss Amount";Rec."Contract Gain/Loss Amount")
                {
                    ApplicationArea = All;
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

                trigger OnAction()begin
                end;
            }
        }
    }
    var myInt: Integer;
}
