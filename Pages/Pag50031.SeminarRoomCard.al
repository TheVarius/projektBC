// Strona "Seminar Room Card" (Kartoteka sali szkoleniowej)
// Pozwala na wprowadzenie z palca od zera nowego obiektu pełniącego rolę lokalizacji szkoleniowej, w której użytkownicy dokonują szkoleń.
page 50031 "Seminar Room Card"
{
    // Określenie sposobu nakładania kontrolek na stronę, układ w formie wytypowanych, rozwiniętych informacji na jednym oknie (Card - format dla Słowników).
    PageType = Card;
    // Tytuł u góry paska z informacją 
    Caption = 'Seminar Room Card';
    // Link relacyjny dopinający tablice wywodzącą się spod "Seminar Room"
    SourceTable = "Seminar Room";

    // Wytyczne interfejsu użytkownika graficznego 
    layout
    {
        // Obszar na wyłączne korzystanie z zawartości właściwych kontrolek dla edycji encji w bazie (Content)
        area(Content)
        {
            // Typowy zabieg podziału na logiczne "Szufladki" ułatwiające szukanie informacji dla danego klienta
            group(General)
            {
                // Widoczna nazwa na tej szufladce w UI 
                Caption = 'General';
                
                // Systemowe wpisanie stałego, unikalnego i narzuconego kodu "ID" danej sali
                field("Code"; Rec."Code")
                {
                    // Dostęp na całym froncie webowym
                    ApplicationArea = All;
                }
                
                // Zrozumiała nazwa tekstowa jak np. "Sala konferencyjna Wawel"
                field("Name"; Rec."Name")
                {
                    // Konieczny znacznik uwidocznienia
                    ApplicationArea = All;
                }
                
                // Część sekcji adresowej dla pierwszej linii budynku
                field("Address"; Rec."Address")
                {
                    // Konieczny znacznik uwidocznienia
                    ApplicationArea = All;
                }

                // Część uzupełniająca (pokój/piętro)
                field("Address 2"; Rec."Address 2")
                {
                    // Wymagany atrybut
                    ApplicationArea = All;
                }
                
                // PNA służący z reguły do triggera onValidate zaciągającego miasto "City" ze słownika globalnego 
                field("Post Code"; Rec."Post Code")
                {
                    // Wymagany atrybut
                    ApplicationArea = All;
                }
                
                // Miejscowość
                field("City"; Rec."City")
                {
                    // Wymagany atrybut
                    ApplicationArea = All;
                }
                
                // Kod kraju np. PL
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    // Wymagany atrybut
                    ApplicationArea = All;
                }
                
                // Bardzo kluczowe z punktu planowania szkoleń miejsce określające fizyczny limit obecności osób 
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    // Zgoda na widoczność z każdego zakamarku programu dla klienta
                    ApplicationArea = All;
                }
                
                // Przełącznik determinujący rodzaj zarządczy "Sala Wewnętrzna Nasza / Zewnętrzna podnajęta"
                field("Internal/External"; Rec."Internal/External")
                {
                    // Ujawnia widok
                    ApplicationArea = All;
                }
            }
            
            // Następna zakładka, oddzielna przestrzeń informacyjna służąca danym technicznym lub namiarom kontaktowym do stróża/dozorcy Sali (Communication)
            group(Communication)
            {
                // Podpis grupy
                Caption = 'Communication';
                
                // Edytor numeru telefonu stacjonarnego lub komórkowego
                field("Phone No."; Rec."Phone No.")
                {
                    // Wyeksponowanie pola z możliwością interakcji
                    ApplicationArea = All;
                }
                
                // Analogiczne, lecz powoli wygaszane pole z logiki starego Dynamics NAV - pod numer dla urządzeń faksowych 
                field("Fax No."; Rec."Fax No.")
                {
                    // Wyeksponowanie pola na żądanie logiki 
                    ApplicationArea = All;
                }
            }
        }
    }
}
