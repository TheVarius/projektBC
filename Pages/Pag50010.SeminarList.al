// Strona "Seminar List" (Lista szkoleń)
// Klasyczna lista wyświetlająca skondensowane informacje wyciągnięte ze słownika głównego (Tabela Seminar).
// Umożliwia łatwe wyszukiwanie oraz dostęp w głąb konkretnego wpisu do strony typu Card.
page 50010 "Seminar List"
{
    // Oznacza widoczność we wszystkich strefach aplikacji. Wymagane również, aby okno można było zlokalizować w "Tell Me" po włączeniu wyszukiwania w systemie (ALT+Q).
    ApplicationArea = All;
    // Nagłówek okna widoczny na samej górze
    Caption = 'Seminar List';
    // Typ elementu UI zdefiniowany rygorystycznie pod architekturę Listy kaskadowej elementów
    PageType = List;
    // Powiązanie logiki obiektowej do źródła informacji pobieranego bezpośrednio z modelu tabeli Seminar z bazy danych w ułamku sekundy po otwarciu
    SourceTable = Seminar;
    // Gwarantuje zaklasyfikowanie strony pod zakładkami systemu jako rodzaj zasobu z asortymentu w postaci "Listy"
    UsageCategory = Lists;
    // Link określający do której szczegółowej kontrolki kieruje system klienta po podwójnym kliknięciu lub rozwinięciu opcji edycji nad listą
    CardPageId = "Seminar Card";
    // Całkowite odseparowanie okna od ręcznych, twardych zapisów lub kliknięcia z listą celem edycji (Domyślnie używany jest CardPageId)
    Editable = false;

    // Struktura definicji wyświetlanego schematu w kontrolce przeglądarki klienta
    layout
    {
        // Główne obszary informacyjne
        area(content)
        {
            // Obiekt Repeater iterujący i napełniający kolumny z każdym przeparsowanym wierszem pobranym z tabeli źródłowej
            repeater(General)
            {
                // Kolumna 1: Kod identyfikujący kurs / szkolenie
                field("Code"; Rec."Code")
                {
                    // Wymóg kompilatora od paru wersji dla każdej zmiennej, określa podział stref uprawnień UI dla logiki
                    ApplicationArea = All;
                }
                
                // Kolumna 2: Pole przypisujące w locie odnaleziony tytuł
                field(Name; Rec.Name)
                {
                    // Pole dostępne w całym produkcie
                    ApplicationArea = All;
                }
                
                // Kolumna 3: Skondensowany skrót czasu przeznaczonego na uczestnictwo
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    // Pole dostępne w całym produkcie
                    ApplicationArea = All;
                }
                
                // Kolumna 4: Wewnętrzny kod szukający, użyteczny przy masowym przepisywaniu ułatwiający dopasowywanie na wyższych wersjach modułów (Search Name np. DRUK 3D)
                field("Search Name"; Rec."Search Name")
                {
                    // Przydziela bezwzględną klasyfikację ukrycia logiki stref pod wszystkie opcje
                    ApplicationArea = All;
                }
                
                // Kolumna 5: Prezentuje dane odgórne od jakiej ilości szkolenie zaczyna funkcjonować  
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    // Aplikuje widok
                    ApplicationArea = All;
                }
                
                // Kolumna 6: Limit miejsc wprowadzony z logiki na zaproszeniu i w kontrolce sali
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    // Widoczność we wszystkich strefach UI
                    ApplicationArea = All;
                }
                
                // Kolumna 7: System flagowy (Checkboxy wyświetlane z rzędu pokazujące które szkolenia zostały przeterminowane w użyciu i wyłączone z widoczności powiązanej edycji)
                field(Blocked; Rec.Blocked)
                {
                    // Brak wykluczenia logiki
                    ApplicationArea = All;
                }
                
                // Kolumna 8: Kwota cennikowa podstawowa 
                field("Seminar Price"; Rec."Seminar Price")
                {
                    // Odblokowana strefa
                    ApplicationArea = All;
                }
                
                // Kolumna 9: Wyciągnięta bezpośrednio po wylistowaniu opcja śledząca czas ingerencji w dane rekordu przez kogokolwiek z załogi operatorów systemu. Ułatwia audyty w firmie.
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    // Bez ograniczeń
                    ApplicationArea = All;
                }
            }
        }
    }
}
