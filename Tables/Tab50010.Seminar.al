// Główna tabela "Seminar" (Szkolenia)
// Służy jako kartoteka dla wszystkich rodzajów oferowanych szkoleń. Zawiera podstawowe parametry definiujące dany kurs.
//
// OBSŁUGIWANE POLA PRZEZ FRAGMENTY KODU (ZALEŻNOŚCI):
// - trigger OnValidate() w polu "Name" -> ODCZYTUJE: "Name", MODYFIKUJE: "Search Name"
// - trigger OnModify() (poziom tabeli) -> MODYFIKUJE: "Last Date Modified"
table 50010 Seminar
{
    // Wyświetlana etykieta tabeli
    Caption = 'Seminar';

    // Sekcja definiująca wszystkie pola znajdujące się w tabeli
    fields
    {
        // Pole 1: Kod szkolenia - unikalny identyfikator np. 'BCA-001', przechowujący ciąg alfanumeryczny
        field(1; "Code"; Code[20])
        {
            // Nazwa przyjazna do wyświetlania na stronach
            Caption = 'Code';
        }

        // Pole 2: Pełna nazwa szkolenia
        field(2; Name; Text[50])
        {
            // Wyświetlany tekst 'Name'
            Caption = 'Name';

            // Wyzwalacz (Trigger) uruchamiany w momencie pomyślnego podania nowej wartości przez użytkownika/system
            trigger OnValidate()
            begin
                // Sprawdzamy czy znormalizowana pole "Search Name" wymaga aktualizacji (porównanie z wersją UpperCase).
                // "Search Name" to zazwyczaj nazwa zapisana wielkimi literami używana do szybkiego wyszukiwania.
                if "Search Name" <> UpperCase(Name) then
                    // Przypisanie nowej, pisanej wielkimi literami wartości
                    "Search Name" := UpperCase(Name);
            end;
        }

        // Pole 3: Czas trwania szkolenia (np. ułamek dnia lub określenie godzin)
        field(3; "Seminar Duration"; Decimal)
        {
            // Wyświetlany tekst 'Seminar Duration'
            Caption = 'Seminar Duration';
            // Nakazuje formatowanie wartości dziesiętnej bez miejsc tysięcznych, z dokładnością tylko do jednego miejsca po przecinku.
            DecimalPlaces = 0 : 1;
        }

        // Pole 4: Minimalna wymagana liczba uczestników, by szkolenie się odbyło
        field(4; "Minimum Participants"; Integer)
        {
            // Wyświetlany tekst 'Minimum Participants'
            Caption = 'Minimum Participants';
        }

        // Pole 5: Limit maksymalnej liczby miejsc dostępnych na to szkolenie
        field(5; "Maximum Participants"; Integer)
        {
            // Wyświetlany tekst 'Maximum Participants'
            Caption = 'Maximum Participants';
        }

        // Pole 6: Nazwa systemowa do optymalnego i znormalizowanego wyszukiwania, zwykle zapisana wersalicjami
        field(6; "Search Name"; Code[50])
        {
            // Wyświetlany tekst 'Search Name'
            Caption = 'Search Name';
        }

        // Pole 7: Flaga określająca, czy szkolenie zostało wstrzymane (zablokowane). Zablokowanych szkoleń nie można rejestrować.
        field(7; Blocked; Boolean)
        {
            // Wyświetlany tekst 'Blocked'
            Caption = 'Blocked';
        }

        // Pole 8: Data informująca o ostatniej aktualizacji rekordu
        field(8; "Last Date Modified"; Date)
        {
            // Wyświetlany tekst 'Last Date Modified'
            Caption = 'Last Date Modified';
            // To pole jest aktualizowane przez logikę systemu, użytkownik nie może ręcznie go zmienić z poziomu strony (tylko do odczytu)
            Editable = false;
        }

        // Pole 9: Cena katalogowa przypisana do tego szkolenia, za jednego uczestnika
        field(9; "Seminar Price"; Decimal)
        {
            // Wyświetlany tekst 'Seminar Price'
            Caption = 'Seminar Price';
        }
    }

    // Sekcja definiująca klucze bazodanowe dla optymalizacji dostępu do danych
    keys
    {
        // Klucz główny (Primary Key - PK) używa pola "Code"
        key(PK; "Code")
        {
            // Oznacza ten klucz jako klastrowany, czyli narzuca fizyczny porządek sortowania rekordów w bazie danych SQL.
            Clustered = true;
        }
    }

    // Wyzwalacz uruchamiany za każdym razem, gdy dowolne pole w rekordzie zostanie zaktualizowane i zapisane do bazy.
    trigger OnModify()
    begin
        // Przypisanie aktualnej daty roboczej sesji Business Central ("WorkDate") do pola opisującego datę modyfikacji.
        "Last Date Modified" := WorkDate();
    end;
}
