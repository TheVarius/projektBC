// Tabela "Seminar Registration Header" (Nagłówek rejestracji na szkolenie)
// Stanowi główny dokument operacyjny dla danej edycji planowanego szkolenia.
// Łączy w sobie informacje z wielu kartotek: ze szkolenia (Seminar), sali (Seminar Room), instruktora (Instructor).
//
// OBSŁUGIWANE POLA PRZEZ FRAGMENTY KODU (ZALEŻNOŚCI):
// - trigger OnValidate() w polu "Starting Date" -> ODCZYTUJE: "Status"
// - trigger OnValidate() w polu "Seminar Code" -> ODCZYTUJE: "Seminar Code", Seminar.Name, Seminar."Seminar Duration", Seminar."Minimum Participants", Seminar."Maximum Participants", Seminar."Seminar Price", MODYFIKUJE: "Seminar Name", "Seminar Duration", "Minimum Participants", "Maximum Participants", "Seminar Price"
// - trigger OnValidate() w polu "Instructor Code" -> WYMUSZA PRZELICZENIE (FlowField): "Instructor Name"
// - trigger OnValidate() w polu "Seminar Room Code" -> ODCZYTUJE: "Seminar Room Code", "Maximum Participants" (z nagłówka i sali), SeminarRoom.Name, SeminarRoom.Address, SeminarRoom."Address 2", SeminarRoom."Post Code", SeminarRoom.City, SeminarRoom."Phone No.", MODYFIKUJE: "Seminar Room Name", "Seminar Room Address", "Seminar Room Address 2", "Seminar Room Post Code", "Seminar Room City", "Seminar Room Phone No."
// - trigger OnValidate() w polu "Seminar Price" -> ODCZYTUJE: "Status", "Seminar Price" (xRec i Rec), MODYFIKUJE (w powiązanych liniach): "Seminar Registration Line"."Seminar Price"
// - trigger OnInsert() (poziom tabeli) -> MODYFIKUJE: "Posting Date"
// - trigger OnDelete() (poziom tabeli) -> ODCZYTUJE: "Status"
table 50040 "Seminar Registration Header"
{
    // Nagłówek wyświetlany w UI przy odwoływaniu się do encji
    Caption = 'Seminar Registration Header';

    // Zbiór wszystkich pól należących do nagłówka edycji szkolenia
    fields
    {
        // Pole 1: Unikalny, nadany kod liczbowy/alfanumeryczny (Numer dokumentu, "No.")
        field(1; "No."; Code[20])
        {
            // Etykieta wyświetlana użytkownikowi
            Caption = 'No.';
        }

        // Pole 2: Data, kiedy faktycznie dane szkolenie (ta edycja) się rozpocznie
        field(2; "Starting Date"; Date)
        {
            // Etykieta
            Caption = 'Starting Date';

            // Po zmianie / uzupełnieniu daty 
            trigger OnValidate()
            begin
                // Sprawdzamy czy modyfikujemy edycję o statusie innym niż "Planowane". 
                // Jeżeli tak - zgłaszamy błąd, aby zapobiec modyfikacjom historycznych (bądź zatwierdzonych) szkoleń.
                if Status <> Status::Planning then
                    // Zgłasza przerwę wykonywania kodu i prezentuje predefiniowany tekst z błędem w UI
                    Error(StartingDateStatusErr);
            end;
        }

        // Pole 3: Wybór szkolenia głównego z listy wszystkich dostępnych szkoleń (z tabeli Seminar)
        field(3; "Seminar Code"; Code[20])
        {
            // Etykieta pola
            Caption = 'Seminar Code';
            // Relacja referencyjna do tabeli powiązanej. Nakazuje wybierać tylko z katalogu, w którym szkolenia nie są zablokowane ('Blocked' = false)
            TableRelation = Seminar where(Blocked = const(false));

            // Zabezpieczający proces zachodzący po zmianie szkolenia
            trigger OnValidate()
            var
                // Lokalna zmienna reprezentująca kartotekę szkolenia
                Seminar: Record Seminar;
                // Lokalna zmienna odwołująca się do wierszy podpiętych pod tę edycję szkolenia (uczestników)
                SeminarRegLine: Record "Seminar Registration Line";
            begin
                // Kasuje aktywne i ewentualne ukryte filtry dla tej zmiennej
                SeminarRegLine.Reset();
                // Ogranicza zbiór przeglądanych linii wyłącznie do wierszy przypisanych do tego samego numeru dokumentu ("No.") co nasza edycja
                SeminarRegLine.SetRange("Seminar Registration No.", "No.");
                // Ogranicza pulę do uczestników, których zarejestrowano w systemie
                SeminarRegLine.SetRange(Registered, true);

                // Jeżeli ktokolwiek już został zarejestrowany na obecne szkolenie, to zmiana kursu (Seminar Code) jest niedopuszczalna!
                if SeminarRegLine.FindFirst() then
                    // Wyświetlenie błędu przerywającego proces
                    Error(SeminarWithRegisteredLinesModifyErr);

                // Jeśli z powodzeniem udało się wyszukać i pobrać pełen zestaw danych z wybranego przed chwilą szkolenia...
                if Seminar.Get("Seminar Code") then begin
                    // ...następuje przepisywanie informacji głównych z definicji szkolenia do nagłówka dokumentu
                    "Seminar Name" := Seminar.Name;
                    "Seminar Duration" := Seminar."Seminar Duration";
                    "Minimum Participants" := Seminar."Minimum Participants";
                    "Maximum Participants" := Seminar."Maximum Participants";

                    // Wywołanie akcji Validate symuluje wprowadzenie danych przez użytkownika do pola, 
                    // a więc uruchamia OnValidate() na polu "Seminar Price", wywołując pytanie o aktualizację cen dla linii!
                    Validate("Seminar Price", Seminar."Seminar Price");
                end else begin
                    // Jeżeli użytkownik skasował wpis ze "Seminar Code" lub go nie odnaleziono, zresetuj również przypisane do niego dane
                    "Seminar Name" := '';
                    "Seminar Duration" := 0;
                    "Minimum Participants" := 0;
                    "Maximum Participants" := 0;
                    "Seminar Price" := 0;
                end;
            end;
        }

        // Pole 4: Kopia lub spersonalizowana nazwa dla konkretnej edycji wybranego wcześniej szkolenia
        field(4; "Seminar Name"; Text[50])
        {
            // Etykieta
            Caption = 'Seminar Name';
        }

        // Pole 5: Osoba wydelegowana z ramienia organizatorów do przeprowadzenia szkolenia (Instruktor)
        field(5; "Instructor Code"; Code[20])
        {
            // Opis 
            Caption = 'Instructor Code';
            // Wybór ogranicza się ściśle do zdefiniowanej listy osób znajdującej się w obiekcie tabeli "Instructor"
            TableRelation = Instructor;

            // Po zmianie instruktora
            trigger OnValidate()
            begin
                // Przelicza na nowo i odświeża wynik pola wyliczanego (FlowField) - w tym wypadku pola "Instructor Name"
                CalcFields("Instructor Name");
            end;
        }

        // Pole 6: Przepisane w locie powiązane informacje wprost z rekordu Instruktora (pełne nazwisko), z użyciem technologii FlowField
        field(6; "Instructor Name"; Text[100])
        {
            // Opis w interfejsie
            Caption = 'Instructor Name';
            // Rezygnacja z klasycznej formy na rzecz wirtualnego kalkulowania. 
            // Wartość nie znajduje się w bazie jako nowa zmienna, a jest wyciągana poprzez kwerendę z innej tabeli.
            FieldClass = FlowField;
            // Opis w jaki sposób pole się liczy (formuła): Szukaj z tabeli Instruktora kolumny Name dla odpowiedniego rekordu.
            CalcFormula = lookup(Instructor.Name where(Code = field("Instructor Code")));
            // Użytkownik nie ma prawa modyfikować tej nazwy z poziomu tej kontrolki, bo to kopia widokowa
            Editable = false;
        }

        // Pole 7: Etap realizowania cyklu edukacyjnego / rezerwacyjnego 
        field(7; Status; Option)
        {
            // Opis w interfejsie
            Caption = 'Status';
            // Wartości przechodzące przez maszynę stanów: Planowanie (tworzenie), Rejestracja (dostępne zapisy), Zakończone, Anulowane
            OptionMembers = Planning,Registration,Finished,Cancelled;
            // Polskie napisy odpowiednie do każdej opcji do wyświetlenia w oknie
            OptionCaption = 'Planning,Registration,Finished,Cancelled';
        }

        // Pole 8: Skopiowany czas trwania w dobach / godzinach (skalowany)
        field(8; "Seminar Duration"; Decimal)
        {
            // Etykieta pola
            Caption = 'Seminar Duration';
            // Format zaokrąglania po przecinku 0:1
            DecimalPlaces = 0 : 1;
        }

        // Pole 9: Próg poniżej którego szkolenie zwykle nie startuje i zostanie anulowane
        field(9; "Minimum Participants"; Integer)
        {
            // Etykieta pola
            Caption = 'Minimum Participants';
        }

        // Pole 10: Próg blokujący dodawanie nowych wierszy z użytkownikami, narzucony przez rodzaj kursu
        field(10; "Maximum Participants"; Integer)
        {
            // Etykieta pola
            Caption = 'Maximum Participants';
        }

        // Pole 11: Zarezerwowana fizyczna lokalizacja (sala z systemu) 
        field(11; "Seminar Room Code"; Code[20])
        {
            // Nazwa
            Caption = 'Seminar Room Code';
            // Zbiór wszystkich miejsc szkoleniowych z tablicy Sali
            TableRelation = "Seminar Room";

            // Wyzwalacz zachodzący po zmianie pomieszczenia
            trigger OnValidate()
            var
                // Lokalna instancja encji przechowującej dane o Sali Szkoleniowej 
                SeminarRoom: Record "Seminar Room";
            begin
                // Próba załadowania pełnych ustawień przypisanej wyżej sali
                if SeminarRoom.Get("Seminar Room Code") then begin

                    // Ważny wymóg organizacyjny: Czy wybrana sala na pewno pomieści zaplanowaną wielkość grupy? 
                    if SeminarRoom."Maximum Participants" < "Maximum Participants" then
                        // System wypisuje ostrzeżenie, choć nie przerywa działania (użytkownik podejmuje decyzję)
                        Message(RoomCapacityWarnMsg);

                    // Przepisywanie stałych cech adresowych z obiektu Sali wprost do tego dokumentu, na potrzeby np. wydruku rezerwacji czy zaproszeń
                    "Seminar Room Name" := SeminarRoom.Name;
                    "Seminar Room Address" := SeminarRoom.Address;
                    "Seminar Room Address 2" := SeminarRoom."Address 2";
                    "Seminar Room Post Code" := SeminarRoom."Post Code";
                    "Seminar Room City" := SeminarRoom.City;
                    "Seminar Room Phone No." := SeminarRoom."Phone No.";

                end else begin
                    // Jeśli pole wyczyszczono, czyścimy też wszystkie pochodne pola wyciągnięte do pamięci dokumentu
                    "Seminar Room Name" := '';
                    "Seminar Room Address" := '';
                    "Seminar Room Address 2" := '';
                    "Seminar Room Post Code" := '';
                    "Seminar Room City" := '';
                    "Seminar Room Phone No." := '';
                end;
            end;
        }

        // Pola powielone z wybranej sali poniżej, w formie informacyjnej:

        // Pole 12: Przeniesiona nazwa sali
        field(12; "Seminar Room Name"; Text[50])
        {
            Caption = 'Seminar Room Name';
        }

        // Pole 13: Przeniesiony główny adres (ulica/budynek)
        field(13; "Seminar Room Address"; Text[50])
        {
            Caption = 'Seminar Room Address';
        }

        // Pole 14: Przeniesione rozszerzenie adresu
        field(14; "Seminar Room Address 2"; Text[50])
        {
            Caption = 'Seminar Room Address 2';
        }

        // Pole 15: Przeniesiony kod pocztowy sali
        field(15; "Seminar Room Post Code"; Code[20])
        {
            Caption = 'Seminar Room Post Code';
        }

        // Pole 16: Miejscowość sali
        field(16; "Seminar Room City"; Text[30])
        {
            Caption = 'Seminar Room City';
        }

        // Pole 17: Telefon kontaktowy do Sali/Wynajmującego
        field(17; "Seminar Room Phone No."; Text[30])
        {
            Caption = 'Seminar Room Phone No.';
        }

        // Pole 18: Data przypisania operacji księgowych i wejścia dokumentu w obieg fakturowy 
        field(18; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        // Pole 19: Koszt ponoszony przez pojedynczego uczestnika (Cena biletu/rejestracji) za daną edycję
        field(19; "Seminar Price"; Decimal)
        {
            // Nazwa przyjazna
            Caption = 'Seminar Price';

            // Zmiana podstawowej ceny wpływa na każdego uczestnika przypisanego pod tą edycję w systemie
            trigger OnValidate()
            var
                // Lokalna referencja na wiersze zapisów, aby operować na wszystkich naraz z pętli
                SeminarLine: Record "Seminar Registration Line";
            begin
                // Jeśli edycja szkolenia została już anulowana, nie ma sensu modyfikować cen
                if Status = Status::Cancelled then
                    exit;

                // Jeżeli wywołał to proces, który wpisał to samo co już jest w bazie, nie robimy pętli by nie tracić mocy bazy (xRec i Rec pokrywają się).
                if xRec."Seminar Price" = "Seminar Price" then
                    exit;

                // Pytanie, czy operator systemu chciał również wpisać od teraz nową cenę wszystkim na wierszach (pojedynczych fakturach z zapisanymi miejscami). Default to false.
                if Confirm(UpdateLinesQst, false) then begin

                    // Reset filtrów systemowych 
                    SeminarLine.Reset();
                    // Szukamy uczestników w naszej konkretnej grupie (Dokument No.)
                    SeminarLine.SetRange("Seminar Registration No.", "No.");
                    // Modyfikujemy jedynie tych uczestników, których rezerwacja jest na etapie braku finalizacji (nie zatwierdzono jeszcze wiersza w systemie).
                    SeminarLine.SetRange(Registered, false);

                    // Pobiera wszystkie wiersze pasujące do kryteriów...
                    if SeminarLine.FindSet() then
                        // Petla przechodząca element po elemencie, wiersz po wierszu z uczestnikami
                        repeat
                            // Aktualizowanie wartości ceny z wiersza uczestnika, nałożenie standardowych wyzwalaczy OnValidate() tej tabeli na nowe dane (wymusi przeliczenie rabatu!)
                            SeminarLine.Validate("Seminar Price", "Seminar Price");
                            // Trwałe zapisanie rekordu z wiersza (Argument True odpala lokalne trigger'y 'OnModify')
                            SeminarLine.Modify(true);
                        // Krok przejścia na nowy wiersz z danymi, Next zwróci liczbę 0 przy końcu rekordów...
                        until SeminarLine.Next() = 0;
                end;
            end;
        }

        // Pole 20: Automatycznie sumująca się wartość wykazująca ogólny koszt po odliczeniu rabatów, z perspektywy calej edycji
        field(20; Amount; Decimal)
        {
            // Etykieta
            Caption = 'Amount';
            // Znów rezygnujemy z pola statycznego i przechodzimy na technologię kalkulowaną, gdzie baza danych tworzy odpowiedź w pamięci zapytaniem bazodanowym sumującym sum(Field) z innej tabeli w locie.
            FieldClass = FlowField;
            // Suma kosztów ze wszystkich wierszy (Amount).
            CalcFormula = sum("Seminar Registration Line".Amount
                // Tylko te należące do obecnego Dokumentu
                where("Seminar Registration No." = field("No.")));
        }
    }

    // Parametry indeksowe i definicje sortowania
    keys
    {
        // Najważniejszy element: "Code" zastąpiony jest tutaj przez "No.", czyli numer całego obozu szkoleniowego
        key(PK; "No.")
        {
            // Uporządkowanie i unikalność załatwia główna warstwa silnika
            Clustered = true;
        }
    }

    // Wyzwalacz powiązany z fizycznym dodawaniem wiersza do bazy systemowej
    trigger OnInsert()
    begin
        // Każda nowo utworzona kartoteka na starcie otrzymuje dzisiejszą datę operacyjną w systemie jako datę księgowania
        "Posting Date" := WorkDate();
    end;

    // Wyzwalacz odprawiany tuż po wciśnięciu komendy "Usuń" i przejściu kontroli
    trigger OnDelete()
    begin
        // Nie można usunąć szkolenia, do którego trwają aktywne zapisy (Status::Registration) lub zostało zamknięte i opłacone (Status::Finished). Można to zrobić dla planów lub anulowanych.
        if not (Status in [Status::Planning, Status::Cancelled]) then
            // Jeżeli warunek wpadnie na błędny status to uniemożliwiamy kontynuowanie z informacją tekstową Error.
            Error(DeleteStatusErr);
    end;

    // Wyzwalacz wymuszany po próbie przemianowania istniejącego rekordu (zmiana kolumny będącej w głównym kluczu Primary Key)
    trigger OnRename()
    begin
        // Kod dokumentu stanowi serce rejestracji. Pod żadnym względem w systemie Dynamics Nav / BC nie powinno pozwalać się na zmianę identyfikatora. Baza ma powiązane wpisy po "No."
        Error(RenameErr);
    end;

    // Definiowane zmienne i teksty statyczne dla tłumaczeń i UI (korzystając z narzędzi XLIFF).
    var
        // Treść błędu odrzucającego modyfikację na przypisanych liniach
        SeminarWithRegisteredLinesModifyErr: Label 'Seminar with registered lines cannot be modified.';
        // Treść błędu blokująca zmianę początku z niewłaściwym statusem
        StartingDateStatusErr: Label 'Starting Date can only be changed for Planning status.';
        // Treść błędu po wciśnięciu usuwania na zatwierdzonym szkoleniu
        DeleteStatusErr: Label 'Only Planning or Cancelled registrations can be deleted.';
        // Zabezpieczenie przed manipulowaniem kluczem "No." dokumentu
        RenameErr: Label 'Changing registration number is not allowed.';
        // Treść okienka z ostrzeżeniem pojemnościowym o zbyt dużej liczbie miejsc szkoleniowych.
        RoomCapacityWarnMsg: Label 'Room capacity is lower than maximum seminar participants.';
        // Treść modalna zadająca pytanie po zmianie ceny podstawowej w systemie, aby nanieść zmianę wszędzie u dołu formularza 
        UpdateLinesQst: Label 'Do you want to update seminar price on all unregistered lines?';
}
