tableextension 50000 "Seminar Sales Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
    }
}
