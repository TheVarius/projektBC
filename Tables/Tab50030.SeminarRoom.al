// Tabela "Seminar Room" (Sala szkoleniowa)
// Przechowuje fizyczne bądź wirtualne lokalizacje, w których może odbywać się szkolenie.
// Posiada szczegóły adresowe oraz parametry dotyczące limitów miejsc.
//
// OBSŁUGIWANE POLA PRZEZ FRAGMENTY KODU (ZALEŻNOŚCI):
// - trigger OnValidate() w polu "Post Code" -> ODCZYTUJE: "Post Code", "Country/Region Code", PostCodeRec.City, MODYFIKUJE: "City"
table 50030 "Seminar Room"
{
    // Etykieta tabeli widoczna w systemie
    Caption = 'Seminar Room';

    // Sekcja definiująca strukturę i poszczególne pola dla rekordu Sali
    fields
    {
        // Pole 1: Klucz unikalny identyfikujący salę (np. 'ROOM-A')
        field(1; "Code"; Code[20])
        {
            // Przyjazna etykieta wyświetlana na interfejsie
            Caption = 'Code';
        }

        // Pole 2: Opisowa i zrozumiała nazwa dla użytkowników
        field(2; Name; Text[50])
        {
            // Przyjazna etykieta wyświetlana na interfejsie
            Caption = 'Name';
        }

        // Pole 3: Pierwsza linijka danych adresowych (ulica i numer budynku/lokalu)
        field(3; Address; Text[50])
        {
            // Przyjazna etykieta wyświetlana na interfejsie
            Caption = 'Address';
        }

        // Pole 4: Ewentualna druga linijka na dodatkowe informacje adresowe, jak numer pokoju
        field(4; "Address 2"; Text[50])
        {
            // Przyjazna etykieta wyświetlana na interfejsie
            Caption = 'Address 2';
        }

        // Pole 5: Nazwa miasta powiązanego z lokalizacją
        field(5; City; Text[30])
        {
            // Przyjazna etykieta wyświetlana na interfejsie
            Caption = 'City';
        }

        // Pole 6: Kod pocztowy - wyzwala też sprawdzenie logiki i autouzupełnianie miasta na podstawie globalnej tabeli "Post Code"
        field(6; "Post Code"; Code[20])
        {
            // Etykieta z opisem
            Caption = 'Post Code';
            // Relacja referencyjna weryfikująca kod pocztowy w głównej tabeli "Post Code"
            TableRelation = "Post Code";

            // Wyzwalacz zachodzący po zmianie kodu pocztowego przez operatora
            trigger OnValidate()
            var
                // Lokalny rekord wykorzystany do przeszukania tabeli z kodami pocztowymi
                PostCodeRec: Record "Post Code";
                // Zmienna przechowująca ewentualną strukturę powiatową (wymóg przy wywołaniach procedur walidacji adresowej)
                DummyCounty: Text[30];
            begin
                // Próba odnalezienia rekordu o podanym kodzie w danym kraju
                if PostCodeRec.Get("Post Code", "Country/Region Code") then
                    // Zmiana nazwy miejscowości (City) po odnalezieniu wpisu w bazie 
                    City := PostCodeRec.City;

                // Uruchomienie standardowej, centralnej funkcji logiki biznesowej, by sprawdzić relację miasto <-> kod pocztowy
                PostCode.ValidatePostCode(
                    City,                  // Miasto
                    "Post Code",           // Kod Pocztowy
                    DummyCounty,           // Pusta zmienna regionu/powiatu
                    "Country/Region Code", // Kod kraju 
                    (CurrFieldNo <> 0) and GuiAllowed()); // Flaga wskazująca, czy to interaktywny błąd UI, czy modyfikacja backendowa
            end;
        }

        // Pole 7: Kod regionu lub państwa, wpływa na logikę kodów pocztowych
        field(7; "Country/Region Code"; Code[10])
        {
            // Przyjazna etykieta w interfejsie
            Caption = 'Country/Region Code';
            // Narzuca relację do standardowego słownika państw (Country/Region)
            TableRelation = "Country/Region";
        }

        // Pole 8: Numer telefonu na np. portiernię, recepcję sali
        field(8; "Phone No."; Text[30])
        {
            // Etykieta w interfejsie
            Caption = 'Phone No.';
        }

        // Pole 9: Numer na urządzenie faksujące w danej sali (obecnie rzadko używane)
        field(9; "Fax No."; Text[30])
        {
            // Etykieta w interfejsie
            Caption = 'Fax No.';
        }

        // Pole 10: Alternatywna, druga nazwa służąca do celów lokalizacyjnych lub skrót
        field(10; "Name 2"; Text[50])
        {
            // Etykieta
            Caption = 'Name 2';
        }

        // Pole 11: Zabezpieczenie fizyczne mówiące ilu uczestników w sumie może przebywać w tym samym pomieszczeniu
        field(11; "Maximum Participants"; Integer)
        {
            // Wyświetlana nazwa w interfejsie
            Caption = 'Maximum Participants';
        }

        // Pole 12: Wskazuje, do kogo należy sala, co może determinować rozliczenia.
        field(12; "Internal/External"; Option)
        {
            // Tytuł w aplikacji
            Caption = 'Internal/External';
            // Wartości możliwe dla logiki systemowej (Internal to zasób własny, External to wynajem poza biurem)
            OptionMembers = Internal,External;
            // Teksty widoczne dla użytkowników przy wybieraniu z listy (Dropdown)
            OptionCaption = 'Internal,External';
        }
    }

    // Indeksy kluczy wykorzystywane przy działaniu i optymalizacji tabeli w SQL
    keys
    {
        // Określenie podstawowego klucza tabeli - ułożenie w sposób klastrowany, alfabetycznie po Kodzie (Code)
        key(PK; "Code")
        {
            // Ustalenie optymalizacji na dysku
            Clustered = true;
        }
    }

    // Deklaracja zmiennych globalnych dostępnych na poziomie definicji tego pliku (tzw. Global Variables)
    var
        // Instancja rekordu potrzebna np. dla metod z logiki adresowej w innych wyzwalaczach
        PostCode: Record "Post Code";
}
