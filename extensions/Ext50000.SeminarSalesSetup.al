tableextension 50000 "Seminar Sales Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "G/L Account No."; Code[20]) //2.4 typ code length 20
        {
            Caption = 'G/L Account No.';
            /* 2.5
            Relacja do tabeli 15 „G/L Account”
            */
            TableRelation = "G/L Account";
        }
    }
}