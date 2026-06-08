// Tabela "Instructor" (Instruktor)
// Przechowuje szczegółowe informacje o osobach prowadzących szkolenia. Obejmuje zarówno pracowników wewnętrznych jak i podwykonawców.
//
// OBSŁUGIWANE POLA PRZEZ FRAGMENTY KODU (ZALEŻNOŚCI):
// - trigger OnValidate() w polu "Worker/Subcontractor" -> ODCZYTUJE: "Worker/Subcontractor" (xRec i Rec), MODYFIKUJE: "Name", "Resource No.", "Vendor No."
// - trigger OnValidate() w polu "Resource No." -> ODCZYTUJE: "Worker/Subcontractor", "Resource No.", Resource.Name, MODYFIKUJE: "Name"
// - trigger OnValidate() w polu "Vendor No." -> ODCZYTUJE: "Worker/Subcontractor", "Vendor No.", Vendor.Name, MODYFIKUJE: "Name"
table 50020 Instructor
{
    // Etykieta tabeli widoczna w całej aplikacji
    Caption = 'Instructor';

    // Sekcja definiująca kolumny (pola) tabeli
    fields
    {
        // Pole 1: Główny klucz, unikalny kod identyfikujący instruktora
        field(1; "Code"; Code[20])
        {
            // Etykieta przyjazna w UI
            Caption = 'Code';
        }

        // Pole 2: Pełna nazwa (imię i nazwisko lub nazwa firmy w przypadku podwykonawcy)
        field(2; Name; Text[100])
        {
            // Etykieta przyjazna w UI
            Caption = 'Name';
        }

        // Pole 3: Pole typu Option określające relację prawną i pochodzenie instruktora (Pracownik firmy czy zewnętrzny)
        field(3; "Worker/Subcontractor"; Option)
        {
            // Etykieta widoczna w interfejsie
            Caption = 'Worker/Subcontractor';
            // Zdefiniowane wartości opcji do wyboru (wewnętrznie przechowuje 0 lub 1)
            OptionMembers = Worker,Subcontractor;
            // Etykiety opcji tłumaczone i widoczne w interfejsie użytkownika
            OptionCaption = 'Worker,Subcontractor';

            // Wyzwalacz uruchamiany po każdej zmianie typu zatrudnienia
            trigger OnValidate()
            begin
                // Jeśli typ został rzeczywiście zmieniony przez użytkownika (stara wartość xRec vs nowa wartość Rec)
                if "Worker/Subcontractor" <> xRec."Worker/Subcontractor" then begin
                    // Czyścimy nazwę, ponieważ pochodzi ona teraz z innego źródła (Pracownik lub Dostawca)
                    Name := '';
                    // Czyścimy powiązanie z numerem zasobu pracownika
                    "Resource No." := '';
                    // Czyścimy powiązanie z numerem dostawcy zewnętrznego
                    "Vendor No." := '';
                end;
            end;
        }

        // Pole 4: Powiązanie z zasobem wewnętrznym systemu (tylko w przypadku instruktorów wewnętrznych)
        field(4; "Resource No."; Code[20])
        {
            // Etykieta pola
            Caption = 'Resource No.';
            // Relacja do standardowej tabeli 'Resource'. Warunek 'where(Type = const(Person))' wymusza, 
            // by zasób nie był maszyną, ale osobą.
            TableRelation = Resource where(Type = const(Person));

            // Wyzwalacz po pomyślnym wybraniu zasobu
            trigger OnValidate()
            var
                // Lokalna zmienna rekordowa wskazująca na tabelę zasobów
                Resource: Record Resource;
            begin
                // Jeśli instruktor to nie jest pracownik wewnętrzny (Worker), to to pole nas nie dotyczy. Przerwij walidację.
                if "Worker/Subcontractor" <> "Worker/Subcontractor"::Worker then
                    exit;

                // Jeśli uda się znaleźć wybrany zasób po numerze w tabeli Resource
                if Resource.Get("Resource No.") then
                    // Automatycznie zaktualizuj nazwę instruktora (Pole 'Name') imieniem i nazwiskiem zasobu
                    Name := Resource.Name
                else
                    // W przeciwnym razie ustaw nazwę jako pustą (jeśli skasowano powiązanie)
                    Name := '';
            end;
        }

        // Pole 5: Powiązanie z zewnętrznym dostawcą w systemie (tylko dla podwykonawców zewnętrznych)
        field(5; "Vendor No."; Code[20])
        {
            // Etykieta pola
            Caption = 'Vendor No.';
            // Relacja gwarantująca wybór danych tylko i wyłącznie spośród zdefiniowanych Dostawców (Vendor)
            TableRelation = Vendor;

            // Wyzwalacz uruchamiany przy przypisaniu dostawcy
            trigger OnValidate()
            var
                // Lokalna zmienna obsługująca tabelę dostawców
                Vendor: Record Vendor;
            begin
                // Jeśli instruktor nie ma statusu podwykonawcy zewnętrznego (Subcontractor), walidacja nie powinna przypisywać danych dostawcy. Zakończ.
                if "Worker/Subcontractor" <> "Worker/Subcontractor"::Subcontractor then
                    exit;

                // Jeśli system odnajdzie wybranego dostawcę na liście
                if Vendor.Get("Vendor No.") then
                    // Przepisz jego pełną nazwę do pola Name instruktora
                    Name := Vendor.Name
                else
                    // W razie braku (np. użytkownik skasował wartość), wyczyść pole Name
                    Name := '';
            end;
        }
    }

    // Blok określający klucze używane w tabeli
    keys
    {
        // Klucz podstawowy, którego używa silnik bazy danych do optymalnego sortowania
        key(PK; "Code")
        {
            // Organizacja w oparciu o ten klucz
            Clustered = true;
        }
    }
}
