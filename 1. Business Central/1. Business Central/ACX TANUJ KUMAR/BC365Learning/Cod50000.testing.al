codeunit 50000 testing
{
    trigger OnRun()
    var
    begin
        // name();
    end;


    procedure name()
    var
        myInt: Integer;
        i: Integer;

    begin
        for i := 1 to 100 do begin
            Message('Tanuj');
        end;
    end;

}