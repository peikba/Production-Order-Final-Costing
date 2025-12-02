report 79100 "BAC Prod. Order Final Costing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BAC Prod. Order - Final Costing.rdlc';
    Caption = 'Prod. Order - Final Costing';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //TODO Check på flere niveauer 
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.");
            RequestFilterFields = Status, "No.", "Source Type", "Source No.";
            column(TodayFormatted; Format(Today(), 0, 4))
            {
            }
            column(CompanyName; CompanyName())
            {
            }
            column(ProdOrderTableCaptionFilter; TableCaption() + ':' + ProdOrderFilter)
            {
            }
            column(ProdOrderFilter; ProdOrderFilter)
            {
            }
            column(No_ProdOrder; "No.")
            {
            }
            column(Desc_ProdOrder; Description)
            {
            }
            column(SourceNo_ProdOrder; "Source No.")
            {
                IncludeCaption = true;
            }
            column(Qty_ProdOrder; Quantity)
            {
                IncludeCaption = true;
            }
            column(ProdOrderDetailedCalcCaption; ProdOrderDetailedCalcCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(LineType; LineType)
            {
            }
            column(SubAssemblyItemCap; SubAssemblyItemCap)
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Line No.");
                column(LineNo_ProdOrderLine; "Line No.")
                {
                }
                column(ItemNo_ProdOrderLine; "Prod. Order Line"."Item No.")
                {
                    IncludeCaption = true;
                }
                column(Description_ProdOrderLine; "Prod. Order Line".Description)
                {
                    IncludeCaption = true;
                }
                column(Quantity_ProdOrderLine; "Prod. Order Line".Quantity)
                {
                    IncludeCaption = true;
                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Routing Reference No." = field("Line No.");
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                    column(OPNo_ProdOrderRtngLine; "Operation No.")
                    {
                        IncludeCaption = false;
                    }
                    column(OPNo_ProdOrderRtngLineCaption; FieldCaption("Operation No."))
                    {
                    }
                    column(Type_ProdOrderRtngLine; Type)
                    {
                        IncludeCaption = true;
                    }
                    column(No_ProdOrderRtngLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_ProdOrderRtngLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(ExpectedQty_ProdOrderRtngLine; "Setup Time" + ("Run Time" * "Prod. Order Line".Quantity))
                    {
                    }
                    column(ExpecOPCostAmt_ProdOrderRtngLine; "Expected Operation Cost Amt.")
                    {
                        IncludeCaption = true;
                    }
                    column(TotalProductionCostCaption; TotalProductionCostCaptionLbl)
                    {
                    }
                    column(RealizedTimeAmount; RealizedTimeAmount)
                    {
                    }
                    column(RealizedTimeQty; RealizedTimeQty)
                    {
                    }

                    trigger OnAfterGetRecord();
                    var
                        locCLE: Record "Capacity Ledger Entry";
                    begin
                        Clear(RealizedTimeAmount);
                        Clear(RealizedTimeQty);
                        locCLE.SetRange("Order Type", locCLE."Order Type"::Production);
                        locCLE.SetRange("Order No.", "Prod. Order Routing Line"."Prod. Order No.");
                        locCLE.SetRange("Order Line No.", "Prod. Order Routing Line"."Routing Reference No.");
                        locCLE.SetRange("Operation No.", "Prod. Order Routing Line"."Operation No.");
                        locCLE.SetRange(Type, "Prod. Order Routing Line".Type);
                        locCLE.SetRange("No.", "Prod. Order Routing Line"."No.");
                        if locCLE.FindSet() then
                            repeat
                                locCLE.CalcFields("Direct Cost");
                                RealizedTimeAmount += locCLE."Direct Cost";
                                RealizedTimeQty += locCLE."Run Time" + locCLE."Setup Time";
                            until Next() = 0;
                        LineType := LineType::Capacity;
                    end;
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(ItemNo_ProdOrderComp; "Item No.")
                    {
                        IncludeCaption = false;
                    }
                    column(ItemNo_ProdOrderCompCaption; FieldCaption("Item No."))
                    {
                    }
                    column(Desc_ProdOrderComp; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(RtngLinkCode_ProdOrderComp; "Routing Link Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ExpectedQty_ProdOrderComp; "Expected Quantity")
                    {
                        IncludeCaption = true;
                    }
                    column(CostAmt_ProdOrderComp; "Cost Amount")
                    {
                        IncludeCaption = true;
                    }
                    column(UnitCost_ProdOrderComp; "Unit Cost")
                    {
                        IncludeCaption = true;
                    }
                    column(TotalMaterialCostCaption; TotalMaterialCostCaptionLbl)
                    {
                    }
                    column(RealizedConsumptionQty; RealizedConsumptionQty)
                    {
                    }
                    column(RealizedConsumptionAmt; RealizedConsumptionAmt)
                    {
                    }
                    column(SubAssemblyItem; SubAssemblyItem)
                    {
                    }

                    trigger OnAfterGetRecord();
                    var
                        locILE: Record "Item Ledger Entry";
                        locPOLine: Record "Prod. Order Line";
                    begin
                        Clear(RealizedConsumptionAmt);
                        Clear(RealizedConsumptionQty);
                        locILE.SetRange("Order Type", locILE."Order Type"::Production);
                        locILE.SetRange("Order No.", "Prod. Order Component"."Prod. Order No.");
                        locILE.SetRange("Order Line No.", "Prod. Order Component"."Prod. Order Line No.");
                        locILE.SetRange("Prod. Order Comp. Line No.", "Prod. Order Component"."Line No.");
                        if locILE.FindSet() then
                            repeat
                                RealizedConsumptionQty -= Quantity;
                                locILE.CalcFields("Cost Amount (Actual)", "Cost Amount (Non-Invtbl.)");
                                RealizedConsumptionAmt -= (locILE."Cost Amount (Actual)" + locILE."Cost Amount (Non-Invtbl.)");
                            until Next() = 0;
                        LineType := LineType::Consumption;

                        locPOLine.SetRange(Status, Status);
                        locPOLine.SetRange("Prod. Order No.", "Prod. Order No.");
                        locPOLine.SetRange("Item No.", "Item No.");
                        if not locPOLine.IsEmpty() then
                            SubAssemblyItem := '*'
                        else
                            SubAssemblyItem := '';

                        if SubAssemblyItem <> '' then
                            SubAssemblyItemCap := SubAssemblyItemTxt;
                    end;

                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Order No." = field("Prod. Order No."), "Order Line No." = field("Line No.");
                    DataItemTableView = sorting("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.") where("Entry Type" = const(Consumption), "Order Type" = const(Production), "Prod. Order Comp. Line No." = const(0));
                    column(ItemNo_ItemLedgerEntry; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_ItemLedgerEntry; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_ItemLedgerEntry; -Quantity)
                    {
                    }
                    column(CostAmountActual_ItemLedgerEntry; -"Cost Amount (Actual)" - "Cost Amount (Non-Invtbl.)")
                    {
                    }

                    trigger OnAfterGetRecord();
                    var
                        Item: Record Item;
                    begin
                        Item.Get("Item Ledger Entry"."Item No.");
                        Description := Item.Description;
                        CalcFields("Cost Amount (Actual)");
                        LineType := LineType::Consumption;
                    end;
                }
                dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
                {
                    DataItemLink = "Order No." = field("Prod. Order No.");
                    DataItemTableView = sorting("Order Type", "Order No.", "Order Line No.", "Routing No.", "Routing Reference No.", "Operation No.", "Last Output Line") where("Order Type" = const(Production));
                    column(OperationNo_CapacityLedgerEntry; "Capacity Ledger Entry"."Operation No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Type_CapacityLedgerEntry; "Capacity Ledger Entry".Type)
                    {
                        IncludeCaption = true;
                    }
                    column(No_CapacityLedgerEntry; "Capacity Ledger Entry"."No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_CapacityLedgerEntry; "Capacity Ledger Entry".Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_CapacityLedgerEntry; "Capacity Ledger Entry".Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(DirectCost_CapacityLedgerEntry; "Capacity Ledger Entry"."Direct Cost")
                    {
                        IncludeCaption = true;
                    }
                    column(OverheadCost_CapacityLedgerEntry; "Capacity Ledger Entry"."Overhead Cost")
                    {
                        IncludeCaption = true;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if IncludedInRoutingLine("Capacity Ledger Entry") then
                            CurrReport.Skip();

                        LineType := LineType::Capacity;
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 1;
                    column(SingleLevelMfgOvhd; SingleLevelMfgOvhd)
                    {
                    }
                    column(ProdOrderCompOPCostAmt; "Prod. Order Component"."Cost Amount" + "Prod. Order Routing Line"."Expected Operation Cost Amt.")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalProdCostCaption; TotalProdCostCaptionLbl)
                    {
                    }
                    column(TotalMterlCostCaption; TotalMterlCostCaptionLbl)
                    {
                    }
                    column(TotalCostCaption; TotalCostCaptionLbl)
                    {
                    }
                    column(SingleLevelMfgOvhdCaption; SingleLevelMfgOvhdCaptionLbl)
                    {
                    }
                    column(RealizedManufOverheadAmt; RealizedManufOverheadAmt)
                    {
                    }
                }

                trigger OnAfterGetRecord();
                var
                    Item: Record Item;
                begin
                    Item.Get("Item No.");
                    SingleLevelMfgOvhd := Item."Single-Level Mfg. Ovhd Cost" * Quantity;
                    RealizedManufOverheadAmt := "Overhead Rate" * "Finished Quantity";
                end;
            }

            trigger OnPreDataItem();
            begin
                ProdOrderFilter := CopyStr(GetFilters(), 1, MaxStrLen(ProdOrderFilter));
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }
    labels
    {
        ExpectedQtyTxt = 'Exp. Qty';
        RealizedConsumptionQtyCap = 'Realized Cons. Qty';
        RealizedConsumptionAmtCap = 'Realized Cons. Amount';
        RealizedTimeAmountCap = 'Realized Time Amount';
        RealizedTimeQtyCap = 'Realized Time Qty';
    }
    var
        ProdOrderFilter: Text[250];
        ProdOrderDetailedCalcCaptionLbl: Label 'Prod. Order - Final Costing';
        CurrReportPageNoCaptionLbl: Label 'Page';
        TotalProductionCostCaptionLbl: Label 'Total Production Cost';
        TotalMaterialCostCaptionLbl: Label 'Total Material Cost';
        TotalProdCostCaptionLbl: Label 'Total Production Cost';
        TotalMterlCostCaptionLbl: Label 'Total Material Cost';
        TotalCostCaptionLbl: Label 'Total Cost';
        RealizedTimeAmount: Decimal;
        RealizedConsumptionAmt: Decimal;
        RealizedConsumptionQty: Decimal;
        LineType: Option Capacity,Consumption;
        SingleLevelMfgOvhdCaptionLbl: Label 'Single-Level Mfg. Overhead Cost';
        SingleLevelMfgOvhd: Decimal;
        RealizedTimeQty: Decimal;
        RealizedManufOverheadAmt: Decimal;
        SubAssemblyItem: Text[2];
        SubAssemblyItemCap: Text[250];
        SubAssemblyItemTxt: Label '* The cost of the sub assembly component origins from the item card';

    procedure IncludedInRoutingLine(CapacityLedgerEntry: Record "Capacity Ledger Entry"): Boolean;
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        ProdOrderRoutingLine.SetFilter(Status, '%1|%2', ProdOrderRoutingLine.Status::Released, ProdOrderRoutingLine.Status::Finished);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", CapacityLedgerEntry."Order No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", CapacityLedgerEntry."Order Line No.");
        ProdOrderRoutingLine.SetRange("Operation No.", CapacityLedgerEntry."Operation No.");
        ProdOrderRoutingLine.SetRange(Type, CapacityLedgerEntry.Type);
        ProdOrderRoutingLine.SetRange("No.", CapacityLedgerEntry."No.");
        exit(not ProdOrderRoutingLine.IsEmpty());
    end;
}

