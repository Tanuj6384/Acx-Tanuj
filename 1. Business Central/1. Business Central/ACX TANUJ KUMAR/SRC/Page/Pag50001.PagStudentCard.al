page 50001 "StudentCard"
{
    ApplicationArea = All;
    RefreshOnActivate = true;
    UsageCategory = Administration;
    Caption = 'Student Card Page';
    PageType = Card;
    SourceTable = StudentTable;
    layout
    {
        area(content)
        {
            group("Student Page")
            {
                Caption = 'Student Page';

                field("Addmission No."; Rec."Addmission No.")
                {
                    ToolTip = 'Specifies the value of the Addmission No. field.';
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    Editable = EditField;
                }
                field("Parent Name"; Rec."Parent Name")
                {
                    ToolTip = 'Specifies the value of the Parent Name field.';
                    Editable = EditField;
                }
                field(DOB; Rec.DOB)
                {
                    ToolTip = 'Specifies the value of the DOB field.';
                    Editable = EditField;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    Editable = EditField;
                }
                field(Address2; Rec.Address2)
                {
                    ToolTip = 'Specifies the value of the Address2 field.';
                    Editable = EditField;
                }
                field(PostalCode; Rec.PostalCode)
                {
                    ToolTip = 'Specifies the value of the PostalCode field.';
                    Editable = EditField;
                }
                field(city; Rec.city)
                {
                    ToolTip = 'Specifies the value of the city field.';
                    Editable = false;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile No. field.';
                    Editable = EditField;
                }
                field(Transportation; Rec.Transportation)
                {
                    ToolTip = 'Specifies the value of the Transportation field.';
                    Editable = EditField;
                }
                field(class; Rec.class)
                {
                    ToolTip = 'Specifies the value of the class field.';
                    Editable = EditField;
                }
                field(balance; Rec.balance)
                {
                    ToolTip = 'Specifies the value of the balance field.';
                    Editable = EditField;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Editable = EditField;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = all;
                }

                field(Lulu; Rec.Lulu)
                {
                    ApplicationArea = all;
                }
            }
            part(StudentLedgerEntries1; StudentLedgerEntries)
            {
                SubPageLink = "Addmission No." = field("Addmission No.");
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            group(Personal)
            {
                Caption = 'Personal';
                field(MyWork; Rec.MyWork)
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


            action(ReOpen)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = OpenWorksheet;
                ApplicationArea = all;
                Caption = 'ReOpen';

                trigger OnAction()
                begin
                    EditField := true;
                end;
            }
            action(Release)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ReleaseDoc;
                ApplicationArea = all;
                Caption = 'Release';

                trigger OnAction()
                begin
                    EditField := false;
                end;
            }
            action(StudentLedgerEntries)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = LedgerBook;
                ApplicationArea = all;
                Caption = 'Student Ledger Entries';

                trigger OnAction()
                begin
                    Clear(recLedgerPage);
                    recLedgerEntries.reset();
                    recLedgerEntries.SetFilter("Addmission No.", Rec."Addmission No.");
                    recLedgerPage.SetTableView(recLedgerEntries);
                    recLedgerPage.LookupMode := True;
                    if (recLedgerPage.RunModal() = Action::LookupOK) then begin
                        recLedgerEntries.SetFilter("Addmission No.", Rec."Addmission No.");
                    end;
                end;
            }

            action(Extra)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Job;
                ApplicationArea = all;
                Caption = 'Extra';

                trigger OnAction()
                begin
                    Page.Run(50004);
                end;
            }
            action(Abhishek)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Job;
                ApplicationArea = all;
                Caption = 'Abhishek';

                trigger OnAction()
                var
                    cod: Codeunit jisdf;
                begin
                    cod.ImportPurchaseInvoice();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Lulu := false;

        if (rec.Status = Rec.Status::Open) then
            EditField := true;
        if (Rec.Status = Rec.Status::Release) then
            EditField := false;
    end;




    var

        EditField: Boolean;
        recLedgerEntries: Record StudentLedgerEntries;
        recLedgerPage: Page StudentLedgerEntries;
}

