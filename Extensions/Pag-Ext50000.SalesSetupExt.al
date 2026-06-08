// Rozszerzenie strony "Sales & Receivables Setup"
// Umożliwia użytkownikom dodawanie ustawień dla modułu szkoleń bezpośrednio na karcie ustawień sprzedaży.
pageextension 50000 "Sales Setup Extension" extends "Sales & Receivables Setup"
{
    // Sekcja układu (layout) odpowiada za definiowanie widocznych elementów w interfejsie użytkownika
    layout
    {
        // Akcja addlast informuje system, aby nowa sekcja została dodana na samym końcu bloku "content" (głównego widoku)
        addlast(content)
        {
            // Kontener grupowy, który spina razem wszystkie powiązane wizualnie pola ustawień szkoleń
            group("Seminar Management")
            {
                // Widoczny na ekranie napis nagłówkowy sekcji
                Caption = 'Seminar Management';
                
                // Udostępnienie w interfejsie nowo dodanego pola "G/L Account No." znajdującego się w rekordzie (Rec)
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    // Właściwość ApplicationArea = All sprawia, że to pole jest dostępne w każdym wariancie aplikacji
                    // oraz widoczne na listach wyszukiwania funkcji 'Tell Me' (szukajki).
                    ApplicationArea = All;
                }
            }
        }
    }
}
