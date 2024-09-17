page 50002 StudentList
{
    ApplicationArea = All;
    Caption = 'Student Master';
    PageType = List;
    SourceTable = StudentTable;
    UsageCategory = Lists;
    CardPageId = StudentCard;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Addmission No."; Rec."Addmission No.")
                {
                    ToolTip = 'Specifies the value of the Addmission No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Parent Name"; Rec."Parent Name")
                {
                    ToolTip = 'Specifies the value of the Parent Name field.';
                }
                field(DOB; Rec.DOB)
                {
                    ToolTip = 'Specifies the value of the DOB field.';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(Address2; Rec.Address2)
                {
                    ToolTip = 'Specifies the value of the Address2 field.';
                }
                field(PostalCode; Rec.PostalCode)
                {
                    ToolTip = 'Specifies the value of the PostalCode field.';
                }
                field(city; Rec.city)
                {
                    ToolTip = 'Specifies the value of the city field.';
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile No. field.';
                }
                field(Transportation; Rec.Transportation)
                {
                    ToolTip = 'Specifies the value of the Transportation field.';
                }
                field(class; Rec.class)
                {
                    ToolTip = 'Specifies the value of the class field.';
                }
                field(balance; Rec.balance)
                {
                    ToolTip = 'Specifies the value of the balance field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}
