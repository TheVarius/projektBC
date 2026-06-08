// Strona "Seminar Room List" (Lista sal szkoleniowych)
// Strona z wylistowanymi lokalizacjami w których można realizować wpisy dotyczące szkoleń. Daje wgląd w możliwości wielkości poszczególnych pokoi i sal w jednym oknie.
page 50030 "Seminar Room List"
{
    // Definicja profilu kontrolki okienkowej w środowisku WebClient w wersji Business Central (Tutaj wariant wylistowania wszystkich rekordów).
    PageType = List;
    // Wyświetlane w pasku nawigacyjnym tytułowe hasło modułu Sali
    Caption = 'Seminar Rooms';
    // Link do tabeli zlokalizowanej pod tym wpisem rejestru "Seminar Room"
    SourceTable = "Seminar Room";
    // Skategoryzowanie w algorytmie poszukiwań "TellMe" u góry rogu ekranu, jako lista słownikowa.
    UsageCategory = Lists;
    // Ustawienie praw uwidocznienia we wszystkich profilach globalnych programu (Nie chowaj przed żadną sublicencją klienta).
    ApplicationArea = All;
    // Zapobiegamy wywoływaniu błędów i zamieszania dla użytkownika przy chęci modyfikacji na żywym organizmie wprost z listingu. Operacje zapisu/edycji kierujemy na odrębną kartotekę.
    Editable = false;
    // Odniesienie i link logiczny pomiędzy główną listą encji, a ich pojedynczym odpowiednikiem - oknem modalnym/karty (CardPageId podwójnym kliknięciem odpala wgląd w "Seminar Room Card")
    CardPageId = "Seminar Room Card";

    // Konfiguracja podziału przestrzennego strony
    layout
    {
        // Sektor powiązany z obszarem dokumentacji bazowej na stronie dla powtarzalnych kontrolek
        area(Content)
        {
            // Kontrolka wyświetlająca tabelaryczny układ iterujący w dół tak długo, aż skończą się zbuforowane widoki od strony tabeli 
            repeater(Group)
            {
                // Kolumna ukazująca unikalny główny klucz powiązany z daną Salą (PK w SQLu) 
                field("Code"; Rec."Code")
                {
                    // Aplikuje widok globalnie na serwerze webowym dla wszystkich tenantów logujących się do tej aplikacji
                    ApplicationArea = All;
                }
                
                // Kolumna posiadająca zwyczajową nazwę lub oznaczenie zrozumiałe dla ludzkiego oka 
                field("Name"; Rec."Name")
                {
                    // Uwidocznia kontrolkę po stronie serwera aplikacji webowej
                    ApplicationArea = All;
                }
                
                // Dane geograficzne, np. Ulica 
                field("Address"; Rec."Address")
                {
                    // Aplikuje widok
                    ApplicationArea = All;
                }
                
                // Informacja o Miejscowości z tabeli Sali (często autouzupełniana z kodu PNA w tabeli)
                field("City"; Rec."City")
                {
                    // Aplikuje widok
                    ApplicationArea = All;
                }
                
                // Identyfikator kodu pocztowego powiązany z konkretnym regionem w strukturach centralnych 
                field("Post Code"; Rec."Post Code")
                {
                    // Aplikuje widok
                    ApplicationArea = All;
                }
                
                // Dane odnośnie skrótu państwa z klasycznej struktury adresowej Dynamics (Pomocne przy wielonarodowych ośrodkach wynajmu)
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    // Aplikuje widok
                    ApplicationArea = All;
                }
                
                // Zwykła informacyjna ramka do prezentowania namiaru z telefonu kontaktowego przypisanego na salę 
                field("Phone No."; Rec."Phone No.")
                {
                    // Aplikuje widok 
                    ApplicationArea = All;
                }
            }
        }
    }
}
