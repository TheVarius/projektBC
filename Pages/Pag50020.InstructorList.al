// Strona "Instructor List" (Lista instruktorów)
// Dedykowana strona prezentująca płaskie zestawienie wszystkich dostępnych zasobów kadrowych prowadzących szkolenia (Z tabeli Instructor)
page 50020 "Instructor List"
{
    // Komenda upewniająca interfejs silnika z jakim rodzajem okna mamy do czynienia - Widok Listy (Tabela)
    PageType = List;
    // Napis który pokazuje się u góry strony po wpisaniu odnośnika w pasku szukającym 
    Caption = 'Instructors';
    // Link bezpośredni do logiki ukrytej w architekturze "Tabela Instruktorów"
    SourceTable = Instructor;
    // Instruktaż dla algorytmu indeksującego ("Szukajki" systemowej/Tell Me), by dopiął stronę pod sekcję "Listy"
    UsageCategory = Lists;
    // Oznacza stronę z widocznością w każdej ewentualnie sprofilowanej kompilacji środowiskowej klienta BC
    ApplicationArea = All;

    // Miejsce alokowania struktury widoku
    layout
    {
        // Obszar na zdefiniowane przez programistę kontrolki podpinane pod rekordy SourceTable
        area(Content)
        {
            // Komponent interfejsu przewijającego listę wielopoziomową. Generalnie w ERP służy do tworzenia pętli dla widoku i wyświetlania danych z kolejnych wierszy w tabeli w SQL.
            repeater(Group)
            {
                // Numer kodu definiującego na sztywno osobę zatrudnioną (Z klucza z tabeli)
                field("Code"; Rec."Code")
                {
                    // Wymóg AL od wyższych wersji API dla każdej kontrolki z osobna
                    ApplicationArea = All;
                }
                
                // Przepisanie wyciągniętej w locie czy standardowej zedytowanej pełnej formy słownej tego z kim obcujemy jako instruktor. 
                field("Name"; Rec."Name")
                {
                    // Odblokowana strefa
                    ApplicationArea = All;
                }
                
                // Opcjonalne pole z Dropdownem na tak/nie lub wiele wariantów w tym przypadku "Worker", "Subcontractor". Tutaj pozwala sprawdzić kto to z widoku całej listy naraz i np. pofiltrować po pracownikach własnych.
                field("Worker/Subcontractor"; Rec."Worker/Subcontractor")
                {
                    // Wymóg kompilatora AL
                    ApplicationArea = All;
                }
                
                // Kod referujący do oficjalnego pracownika wyciągniętego z tabeli Zasobów w ERP 
                field("Resource No."; Rec."Resource No.")
                {
                    // Wymóg kompilatora AL
                    ApplicationArea = All;
                }
                
                // Kod wskazujący na zewnętrzne przedsiębiorstwo (Konto Dostawcy faktur)
                field("Vendor No."; Rec."Vendor No.")
                {
                    // Wymóg kompilatora AL
                    ApplicationArea = All;
                }
            }
        }
    }
}
