report 50005 "InvoiceDetails"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'InvoiceDetails';


    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            // column()
            // {

            // }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(PrintToExcel; PrintToExcel)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

    }


    trigger OnInitReport()
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
    end;

    trigger OnPreReport()
    begin
        IF PrintToExcel then
            MakeHeader();
    end;

    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
            CreateExcelbook;
    end;

    local procedure MakeHeader()
    var
        myInt: Integer;
    begin
        // TempExcelBuffer.SetUseInfoSheet;  Don't know yet
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Customer No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeBody()
    var
        myInt: Integer;
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Sales Invoice Header"."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Sales Invoice Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn("Sales Invoice Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn("Sales Invoice Header".Amount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
    end;

    procedure CreateExcelbook()
    begin
        TempExcelBuffer.CreateNewBook('Tanuj');
        TempExcelBuffer.WriteSheet('Tanuj', CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Tanuj');
        TempExcelBuffer.OpenExcel();
    end;


    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
}