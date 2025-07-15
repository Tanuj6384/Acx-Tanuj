codeunit 60001 "Gen. Jour. Template Management"
{
    Permissions = tabledata "Gen. Journal Template" = rm,
        tabledata "Gen. Journal Batch" = rm,
        tabledata "Gen. Journal Line" = rm;

    trigger OnRun()
    begin
    end;

    procedure TemplateSelectionForProduction(PageID: Integer;
 SubType: Enum "Gen. Jour. Template SubType";
 VAR ProdHeader: Record "Production Order";
 VAR JnlSelected: Boolean;
 VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", PageID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Production);
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                ERROR('You must first define Template - ' + FORMAT(SubType));
            1:
                BEGIN
                    GenJnlTemplate.FIND('-');
                    CheckNoSeries(GenJnlTemplate);
                END;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            CheckNoSeries(GenJnlTemplate);
            ProdHeader.FILTERGROUP := 2;
            ProdHeader.SETFILTER("Gen. Journal Template Code", GenJnlTemplate.Name);
            ProdHeader.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;




    procedure TemplateSelectionForTransfer(FormID: Integer;
     SubType: Enum "Gen. Jour. Template SubType";
   VAR TransferHeader: Record "Transfer Header";
   VAR JnlSelected: Boolean;
   VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Transfer);
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                BEGIN
                    GenJnlTemplate.INIT;
                    GenJnlTemplate.Type := GenJnlTemplate.Type::Transfer;
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := FALSE;
                    GenJnlTemplate.Name := 'T-' + COPYSTR(FORMAT(GenJnlTemplate."Sub Type"), 1, 8);
                    GenJnlTemplate.Description := STRSUBSTNO(Text0011, GenJnlTemplate.Type);
                    GenJnlTemplate.VALIDATE(Type);
                    GenJnlTemplate.VALIDATE("Sub Type");
                    GenJnlTemplate.INSERT;
                    GenJnlTemplate.TESTFIELD("Source Code");
                END;
            1:
                GenJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            TransferHeader.FILTERGROUP := 2;
            TransferHeader.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            TransferHeader.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;

    procedure TemplateSelectionForFirmPlan(FormID: Integer;
     SubType: Enum "Gen. Jour. Template SubType";
 //    VAR TransferHeader: Record "Transfer Header";
 VAR ProdHeader: Record "Production Order";
   VAR JnlSelected: Boolean;
   VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Production);
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                BEGIN
                    GenJnlTemplate.INIT;
                    GenJnlTemplate.Type := GenJnlTemplate.Type::Production;
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := FALSE;
                    GenJnlTemplate.Name := 'F-' + COPYSTR(FORMAT(GenJnlTemplate."Sub Type"), 1, 8);
                    GenJnlTemplate.Description := STRSUBSTNO(Text0011, GenJnlTemplate.Type);
                    GenJnlTemplate.VALIDATE(Type);
                    GenJnlTemplate.VALIDATE("Sub Type");
                    GenJnlTemplate.INSERT;
                    GenJnlTemplate.TESTFIELD("Source Code");
                END;
            1:
                GenJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            ProdHeader.FILTERGROUP := 2;
            ProdHeader.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            ProdHeader.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;


    procedure CheckNoSeries(tmpGenJnlTemplate: Record "Gen. Journal Template")
    begin
        CASE tmpGenJnlTemplate."Sub Type" OF
            tmpGenJnlTemplate."Sub Type"::Ship:
                BEGIN
                    tmpGenJnlTemplate.TESTFIELD("No. Series");
                    tmpGenJnlTemplate.TESTFIELD("Posting Shipment No. Series");
                END;
            tmpGenJnlTemplate."Sub Type"::"Rel. Prod. Order":
                begin
                    tmpGenJnlTemplate.TestField("No. Series");
                end;
        END;
    end;

    procedure TemplateSelectionForPurchase(FormID: Integer;
   SubType: Enum "Gen. Jour. Template SubType";
   VAR PurchaseHeader: Record "Purchase Header";
   VAR JnlSelected: Boolean;
   VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";

    begin
        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Purchases);
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                BEGIN
                    GenJnlTemplate.INIT;
                    GenJnlTemplate.Type := GenJnlTemplate.Type::Purchases;
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := FALSE;
                    GenJnlTemplate.Name := 'S-' + COPYSTR(FORMAT(GenJnlTemplate."Sub Type"), 1, 8);
                    GenJnlTemplate.Description := STRSUBSTNO(Text0011, GenJnlTemplate.Type);
                    GenJnlTemplate.VALIDATE(Type);
                    GenJnlTemplate.VALIDATE("Sub Type");
                    GenJnlTemplate.INSERT;
                    GenJnlTemplate.TESTFIELD("Source Code");
                    //Abhishek   COMMIT;
                END;
            1:
                GenJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            PurchaseHeader.FILTERGROUP := 2;
            PurchaseHeader.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            PurchaseHeader.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;

    procedure TemplateSelectionForSales(FormID: Integer;
   SubType: Enum "Gen. Jour. Template SubType";
   VAR SalesHeader: Record "Sales Header";
   VAR JnlSelected: Boolean;
   VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin

        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Sales);
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                BEGIN
                    GenJnlTemplate.INIT;
                    GenJnlTemplate.Type := GenJnlTemplate.Type::Sales;
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := FALSE;
                    GenJnlTemplate.Name := 'S-' + COPYSTR(FORMAT(GenJnlTemplate."Sub Type"), 1, 8);
                    GenJnlTemplate.Description := STRSUBSTNO(Text0011, GenJnlTemplate.Type);
                    GenJnlTemplate.VALIDATE(Type);
                    GenJnlTemplate.VALIDATE("Sub Type");
                    GenJnlTemplate.INSERT;
                    GenJnlTemplate.TESTFIELD("Source Code");
                    COMMIT;
                END;
            1:
                GenJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            SalesHeader.FILTERGROUP := 2;
            SalesHeader.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            SalesHeader.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;


    procedure TemplateSelectionForFixedAsset(FormID: Integer;
  SubType: Enum "Gen. Jour. Template SubType";
  VAR FixedAsset: Record "Fixed Asset";
  VAR JnlSelected: Boolean;
  VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";

    begin
        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Assets);
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                BEGIN
                    GenJnlTemplate.INIT;
                    GenJnlTemplate.Type := GenJnlTemplate.Type::Assets;
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := FALSE;
                    GenJnlTemplate.Name := 'F-' + COPYSTR(FORMAT(GenJnlTemplate."Sub Type"), 1, 8);
                    GenJnlTemplate.Description := STRSUBSTNO(Text0011, GenJnlTemplate.Type);
                    GenJnlTemplate.VALIDATE(Type);
                    GenJnlTemplate.VALIDATE("Sub Type");
                    GenJnlTemplate.INSERT;
                    GenJnlTemplate.TESTFIELD("Source Code");
                END;
            1:
                GenJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            FixedAsset.FILTERGROUP := 2;
            FixedAsset.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            FixedAsset.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;


    procedure TemplateSelectionForInwardGate(FormID: Integer;
     SubType: Enum "Gen. Jour. Template SubType";
      VAR RecGateEntryHdr: Record "Gate Entry Header";
   VAR JnlSelected: Boolean;
   VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::"Gate Inward");
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                BEGIN
                    GenJnlTemplate.INIT;
                    GenJnlTemplate.Type := GenJnlTemplate.Type::"Gate Inward";
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := FALSE;
                    GenJnlTemplate.Name := 'G-' + COPYSTR(FORMAT(GenJnlTemplate."Sub Type"), 1, 8);
                    GenJnlTemplate.Description := STRSUBSTNO(Text0011, GenJnlTemplate.Type);
                    GenJnlTemplate.VALIDATE(Type);
                    GenJnlTemplate.VALIDATE("Sub Type");
                    GenJnlTemplate.INSERT;
                    GenJnlTemplate.TESTFIELD("Source Code");
                END;
            1:
                GenJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            RecGateEntryHdr.FILTERGROUP := 2;
            RecGateEntryHdr.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            RecGateEntryHdr.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;

    procedure TemplateSelectionForOutwardGate(FormID: Integer;
   SubType: Enum "Gen. Jour. Template SubType";
    VAR RecGateEntryHdr: Record "Gate Entry Header";
 VAR JnlSelected: Boolean;
 VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::"Gate Outward");
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                BEGIN
                    GenJnlTemplate.INIT;
                    GenJnlTemplate.Type := GenJnlTemplate.Type::"Gate Outward";
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := FALSE;
                    GenJnlTemplate.Name := 'G-' + COPYSTR(FORMAT(GenJnlTemplate."Sub Type"), 1, 8);
                    GenJnlTemplate.Description := STRSUBSTNO(Text0011, GenJnlTemplate.Type);
                    GenJnlTemplate.VALIDATE(Type);
                    GenJnlTemplate.VALIDATE("Sub Type");
                    GenJnlTemplate.INSERT;
                    GenJnlTemplate.TESTFIELD("Source Code");
                END;
            1:
                GenJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            RecGateEntryHdr.FILTERGROUP := 2;
            RecGateEntryHdr.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            RecGateEntryHdr.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;

    procedure TemplateSelectionForWarehouseReceipt(FormID: Integer;
        SubType: Enum "Gen. Jour. Template SubType";
         VAR recWareHouseRecptHdr: Record "Warehouse Receipt Header";
      VAR JnlSelected: Boolean;
      VAR GenJnlTemplateCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Warehouse);
        GenJnlTemplate.SETRANGE("Sub Type", SubType);
        CASE GenJnlTemplate.COUNT OF
            0:
                BEGIN
                    GenJnlTemplate.INIT;
                    GenJnlTemplate.Type := GenJnlTemplate.Type::Warehouse;
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := FALSE;
                    GenJnlTemplate.Name := 'W-' + COPYSTR(FORMAT(GenJnlTemplate."Sub Type"), 1, 8);
                    GenJnlTemplate.Description := STRSUBSTNO(Text0011, GenJnlTemplate.Type);
                    GenJnlTemplate.VALIDATE(Type);
                    GenJnlTemplate.VALIDATE("Sub Type");
                    GenJnlTemplate.INSERT;
                    GenJnlTemplate.TESTFIELD("Source Code");
                END;
            1:
                GenJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            recWareHouseRecptHdr.FILTERGROUP := 2;
            recWareHouseRecptHdr.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            recWareHouseRecptHdr.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;


    var
        myInt: Integer;
        Text0011: Label '%1';
        shf: Page "Sales Quote";

}