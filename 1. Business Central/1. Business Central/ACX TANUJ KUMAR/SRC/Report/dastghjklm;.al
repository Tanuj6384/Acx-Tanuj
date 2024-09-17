report 50199 TanujK
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'tanuj.rdl';
    Caption = 'Tanuj Report 1';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            } 
            column(SNO;SNO) { }

            trigger OnAfterGetRecord()
            begin
                SNO := 0;
                for i := 1 to 200 do begin
                    SNO := i;
                    Message('%1',SNO);
                end;
            end;
        }

    }



    var
        I: Integer;
        SNO: Decimal;
}