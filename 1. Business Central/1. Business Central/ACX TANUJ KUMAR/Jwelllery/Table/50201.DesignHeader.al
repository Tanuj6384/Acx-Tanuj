table 50201 DesignHeader
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "DESIGN No"; Code[30])
        {
            Caption = 'Design No.';
        }
        field(2; "DESIGN NAME"; Code[60])
        {
            Caption = 'Design Name';
        }
        field(3; "DESIGN IMAGE"; Media)
        {
            Caption = 'Design Image';
            ExtendedDatatype = None;
        }
        field(4; "VEND ACCOUNT"; Code[20])
        {
            TableRelation = Vendor;
            Caption = 'Vendor Account';
        }
        field(5; "VEND DESIGN NO"; Code[20])
        {
            Caption = 'Vendor Design No.';
        }
        field(6; "ORNAMENT CATEGORY CODE"; Code[20])
        {
            // TableRelation = "Ornament Category";
            Caption = 'Ornament Category Code';
        }
        field(7; "ORNAMENT SUB CATEGORY CODE1"; Code[20])
        {
            Caption = 'ORNAMENT SUB CATEGORY CODE1';
        }
        field(8; DEPARTMENT; Code[20])
        {
            Caption = 'Department';

        }
        field(9; "COLLECTION CODE"; Code[30])
        {
            // TableRelation = "Acx Collections "."COLLECTION CODE" where(ACTIVE = filter(true));
            Caption = 'Collection Code';
        }
        field(10; "SECTION ID"; Code[20])
        {
            Caption = 'Section ID';
        }
        field(11; "BRAND ID"; Code[20])
        {
            Caption = 'Brand ID';
        }
        field(12; "STYLE CODE"; Code[10])
        {
            Caption = 'Style Code';
        }
        field(13; "THEME CODE"; Code[10])
        {
            Caption = 'Theme Code';
        }
        field(14; "SAMPLE DESIGN"; Boolean)
        {
            Caption = 'Sample Design';
        }
        field(15; "DESIGNER CODE"; Code[20])
        {
            Caption = 'Designer Code';
        }
        field(16; "APPROVER CODE"; Text[100])
        {
            Caption = 'Approver Code';
        }
        field(17; STATUS; Option)
        {
            OptionMembers = "Open","Released","Closed","Hold";
            Caption = 'Status';
        }
        field(18; "ITEM ID"; Code[20])
        {
            Caption = 'Item ID';
        }
        field(19; "VENDOR TYPE"; Option)
        {
            Caption = 'Vendor Type';
            OptionCaption = ' ,Karigar,Hall Marker,Trade Purchase Vendor,Trade Purchase Vendor,Certificate Vendor';
            OptionMembers = " ","Karigar","Hall Marker","Trade Purchase Vendor","Certificate Vendor";
            
        }
        field(20; "ITEM TYPE CODE"; Code[10])
        {
            Caption = 'Item Type Code';
        }
        field(21; "ISGOSS IP"; Boolean)
        {
            Caption = 'Is Goss Ip';
        }
        // field(22; "REFERENCE ID"; Code[10])
        // {
        //     Caption = 'Reference ID';
        // }
        field(23; "CUSTOMIZED DESIGN"; Boolean)
        {
            Caption = 'Customized Design';
        }
        field(24; "ONLINE DESIGN"; Boolean)
        {
            Caption = 'Online Design';
        }
        // field(25; "UPLOAD IMAGES FTP"; Decimal)
        // {
        //     Caption = 'Upload Images FTP';
        // }
        field(26; "VENDOR CATEGORY"; Code[20])
        {
            Caption = 'Vendor Category';
            // TableRelation= tk
        }
        field(27; "IS IMAGE UPLOADED"; Boolean)
        {
            Caption = 'Is Image Uploaded';
        }
        field(28; "Vendor Document No."; Code[40])
        {
            Caption = 'Vendor Document No.';
        }
        field(29; "IS DesignVisible"; Boolean)
        {
            Caption = 'IS Design Visible';
        }
        field(30; "Design Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "DESIGN No")
        {
            Clustered = true;
        }

    }


    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}