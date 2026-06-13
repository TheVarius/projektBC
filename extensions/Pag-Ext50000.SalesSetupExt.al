pageextension 50000 "Sales Setup Extension" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(content)
        {
            group("Seminar Management")
            {
                Caption = 'Seminar Management';
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}