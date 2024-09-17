report 50001 myreport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'tannuj..rdl';
    Caption = 'Tanuj report';



    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(Posting_Date; "Posting Date")
            {

            }


            column(Item_No_; "No.")
            {

            }
            column(Lot_No_; "Amount")
            {

            }
            column(Document_Date; "Document Date") { }
            column(Description; "No.") { }


        }
    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {
    //                     ApplicationArea = All;

    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(ActionName)
    //             {
    //                 ApplicationArea = All;

    //             }
    //         }
    //     }
    // }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = Excel;
    //         LayoutFile = 'mySpreadsheet.xlsx';
    //     }
    // }
trigger OnPreReport()
var
    myInt: Integer;
begin
    
end;
    var
        myInt: Integer;
        range: Integer;
        A: Record "Report Printer";
}