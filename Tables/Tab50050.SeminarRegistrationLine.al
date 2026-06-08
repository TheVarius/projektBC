// Tabela "Seminar Registration Line" (Wiersz rejestracji na szkolenie)
// Odpowiada poszczególnym uczestnikom biorącym udział w konkretnej edycji szkolenia. 
// Umożliwia przypisanie rabatów, weryfikację uczestnictwa oraz zarządzanie fakturowaniem za poszczególne osoby.
//
// OBSŁUGIWANE POLA PRZEZ FRAGMENTY KODU (ZALEŻNOŚCI):
// - trigger OnValidate() w polu "Bill-to Customer No." -> ODCZYTUJE: "Registered"
// - trigger OnValidate() w polu "Participant Contact No." -> WYMUSZA PRZELICZENIE (FlowField): "Participant Name"
// - trigger OnLookup() w polu "Participant Contact No." -> ODCZYTUJE: "Bill-to Customer No.", MODYFIKUJE: "Participant Contact No."
// - trigger OnValidate() w polu "Seminar Price" -> ODCZYTUJE: "Seminar Price", "Line Discount %", MODYFIKUJE: "Line Discount Amount", "Amount"
// - trigger OnValidate() w polu "Line Discount %" -> ODCZYTUJE: "Seminar Price", "Line Discount %", MODYFIKUJE: "Line Discount Amount", "Amount"
// - trigger OnValidate() w polu "Line Discount Amount" -> ODCZYTUJE: "Seminar Price", "Line Discount Amount", MODYFIKUJE: "Line Discount %", "Amount"
// - trigger OnValidate() w polu "Amount" -> ODCZYTUJE: "Seminar Price", "Amount", MODYFIKUJE: "Line Discount Amount", "Line Discount %"
// - trigger OnValidate() w polu "Registered" -> ODCZYTUJE: "Registered", MODYFIKUJE: "Register Date"
// - trigger OnInsert() (poziom tabeli) -> ODCZYTUJE: SeminarHeader."Seminar Price", MODYFIKUJE: "Seminar Price", "Amount"
// - trigger OnDelete() (poziom tabeli) -> ODCZYTUJE: "Registered"
table 50050 "Seminar Registration Line"
{
    // Etykieta tabeli widoczna podczas tworzenia raportów czy filtrów z nią związanych
    Caption = 'Seminar Registration Line';

    // Sekcja definiująca wszystkie pola znajdujące się na wierszu w bazie
    fields
    {
        // Pole 1: Klucz powiązania (Foreign Key) wskazujący na nagłówek szkolenia z tabeli Seminar Registration Header
        field(1; "Seminar Registration No."; Code[20])
        {
            // Nazwa pola
            Caption = 'Seminar Registration No.';
            // Relacja referencyjna gwarantująca, że wiersz będzie przypisany do istniejącego nagłówka. Zapobiega osieroconym rekordom
            TableRelation = "Seminar Registration Header";
        }

        // Pole 2: Kolejny, liczbowy identyfikator wiersza (np. 10000, 20000...) dodany celem unikalności wewnątrz nagłówka 
        field(2; "Line No."; Integer)
        {
            // Opis w interfejsie
            Caption = 'Line No.';
        }

        // Pole 3: Główny Płatnik / Nabywca na którego będą później generowane faktury sprzedaży
        field(3; "Bill-to Customer No."; Code[20])
        {
            // Etykieta
            Caption = 'Bill-to Customer No.';
            // Relacja wymuszająca wybór wyłącznie ze standardowej tabeli Klientów (Customer)
            TableRelation = Customer;

            // Uruchamia się po wybraniu przez operatora konkretnego nabywcy
            trigger OnValidate()
            begin
                // Sprawdzamy czy ta osoba została już oficjalnie zarejestrowana (proces nieodwracalny organizacyjnie na tym wierszu)
                if Registered then
                    // Zgłasza błąd przerywający i uniemożliwiający zmianę klienta na liście dla opłaconych/zabezpieczonych wpisów
                    Error(ChangeCustomerErr);
            end;
        }

        // Pole 4: Wyznaczenie bezpośredniej fizycznej osoby z firmy Płatnika (Z użyciem CRM kontaktów - Tabela Contact)
        field(4; "Participant Contact No."; Code[20])
        {
            // Wyświetlany tekst
            Caption = 'Participant Contact No.';
            // Powiązanie wprost do bazy kontaktów BC
            TableRelation = Contact;

            // Wyzwalacz zachodzący, gdy wprowadzimy ID Kontaktu manualnie i naciśniemy Enter lub Tab
            trigger OnValidate()
            begin
                // Nakazuje silnikowi przeliczyć wirtualne pole FlowField ("Participant Name") dla nowego wybranego numeru
                CalcFields("Participant Name");
            end;

            // Niestandardowy wyzwalacz, który nadpisuje wbudowane, trójkropkowe menu przeglądania rekordów (Lookup)
            trigger OnLookup()
            var
                // Lokalna zmienna dla Kontaktu
                Contact: Record Contact;
                // Lokalna zmienna dla określenia powiązań między Klientami a Kontaktami w CRM
                ContactBusinessRelation: Record "Contact Business Relation";
            begin
                // Skrypt przerywa działanie od razu, jeśli użytkownik kliknie Lookup, a nie określił jeszcze Nabywcy (Bill-to Customer) na wierszu!
                if "Bill-to Customer No." = '' then
                    exit;

                // Restowanie widoku powiązań CRM
                ContactBusinessRelation.Reset();
                // Filtruje tylko te powiązania, które idą z kierunku relacji Klienta (Customer) do Kontaktu
                ContactBusinessRelation.SetRange("Link to Table",
                    ContactBusinessRelation."Link to Table"::Customer);
                // Filtruje tabelę powiązań szukając wyłącznie tych podpiętych pod Klienta wybranego przed chwilą (Pole 3)
                ContactBusinessRelation.SetRange("No.", "Bill-to Customer No.");

                // Próba znalezienia relacji nadrzędnej dla podanego klienta (Konta firmowego Kontaktu)
                if ContactBusinessRelation.FindFirst() then begin
                    // Ograniczamy listę wybieralną
                    Contact.Reset();
                    // Pokazujemy kontakty fizyczne przypisane JEDYNIE pod tego samego pracodawcę (Osoby w jednej firmie)
                    Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
                    // Buduje popupową listę wyświetlającą odfiltrowane Kontakty z pytaniem o akceptację wyboru użytkownika
                    if Page.RunModal(Page::"Contact List", Contact) = Action::LookupOK then
                        // Użytkownik wskazał osobę (Contact."No."), system inicjuje logikę OnValidate dla obecnego pola (symulacja ręcznego wpisania i wciśnięcia ENTER)
                        Validate("Participant Contact No.", Contact."No.");
                end;
            end;
        }

        // Pole 5: Przepisane w locie powiązane informacje z tabeli Kontaktu za pomocą FlowField, pobierające czytelną dla człowieka nazwę uczestnika
        field(5; "Participant Name"; Text[100])
        {
            // Nazwa dla użytkownika
            Caption = 'Participant Name';
            // Brak przechowywania nazwy powielanej w bazie, wartość wyciągana jest kalkulacyjnie z widoku
            FieldClass = FlowField;
            // Szukamy rekordu Kontaktu i z jego parametrów bierzemy Name pasujące do naszego ID zdefiniowanego na wierszu
            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));
            // Pole nie podlega modyfikacjom - wirtualne odzwierciedlenie
            Editable = false;
        }

        // Pole 6: Zapisana w historii faktyczna data ujęcia uczestnika na danym szkoleniu
        field(6; "Register Date"; Date)
        {
            // Etykieta daty rejestracji
            Caption = 'Register Date';
            // Data podlega wewnętrznemu obiegowi i nie może zostać zmanipulowana w GUI
            Editable = false;
        }

        // Pole 7: Weryfikacja, czy dany przypisany z imienia i nazwiska klient ma opłacić uczestnictwo poprzez wygenerowanie dla niego faktury
        field(7; "To Invoice"; Boolean)
        {
            // Nazwa w postaci pola zaznaczającego Checkbox "Do zafakturowania"
            Caption = 'To Invoice';
            // Domyślnie system uznaje, że od razu nie przypisujemy do wystawiania dokumentów kosztowych - musi to potwierdzić organizator
            InitValue = false;
        }

        // Pole 8: Flaga, zaznaczana po faktycznym ukończeniu kursu przez uczestnika (np. do generowania certyfikatu lub dyplomu obecności)
        field(8; Participated; Boolean)
        {
            // Nazwa 
            Caption = 'Participated';
        }

        // Pole 9: Opcjonalna data mówiąca o ostatecznym wysłaniu i potwierdzeniu przez Nabywcę faktu uczestnictwa lub wysłaniu emaila z potwierdzeniem
        field(9; "Confirmation Date"; Date)
        {
            // Nazwa daty zatwierdzenia rezerwacji uczestnika
            Caption = 'Confirmation Date';
        }

        // Pole 10: Skopiowana z nagłówka cena szkolenia za jedną osobę
        field(10; "Seminar Price"; Decimal)
        {
            // Podpis
            Caption = 'Seminar Price';
            // Wbudowany format wyświetlania liczb BC - autoformat typu 2 (formatowanie systemowe zgodne z regionem jako ogólna liczba np. w finansach)
            AutoFormatType = 2;

            // Systematyka przy zmianie głównej ceny (ręcznie nadpisanej np. dla jednego klienta specjalnego)
            trigger OnValidate()
            begin
                // Przelicza od razu rabat - Cena razy wprowadzony wcześniej połączony zniżkowy procent dzielone przez 100 
                "Line Discount Amount" :=
                    Round("Seminar Price" * "Line Discount %" / 100);

                // Kwota ostateczna (Amount) to matematycznie odjęta kwota rabatu od wpisanej przed chwilą kwoty całkowitej za tego klienta
                Amount :=
                    "Seminar Price" - "Line Discount Amount";
            end;
        }

        // Pole 11: Zniżka dla Nabywcy na tę pozycję, wyliczana procentowo od Seminar Price
        field(11; "Line Discount %"; Decimal)
        {
            // Nazwa 
            Caption = 'Line Discount %';
            // Dokładność wyliczania procentowego podziału ułamka dla rynków wymagających specyficznej precyzji w obliczeniach rachunkowych (np. USA) - 5 miejsc
            DecimalPlaces = 0 : 5;
            // Zapobieganie błędom użytkownika (rabat nie może być liczbą negatywną powiększającą cenę!)
            MinValue = 0;
            // Zapobieganie błędom logicznym (rabat może wynieść co najwyżej 100%, darmowe szkolenie)
            MaxValue = 100;

            // Gdy operator wprowadzi zmianę wielkości narzuconego na tego uczestnika procentu...
            trigger OnValidate()
            begin
                // System ponownie przeprowadza proces przeliczania wartości zniżki ilościowo
                "Line Discount Amount" :=
                    Round("Seminar Price" * "Line Discount %" / 100);

                // I nanosi zmiany na wartość ogólną pomniejszając cenę wyjściową o obliczoną z powyższego wzoru kwotę zniżki...
                Amount :=
                    "Seminar Price" - "Line Discount Amount";
            end;
        }

        // Pole 12: Zniżka zdefiniowana po prostu sumą odcinanych pieniędzy z wartości ostatecznej np. "odejmij równe 50 zł"
        field(12; "Line Discount Amount"; Decimal)
        {
            // Nazwa 
            Caption = 'Line Discount Amount';
            // Format 1 to zazwyczaj waluta - zaokrągla w interfejsie po typowych zasadach walutowych (np. 2 miejsca po przecinku).
            AutoFormatType = 1;

            // Reakcja po wpisaniu gotowej wartości rabatu kwotowego
            trigger OnValidate()
            begin
                // System chroni się matematycznie przed błędem Dzielenia Przez Zero (gdy szkolenie nic nie kosztuje)
                if "Seminar Price" <> 0 then
                    // Przepisuje nową procentową wartość używając proporcjonalnego wzoru od nowej podanej tu stałej kwoty rabatu ("Odwrotny" wzór na procent rabatu) 
                    "Line Discount %" :=
                        Round(("Line Discount Amount" / "Seminar Price") * 100, 0.00001);

                // Kwota całościowa ponownie jest redukowana o zniżkę wpisaną przez Nabywcę/Sprzedawcę
                Amount :=
                    "Seminar Price" - "Line Discount Amount";
            end;
        }

        // Pole 13: Totalna kwota należności do zapłaty za jedną osobę
        field(13; Amount; Decimal)
        {
            // Opis w systemie ERP
            Caption = 'Amount';
            // Waluta (auto format dla stawek i raportów)
            AutoFormatType = 1;

            // Mechanika odwróconych obliczeń dla użytkowników weryfikujących ostateczną kwotę zamiast rabatów - np. klient płaci 250 zamiast 300zł i system dobiera parametry...
            trigger OnValidate()
            begin
                // Skoro mam ostateczną wartość to wyliczamy wypracowaną kwotowo zniżkę...
                "Line Discount Amount" :=
                    "Seminar Price" - Amount;

                // Jeżeli szkolenie jest darmowe i błąd przy "dzieleniu przez zero" odhaczony to...
                if "Seminar Price" <> 0 then
                    // ...Odwrotnie wyliczamy sobie procent dla pola "Line Discount %"
                    "Line Discount %" :=
                        Round(("Line Discount Amount" / "Seminar Price") * 100, 0.00001);
            end;
        }

        // Pole 14: Systemowa, główna flaga bezpieczeństwa określająca zapis i zabezpieczenie rezerwacji na szkoleniu 
        field(14; Registered; Boolean)
        {
            // Zrozumiała nazwa pola (Zarejestrowano/Tak-Nie)
            Caption = 'Registered';

            // Zmiana checkoxa przez użytkownika w kartotece wyzwoli OnValidate...
            trigger OnValidate()
            begin
                // Jeśli opcja zostaje wciśnięta...
                if Registered then
                    // Przypisana zostanie wirtualna zmienna sesji - data i czas zapisania tego uczestnictwa przez operatora ERP. 
                    "Register Date" := WorkDate()
                else
                    // W razie odznaczenia użytkownika z listy potwierdzonych uczestników szkolenia, kasuje się data 0D z bazy (0D == brak daty, pusta data).
                    "Register Date" := 0D;
            end;
        }

        // Pole 15: Historyczna, dokumentacyjna referencja powiązanego numeru zafakturowanej usługi.
        field(15; "Invoice No."; Code[20])
        {
            // Wyświetlany nagłówek tabeli
            Caption = 'Invoice No.';
            // Relacja rygorystycznie ograniczająca dokument sprzedaży jedynie do rodzaju "Invoice" (Faktura Zwykła), powiązanego z systemem faktur MS Dynamics
            TableRelation = "Sales Header"."No."
                where("Document Type" = const(Invoice));

            // Nigdy nie wolno samodzielnie zmieniać pola fakturowania bez dedykowanego procesu z osobnego skryptu fakturowania
            Editable = false;
        }
    }

    // Grupa kluczy tabelarycznych w kodzie
    keys
    {
        // Klucz o identyfikatorze PK dla każdego uczestnika - łączący Nagłówek (Identyfikator kursu) oraz Numer kolejności z danej edycji
        key(PK; "Seminar Registration No.", "Line No.")
        {
            // Optymalizacja wyszukiwań po kluczu od podstaw fizycznego działania zapisu na serwerze 
            Clustered = true;
            // Wirtualnie utworzone pola indeksowe (SumIndexFields) automatycznie dające możliwość używania metody sum() dla pola Amount dla danych nagłówków w locie. 
            // Znacząco polepsza wydajność silnika MS SQL i jest to baza dla FlowFielda Amount z Tabeli Głównej!
            SumIndexFields = Amount;
        }
    }

    // Wyzwalacz powiązań pomiędzy powołaniem do życia nowego wiersza...
    trigger OnInsert()
    var
        // Łącznik zmiennej odwołującej się na dane Głównego szkolenia 
        SeminarHeader: Record "Seminar Registration Header";
    begin
        // Kod upewnia się co do wyciągnięcia numeru z relacji przy dopinaniu uczestnika ("Get")
        if SeminarHeader.Get("Seminar Registration No.") then begin
            // Przy pomocy sztucznego procesu wciskania i weryfikowania pól wewnątrz interfejsu klienta, wyzwala Validate w tabeli (oblicza resztę pól matematycznych podając mu pole ceny wyjściowej)
            Validate("Seminar Price", SeminarHeader."Seminar Price");
            // Równie sztucznie wpisuje tę cenę do docelowej ceny sprzedaży 
            Validate(Amount, "Seminar Price");
        end;
    end;

    // Próba odkasowania linii załącznika przez skróty z bazy
    trigger OnDelete()
    begin
        // System nie godzi się na operację usuwania jeżeli użytkownik posunął się wcześniej o krok za daleko w zdefiniowaniu uczestnictwa - mianowicie zaznaczył klucz Registered w formularzu. 
        if Registered then
            // Jeżeli próba obejścia tego obwodu wyjdzie - silnik zgłosi twardy wyjątek uniemożliwiający usunięcie uczestnika (Error!).
            Error(DeleteRegisteredErr);
    end;

    // Blok etykiet o stałej składni, odnajdowany przez pliki .xlf dla mechanizmu wielojęzycznego (Translation System).
    var
        // Zmienna przechowująca ostrzeżenie braku usunięcia zgłoszonego wiersza  
        DeleteRegisteredErr: Label 'Registered lines cannot be deleted.';
        // Zmienna informująca o tym że klient może zostać wymazany z wiersza tylko, gdy nie doszło jeszcze do pełnej rejestracji pod kurs!
        ChangeCustomerErr: Label 'Bill-to Customer No. can only be changed for unregistered lines.';

}
