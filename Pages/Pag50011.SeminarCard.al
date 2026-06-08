// Strona "Seminar Card" (Kartoteka szkolenia)
// Umożliwia dodawanie nowych rekordów do bazy szkoleń, oraz edytowanie ich i przeglądanie ze wszelkimi szczegółami.
// To jedno z najważniejszych narzędzi wprowadzania danych referencyjnych (Słowników).
page 50011 "Seminar Card"
{
    // Określenie typu strony na Card (Kartoteka - jeden rekord na ekranie naraz)
    PageType = Card;
    // Wyświetlany napis na tytule otwartego okna
    Caption = 'Seminar Card';
    // Link do tabeli źródłowej z której ta strona zaciąga kolumny by tworzyć kontrolki
    SourceTable = Seminar;
    // Ważny parametr UI: W tytule okna, oprócz Caption, doklejane są dodatkowo wartości kluczowych pól z rekordu (Code i Name), np. "Seminar Card - BCA-001 · Excel"
    DataCaptionFields = "Code", "Name";

    // Obszar definiujący warstwę prezentacyjną kontrolek tekstowych i liczbowych
    layout
    {
        // Obszar roboczy, główna część strony oddana użytkownikowi pod formularz roboczy
        area(Content)
        {
            // Typowa dla kartotek organizacja w grupy rozwijane (tzw. FastTabs).
            // Ta grupa (General) ma trzymać nadrzędne i w większości obowiązkowe informacje słownikowe.
            group(General)
            {
                // Tytuł na pierwszej belce (Szybka Karta: "Ogólne")
                Caption = 'General';
                
                // Pole z kluczem głównym, pole które ustala się zazwyczaj raz przy powołaniu rekordu i ewentualnie chroni skryptami (OnRename)
                field("Code"; Rec."Code")
                {
                    // Konieczne, by pole było dostarczane przez serwer we wszystkich środowiskach chmurowych (ApplicationArea All)
                    ApplicationArea = All;
                }
                
                // Pole tekstowe do podawania pełnej, opisowej formy szkolenia, widocznej na raportach
                field("Name"; Rec."Name")
                {
                    // Parametry dostępności 
                    ApplicationArea = All;
                }
                
                // Pole pomocnicze do weryfikacji wpisywanego skrótowca (uzupełniane w triggerze Name)
                field("Search Name"; Rec."Search Name")
                {
                    // Konieczne przy kompilacji
                    ApplicationArea = All;
                }
                
                // Pole przypisania czasu na realizację szkolenia przez zespół
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    // Odblokowana strefa
                    ApplicationArea = All;
                }
                
                // Pole podania stałej ceny jednostkowej za jedną zwerbowaną sztukę osoby na to szkolenie 
                field("Seminar Price"; Rec."Seminar Price")
                {
                    // Odblokowana strefa
                    ApplicationArea = All;
                }
                
                // Wprowadzanie ograniczenia wielkości, co by wiedzieć czy nie trzeba anulować w razie małego zainteresowania uczestników 
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    // Konieczne przy kompilacji
                    ApplicationArea = All;
                }
                
                // Wprowadzanie progu odgórnego wyznaczającego limit nałożony na kurs bez odniesienia do konkretnej sali 
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    // Konieczne przy kompilacji
                    ApplicationArea = All;
                }
                
                // Prosty przełącznik (Boolean) służący zamrożeniu i wyłączeniu szkolenia z nowo powoływanych cyklów wyboru 
                field("Blocked"; Rec."Blocked")
                {
                    // Konieczne przy kompilacji
                    ApplicationArea = All;
                }
                
                // Systemowe i nieedytowalne z poziomu tabeli pole dające do zrozumienia, w jakim stopniu te dane są zdezaktualizowane (Zmieniane automatycznie za kulisami)
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    // Przydzielone prawo widoku na panelach klienckich w środowiskach
                    ApplicationArea = All;
                }
            }
        }
    }
}
