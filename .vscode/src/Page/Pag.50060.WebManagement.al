page 50060 "Web Management"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTableTemporary = true;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {

            }
        }
    }

    trigger OnOpenPage()
    var
        WebMangement: Codeunit "Web Management";
    begin
        WebMangement.CreateStockSync();
    end;

}