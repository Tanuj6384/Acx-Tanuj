page 80001 GroceryPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = GroceryStore;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.id)
                {
                    ApplicationArea = All;

                }
                field(category; Rec.category)
                {
                    ApplicationArea = all;
                }
                field(name; Rec.name)
                {
                    ApplicationArea = all;
                }
                field(inStock; Rec.inStock)
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
            action("Grocery API")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    CU: codeunit groceryCodeunit;
                begin
                    cu.CallAPI(rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}