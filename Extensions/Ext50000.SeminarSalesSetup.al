// Rozszerzenie tabeli "Sales & Receivables Setup"
// Służy do przechowywania globalnych ustawień dotyczących zarządzania szkoleniami (Seminar Management)
// Numer rozszerzenia 50000 wskazuje, że należy ono do puli numeracji klienta
tableextension 50000 "Seminar Sales Setup Ext" extends "Sales & Receivables Setup"
{
    // Sekcja fields pozwala na definiowanie nowych pól dołączanych do standardowej tabeli
    fields
    {
        // Nowe pole "G/L Account No." (Numer konta KG) z identyfikatorem 50000. Typ: Code[20].
        // Będzie ono wykorzystywane do księgowania przychodów/kosztów ze szkoleń w księdze głównej.
        field(50000; "G/L Account No."; Code[20])
        {
            // Etykieta przyjazna dla użytkownika, widoczna w interfejsie
            Caption = 'G/L Account No.';
            // Relacja do tabeli "G/L Account" (Konto KG). Zapewnia integralność referencyjną,
            // dając pewność, że użytkownik z poziomu UI może wybrać tylko istniejące konto, a nie przypadkowy ciąg znaków.
            TableRelation = "G/L Account";
        }
    }
}
