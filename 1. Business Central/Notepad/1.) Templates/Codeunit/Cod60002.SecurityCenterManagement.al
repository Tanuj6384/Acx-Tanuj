codeunit 60002 "Security Center Management"
{
    Permissions = tabledata "User Setup" = rm,
        tabledata Customer = rm,
        tabledata Vendor = rm,
        tabledata "G/L Account" = rm,
        tabledata Item = rm,
        tabledata "Bank Account" = rm,
        // tabledata "LSC Store" = rm,
        tabledata Location = rm,
        tabledata "No. Series" = rm,
        tabledata "No. Series Relationship" = rm,
        tabledata "Gen. Journal Template" = rm,
        tabledata "Item Journal Template" = rm,
        tabledata "Production BOM Header" = rm,
        tabledata "Purchase Header" = rm,
        tabledata "Production Order" = rm,
        tabledata "Gen. Journal Line" = rm,
        tabledata "Item Journal Line" = rm,
        tabledata "Sales Header" = rm;

    trigger OnRun()
    begin
    end;

    procedure GetSecurityFilter(VAR UserSecurityCtr: Code[20];
    VAR SecurityCtrGD1: Code[20])
    begin
        UserSecurityCtr := '';
        SecurityCtrGD1 := '';
        IF (UserSetup.GET(USERID)) AND (USERID <> '') THEN BEGIN
            IF UserSetup."Security Center Filter" <> '' THEN BEGIN
                SecurityCenter.GET(UserSetup."Security Center Filter");
                SecurityCenter.TESTFIELD("Global Dimension 1 Code");
                UserSecurityCtr := UserSetup."Security Center Filter";
                SecurityCtrGD1 := SecurityCenter."Global Dimension 1 Code";
            END;
        END;
    end;

    
    /////////////////////////////Abhishek /////////////////////
    // procedure ApplyStoreSecurity(VAR lrecStore: Record "LSC Store";
    // VAR cdSecurityCtr: Code[20];
    // VAR cdSecurityCtrGD1: Code[20])
    // begin
    //     GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
    //     IF cdSecurityCtr <> '' THEN BEGIN
    //         lrecStore.FILTERGROUP(2);
    //         cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
    //         lrecStore.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
    //         lrecStore.FILTERGROUP(0);
    //     END;
    // end;         //Abhishek cmted 

    procedure ApplyLocSecurity(VAR lrecLocation: Record Location;
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecLocation.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecLocation.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecLocation.FILTERGROUP(0);
        END;
    end;

     

    procedure ApplyCustSecurity(VAR lrecCustomer: Record Customer;
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecCustomer.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecCustomer.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecCustomer.FILTERGROUP(0);
        END;
    end;

    procedure ApplyVendSecurity(VAR lrecVendor: Record Vendor;
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecVendor.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecVendor.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecVendor.FILTERGROUP(0);
        END;
    end;

    procedure ApplyGLAccSecurity(VAR lrecGLAcc: Record "G/L Account";
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecGLAcc.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecGLAcc.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecGLAcc.FILTERGROUP(0);
        END;
    end;

    procedure ApplyItemSecurity(VAR lrecItem: Record Item;
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecItem.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecItem.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecItem.FILTERGROUP(0);
        END;
    end;

    procedure ApplyBankAccSecurity(VAR lrecBankAcc: Record "Bank Account";
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecBankAcc.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecBankAcc.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecBankAcc.FILTERGROUP(0);
        END;
    end;

    procedure ApplyNoSeriesSecurity(VAR lrecNoSeries: Record "No. Series";
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecNoSeries.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecNoSeries.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecNoSeries.FILTERGROUP(0);
        END;
    end;

    procedure ApplyNoSeriesRelSecurity(VAR lrecNoSeriesRel: Record "No. Series Relationship";
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecNoSeriesRel.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecNoSeriesRel.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecNoSeriesRel.FILTERGROUP(0);
        END;
    end;

    procedure ApplyGenJnlTmplSecurity(VAR lrecGenJnlTemplate: Record "Gen. Journal Template";
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecGenJnlTemplate.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecGenJnlTemplate.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecGenJnlTemplate.FILTERGROUP(0);
        END;
    end;

    procedure ApplyItemJnlTmplSecurity(VAR lrecItemJnlTemplate: Record "Item Journal Template";
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecItemJnlTemplate.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecItemJnlTemplate.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecItemJnlTemplate.FILTERGROUP(0);
        END;
    end;

    procedure ApplyProdBOMSecurity(VAR IrecProductionBOMHeader: Record "Production BOM Header";
    VAR cdSecurityCtr: Code[20];
    VAR cdSecurityCtrGD1: Code[20])
    begin
        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            IrecProductionBOMHeader.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            IrecProductionBOMHeader.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            IrecProductionBOMHeader.FILTERGROUP(0);
        END;
    end;
    /*
    procedure ApplyTransferSecurity(VAR lrecTransfer: Record "Transfer Header"; VAR cdSecurityCtr: Code[20]; VAR cdSecurityCtrGD1: Code[20])
    begin

        GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
        IF cdSecurityCtr <> '' THEN BEGIN
            lrecTransfer.FILTERGROUP(2);
            cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
            lrecTransfer.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
            lrecTransfer.FILTERGROUP(0);
        END;
    end;

        procedure ApplyPurchaseSecurity(VAR lrecPurchase: Record "Purchase Header"; VAR cdSecurityCtr: Code[20]; VAR cdSecurityCtrGD1: Code[20])
        begin
            GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
            IF cdSecurityCtr <> '' THEN BEGIN
                lrecPurchase.FILTERGROUP(2);
                cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
                lrecPurchase.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
                lrecPurchase.FILTERGROUP(0);
            END;
        end;

        procedure ApplyTaxJnlBatchSecurity(VAR recTaxJnlTemplate: Record "Tax Journal Batch"; VAR cdSecurityCtr: Code[20]; VAR cdSecurityCtrGD1: Code[20])
        begin

            GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
            IF cdSecurityCtr <> '' THEN BEGIN
                recTaxJnlTemplate.FILTERGROUP(2);
                cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
                recTaxJnlTemplate.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
                recTaxJnlTemplate.FILTERGROUP(0);
            END;
        end;

        procedure ApplyTaxJnlTmplSecurity(VAR recTaxJnlTemplate: Record "Tax Journal Template"; VAR cdSecurityCtr: Code[20]; VAR cdSecurityCtrGD1: Code[20])
        begin

            GetSecurityFilter(cdSecurityCtr, cdSecurityCtrGD1);
            IF cdSecurityCtr <> '' THEN BEGIN
                recTaxJnlTemplate.FILTERGROUP(2);
                cdSecurityCtr := '*;' + cdSecurityCtr + ';*';
                recTaxJnlTemplate.SETFILTER("Security Center Codes", '%1|%2', cdSecurityCtr, cdSecurityCtrGD1);
                recTaxJnlTemplate.FILTERGROUP(0);
            END;
        end;
        */
    var
        UserMgt: Codeunit "User Setup Management";
        SecurityCenter: Record "Security Centers";
        UserSetup: Record "User Setup";
}
