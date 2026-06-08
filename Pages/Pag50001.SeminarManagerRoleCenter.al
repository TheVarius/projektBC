// Strona "Seminar Manager Role Center" (Centrum ról kierownika ds. szkoleń)
// Służy jako dedykowany, główny punkt startowy w aplikacji dla osób zarządzających modułem szkoleń.
// Oferuje szybki, profilowany dostęp do wszystkich istotnych narzędzi i ekranów z poziomu widoku głównego (dashboard).
page 50001 "Seminar Manager Role Center"
{
    // Określa typ strony na 'RoleCenter', instruując system o specyficznym schemacie działania przeznaczonym dla ekranów głównych ról.
    PageType = RoleCenter;
    // Nagłówek widoczny na samym szczycie obszaru pracy dla logującego się pracownika
    Caption = 'Seminar Manager';

    // Struktura wyświetlania sekcji widokowych Role Center
    layout
    {
        // Obszar na ewentualne przypięcia list częściowych w oknie głównym (Area RoleCenter)
        area(RoleCenter)
        {
            // Obecnie miejsce to nie posiada powiązanych widgetów (tzw. cues czy partii). Być może przewidziano to pod przyszłe statystyki np. ilości trwających rezerwacji.
        }
    }

    // Blok akcji definiujący górne paski narzędziowe (Ribbon) albo panele z lewej strony systemu dla tej konkretnej roli (Role Explorer).
    actions
    {
        // Główny panel boczny / menu nawigacyjne, służący jako podpora drzewka logiki dla różnych zakładek (Lists, Tasks).
        area(Sections)
        {
            // Grupa "Lists" - grupuje razem klasyczne rejestry tabelaryczne
            group(Lists)
            {
                // Widoczna nazwa na kafelku w Role Center lub tytule drzewka zakładek
                Caption = 'Lists';

                // Pojedyncza, wyodrębniona komenda, po najechaniu lub użyciu z klawiatury
                action(Seminars)
                {
                    // Tytuł elementu w nawigacji
                    Caption = 'Seminars';
                    // System po wejściu odpala fizycznie okno listy dla podanej strony zdefiniowanej w AL (RunObject wymusza włączenie określonego pliku stron "Seminar List")
                    RunObject = page "Seminar List";
                    // Akcja będzie bezwzględnie dopuszczona i udostępniana w architekturze bez ograniczeń do konkretnych regionów licencyjnych.
                    ApplicationArea = All;
                }
                // Druga komenda powiązana z bazą instruktorów
                action(Instructors)
                {
                    // Tytuł w menu 
                    Caption = 'Instructors';
                    // Akcja ładująca fizyczny widok przeglądu osób - Strona "Instructor List"
                    RunObject = page "Instructor List";
                    // Ograniczenia regionowe aplikacji usunięte
                    ApplicationArea = All;
                }
                // Trzeci element menu
                action(Rooms)
                {
                    // Tytuł pod którym znajdzie się odnośnik w obszarze "Lists"
                    Caption = 'Seminar Rooms';
                    // Strona przyporządkowana do podanego wskaźnika to okno wylistowania sal
                    RunObject = page "Seminar Room List";
                    // Wyłączone ograniczenia aplikacyjne
                    ApplicationArea = All;
                }
                // Czwarty punkt programu menu RoleCenter 
                action(Registrations)
                {
                    // Wskazuje na miejsce gdzie pojawią się edycje przeprowadzane dla wyżej ustalonych warunków 
                    Caption = 'Seminar Registrations';
                    // Wskaźnik wywołujący wejście na procesowy etap "Tabela Rejestracji na Kurs" 
                    RunObject = page "Seminar Registration List";
                    // Przypisanie środowiska
                    ApplicationArea = All;
                }
            }
            
            // Grupa "Tasks" - dla bardziej specjalizowanych narzędzi z konkretną akcją (Zadania okresowe w menu).
            group(Tasks)
            {
                // Nazwa tej podgrupy odseparowującej
                Caption = 'Tasks';
                
                // Polecenie włączania zadania wyciągania uczestników w pliku (Task/Raport).
                action(ExportParticipants)
                {
                    // Ustalenie lokalizacji tekstu (Polski język podany w kodzie bazowym) "Eksport uczestników szkolenia"
                    Caption = 'Eksport uczestników szkolenia';
                    // Inicjacja obiektu struktury niebędącego stroną i wylistowaniem, a potężnym wbudowanym generatorem i parsowaniem XML (xmlport "Export Seminar Participants")
                    RunObject = xmlport "Export Seminar Participants";
                    // Ustanowienie go po globalnym uruchomieniu pod dowolną dystrybucję licencyjną modułu ERP.
                    ApplicationArea = All;
                }
            }
        }
    }
}

// Blok powiązany tworzący profil z widokiem. Profil służy do identyfikacji roli i powiązywania jej z poszczególnymi użytkownikami na konsolecie administracyjnej.
profile "Seminar Manager"
{
    // Widoczna nazwa profilu 
    Caption = 'Seminar Manager';
    // Wskazanie dla kompilatora, do którego RoleCenter należy podpiąć ów schemat uprawnień wizualnych.
    RoleCenter = "Seminar Manager Role Center";
    // System przyjmuje weryfikację na true (włączenie widoku profilu dla administratora do wyboru u góry na ekranie Moje Ustawienia)
    Enabled = true;
    // Oznacza ten profil jako wyeksponowany jako jedna ze szczególnych i rzucających się w oczy ról w podpowiedziach w Business Central.
    Promoted = true;
}
