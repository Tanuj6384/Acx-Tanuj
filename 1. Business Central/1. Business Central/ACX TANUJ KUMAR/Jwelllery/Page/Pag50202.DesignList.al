page 50202 DesignList
{
    ApplicationArea = All;
    Caption = 'DesignList';
    PageType = List;
    SourceTable = DesignHeader;
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("DESIGN No"; Rec."DESIGN No")
                {
                    ToolTip = 'Specifies the value of the Design No. field.', Comment = '%';
                }
                field("DESIGN NAME"; Rec."DESIGN NAME")
                {
                    ToolTip = 'Specifies the value of the Design Name field.', Comment = '%';
                }
                field("DESIGN IMAGE"; Rec."DESIGN IMAGE")
                {
                    ToolTip = 'Specifies the value of the Design Image field.', Comment = '%';
                }
                field("VEND ACCOUNT"; Rec."VEND ACCOUNT")
                {
                    ToolTip = 'Specifies the value of the Vendor Account field.', Comment = '%';
                }
                field("VEND DESIGN NO"; Rec."VEND DESIGN NO")
                {
                    ToolTip = 'Specifies the value of the Vendor Design No. field.', Comment = '%';
                }
                field("ORNAMENT CATEGORY CODE"; Rec."ORNAMENT CATEGORY CODE")
                {
                    ToolTip = 'Specifies the value of the Ornament Category Code field.', Comment = '%';
                }
                field("ORNAMENT SUB CATEGORY CODE1"; Rec."ORNAMENT SUB CATEGORY CODE1")
                {
                    ToolTip = 'Specifies the value of the ORNAMENT SUB CATEGORY CODE1 field.', Comment = '%';
                }
                field(DEPARTMENT; Rec.DEPARTMENT)
                {
                    ToolTip = 'Specifies the value of the Department field.', Comment = '%';
                }
                field("COLLECTION CODE"; Rec."COLLECTION CODE")
                {
                    ToolTip = 'Specifies the value of the Collection Code field.', Comment = '%';
                }
                field("SECTION ID"; Rec."SECTION ID")
                {
                    ToolTip = 'Specifies the value of the Section ID field.', Comment = '%';
                }
                field("BRAND ID"; Rec."BRAND ID")
                {
                    ToolTip = 'Specifies the value of the Brand ID field.', Comment = '%';
                }
                field("STYLE CODE"; Rec."STYLE CODE")
                {
                    ToolTip = 'Specifies the value of the Style Code field.', Comment = '%';
                }
                field("THEME CODE"; Rec."THEME CODE")
                {
                    ToolTip = 'Specifies the value of the Theme Code field.', Comment = '%';
                }
                field("SAMPLE DESIGN"; Rec."SAMPLE DESIGN")
                {
                    ToolTip = 'Specifies the value of the Sample Design field.', Comment = '%';
                }
                field("DESIGNER CODE"; Rec."DESIGNER CODE")
                {
                    ToolTip = 'Specifies the value of the Designer Code field.', Comment = '%';
                }
                field("APPROVER CODE"; Rec."APPROVER CODE")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.', Comment = '%';
                }
                field(STATUS; Rec.STATUS)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("ITEM ID"; Rec."ITEM ID")
                {
                    ToolTip = 'Specifies the value of the Item ID field.', Comment = '%';
                }
                field("VENDOR TYPE"; Rec."VENDOR TYPE")
                {
                    ToolTip = 'Specifies the value of the Vendor Type field.', Comment = '%';
                }
                field("ITEM TYPE CODE"; Rec."ITEM TYPE CODE")
                {
                    ToolTip = 'Specifies the value of the Item Type Code field.', Comment = '%';
                }
                field("ISGOSS IP"; Rec."ISGOSS IP")
                {
                    ToolTip = 'Specifies the value of the Is Goss Ip field.', Comment = '%';
                }
                field("CUSTOMIZED DESIGN"; Rec."CUSTOMIZED DESIGN")
                {
                    ToolTip = 'Specifies the value of the Customized Design field.', Comment = '%';
                }
                field("ONLINE DESIGN"; Rec."ONLINE DESIGN")
                {
                    ToolTip = 'Specifies the value of the Online Design field.', Comment = '%';
                }
                field("VENDOR CATEGORY"; Rec."VENDOR CATEGORY")
                {
                    ToolTip = 'Specifies the value of the Vendor Category field.', Comment = '%';
                }
                field("IS IMAGE UPLOADED"; Rec."IS IMAGE UPLOADED")
                {
                    ToolTip = 'Specifies the value of the Is Image Uploaded field.', Comment = '%';
                }
                field("Vendor Document No."; Rec."Vendor Document No.")
                {
                    ToolTip = 'Specifies the value of the Vendor Document No. field.', Comment = '%';
                }
                field("IS DesignVisible"; Rec."IS DesignVisible")
                {
                    ToolTip = 'Specifies the value of the IS Design Visible field.', Comment = '%';
                }
                field("Design Line No"; Rec."Design Line No")
                {
                    ToolTip = 'Specifies the value of the Design Line No field.', Comment = '%';
                }
            }
        }
    }
}
