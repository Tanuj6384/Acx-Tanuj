tableextension 60027 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(60000; "Cash Discount(Rs in Kg)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60001; "Price Protection Discount(Rs in KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60002; "Other Discount(Rs in KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60004; "Total Cash Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60005; "Total P.P Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }   
        field(60006; "Total Other Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60007; "Billed Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60008; "UOM Conversion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60009; "Price/Pcs"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 3 : 3;
        }
        field(60010; "Discount in UOM"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure".Code;
        }
        field(60011; "All Discount Total"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                ItemUnitOfMeasureRec: Record "Item Unit of Measure";
                SalesLineDiscountRec: Record "Sales Line Discount";
                UnitofMeasure: Record "Unit of Measure";
                CalculateTax: Codeunit "Calculate Tax";
            begin
                if Rec.Type = Rec.Type::Item then begin
                    SalesLineDiscountRec.Reset();
                    SalesLineDiscountRec.SetRange(Code, Rec."No.");
                    SalesLineDiscountRec.SetRange("Sales Code", Rec."Sell-to Customer No.");
                    if SalesLineDiscountRec.FindFirst() then begin
                        Rec."Discount in UOM" := SalesLineDiscountRec."Unit of Measure Code";
                        Rec."Cash Discount(Rs in Kg)" := SalesLineDiscountRec."Cash Discount(Rs in Kg)";
                        Rec."Price Protection Discount(Rs in KG)" := SalesLineDiscountRec."Price Protection Discount(Rs in KG)";
                        Rec."Other Discount(Rs in KG)" := SalesLineDiscountRec."Other Discount(Rs in KG)";
                        // Rec.UpdateAmounts();
                    end;
                end;
            end;
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                ItemUnitOfMeasureRec: Record "Item Unit of Measure";
                salesline: Record "Sales Line";
            begin
                if Rec.Quantity <> 0 then begin
                    if Rec."Document Type" = Rec."Document Type"::Quote then begin
                        Rec."Billed Quantity" := Rec.Quantity * Rec."UOM Conversion";

                        ItemUnitOfMeasureRec.SetRange("Item No.", Rec."No.");
                        ItemUnitOfMeasureRec.SetRange(Code, Rec."Discount in UOM");
                        if ItemUnitOfMeasureRec.FindFirst() then begin
                            if Rec."Billed Quantity" <> 0 then begin
                                Rec."Total Cash Discount" := (Rec."Billed Quantity" / ItemUnitOfMeasureRec."Qty. per Unit of Measure") * Rec."Cash Discount(Rs in Kg)";
                                Rec."Total P.P Discount" := (Rec."Billed Quantity" / ItemUnitOfMeasureRec."Qty. per Unit of Measure") * Rec."Price Protection Discount(Rs in KG)";
                                Rec."Total Other Discount" := (Rec."Billed Quantity" / ItemUnitOfMeasureRec."Qty. per Unit of Measure") * Rec."Other Discount(Rs in KG)";
                                // Rec.Modify();
                            end;
                        end;

                        Rec.Validate("Line Discount Amount", (Rec."Total Cash Discount" + Rec."Total P.P Discount" + Rec."Total Other Discount"));

                        if rec."Billed Quantity" <> 0 then begin
                            Rec."Price/Pcs" := Rec."Line Amount" / rec."Billed Quantity";
                            // Rec.Modify();
                        end;
                    end;
                end else begin
                    Rec."Billed Quantity" := Rec.Quantity * Rec."UOM Conversion";
                    if rec."Billed Quantity" = 0 then begin
                        Rec."Total Cash Discount" := (Rec."Billed Quantity" / ItemUnitOfMeasureRec."Qty. per Unit of Measure") * Rec."Cash Discount(Rs in Kg)";
                        Rec."Total P.P Discount" := (Rec."Billed Quantity" / ItemUnitOfMeasureRec."Qty. per Unit of Measure") * Rec."Price Protection Discount(Rs in KG)";
                        Rec."Total Other Discount" := (Rec."Billed Quantity" / ItemUnitOfMeasureRec."Qty. per Unit of Measure") * Rec."Other Discount(Rs in KG)";
                        Rec."Price/Pcs" := 0;
                        // Rec.Modify();
                    end;
                end;
            end;
        }
        // modify("No.")
        // {
        //     trigger OnAfterValidate()
        //     begin  
        //         SalesLineDiscountRec.Reset();
        //         SalesLineDiscountRec.SetRange(Code, Rec."No.");
        //         SalesLineDiscountRec.SetRange("Sales Code", Rec."Sell-to Customer No.");
        //         if SalesLineDiscountRec.FindFirst() then begin
        //             Rec."Cash Discount(Rs in Kg)" := SalesLineDiscountRec."Cash Discount(Rs in Kg)";
        //             Rec.Modify();
        //         end;
        //     end;
        // }


    }
    trigger OnModify()
    var
        myInt: Integer;
    begin
        // Message('testing');
    end;
}
