// Strona "Seminar Registration Card" (Kartoteka rejestracji na szkolenie)
// Główny dokument typu nagłówek-szczegóły (Dokument), przypominający okno z Fakturą Sprzedaży.
// Tu operacyjnie rejestruje się i planuje pojedynczą edycję szkolenia oraz na podformularzu wpisuje klientów (uczestników).
page 50040 "Seminar Registration Card"
{
    // Konfiguracja strony jako dokument (karta edycji jednego zasobu/nagłówka na raz)
    PageType = Card;
    // Wyświetlana etykieta u góry widoku okna przeglądarki klienta 
    Caption = 'Seminar Registration Card';
    // Link relacyjny prowadzący wprost do Nagłówka Szkolenia z którego ta strona buduje siatkę danych
    SourceTable = "Seminar Registration Header";
    // Konfiguruje pasek tytułowy okna, by doklejał klucz identyfikacyjny (pole "No."), by przy 10 otwartych kartach łatwo rozróżnić edycje np. "Seminar Registration Card - SR-1001"
    DataCaptionFields = "No.";

    // Warstwa zarządzania ułożeniem graficznym i podziałem informacji po stronie interfejsu klienta AL 
    layout
    {
        // Obszar na wprowadzanie zmiennych do rekordu
        area(Content)
        {
            // Pierwszy blok podsumowujący absolutnie najważniejsze i obligatoryjne z punktu widzenia organizatora dane
            group(General)
            {
                // Tytuł na pierwszej szybciej zakładce z góry
                Caption = 'General';
                
                // Identyfikator w postaci twardego numeru porządkowego wygenerowanego dla szkolenia 
                field("No."; Rec."No.")
                {
                    // Prezentuje okno w UI w całej rozciągłości logiki systemu
                    ApplicationArea = All;
                }
                
                // Pole z Data rozpoczęcia całego procederu (Czas przebywania na sali szkoleniowej)
                field("Starting Date"; Rec."Starting Date")
                {
                    // Ujawnienie ukrycia logiki 
                    ApplicationArea = All;
                }

                // Odniesienie do identyfikatora szkoleniowego w słowniku 
                field("Seminar Code"; Rec."Seminar Code")
                {
                    // Ujawnienie
                    ApplicationArea = All;
                }
                
                // Widok pełnej tekstowej wyciągniętej wprost ze słownika nazwy przypisanego szkolenia
                field("Seminar Name"; Rec."Seminar Name")
                {
                    // Aktywne powiązanie w przestrzeniach 
                    ApplicationArea = All;
                }
                
                // Numer ID kadrowego / zewnętrznego podwykonawcy (Z tabeli Instructor)
                field("Instructor Code"; Rec."Instructor Code")
                {
                    // Aktywne
                    ApplicationArea = All;
                }
                
                // Przepisany wirtualnie (FlowFieldem lub na sztywno po walidacji pola 5) Imię i Nazwisko prowadzącego
                field("Instructor Name"; Rec."Instructor Name")
                {
                    // Wyświetlenie we wszystkich sferach aplikacji
                    ApplicationArea = All;
                }
                
                // Moment obiegowy, czyli od jakiego dnia proces zostanie wrzucony w tryby finansowe czy archiwizacyjne (Księgowanie)
                field("Posting Date"; Rec."Posting Date")
                {
                    // Opcja uwidocznienia
                    ApplicationArea = All;
                }

                // Bieżący etap na którym znajduje się planowana edycja
                field("Status"; Rec."Status")
                {
                    // Opcja uwidocznienia w każdej kompilacji 
                    ApplicationArea = All;
                }
                
                // Skopiowany przelicznik dniowo / godzinowy określający jak długo dana grupa będzie siedzieć z Instruktorem 
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    // Aktywne 
                    ApplicationArea = All;
                }

                // Informacja progu przerywalności / decydującym o uruchomieniu cyklu
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    // Aktywne wszędzie 
                    ApplicationArea = All;
                }

                // Próg blokujący - nadmiar uczestników. Walidowany w głębi w stosunku do parametru pojemności "Seminar Room"
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    // Uprawnienie widoku we wszystkich modułach dla operatora
                    ApplicationArea = All;
                }

                // Informacja pieniężna nakładana początkowo (i dająca się tu uedytować z wyzwalaczem modyfikującym cenniki jednostkowe na liniach)
                field("Seminar Price"; Rec."Seminar Price")
                {
                    // Ujawnienie
                    ApplicationArea = All;
                }
                
                // Pieniężne FlowField - wirtualne i sumaryczne potężne zapytanie dające u góry dokumentu wgląd we wszystkie spieniężone wiersze razem wzięte za to szkolenie!
                field("Amount"; Rec."Amount")
                {
                    // Aplikuje widoczność w interfejsie standardowym jak i mobilnym
                    ApplicationArea = All;
                }
            }
            
            // Zupełnie osobny pasek FastTab wytypowany by oddzielić "logistykę lokalizacyjną" od spraw finansowo planistycznych. 
            group("Seminar Room")
            {
                // Hasło wyskakujące na drugiej zakładce po "General"
                Caption = 'Seminar Room';
                
                // KOD przypisujący zasób lokalizacyjny (Np. Wynajętą salę w innym państwie, lub we własnym gmachu uczelni) z tabeli pokoi
                field("Seminar Room Code"; Rec."Seminar Room Code")
                {
                    // Bez zabezpieczeń dostępowych w sferach licencyjnych 
                    ApplicationArea = All;
                }
                
                // Skopiowana etykieta pokoju na wypadek, gdyby sala zmieniła od wczoraj nazwę to w starym zeszłorocznym dokumencie pozostanie tu "Nazwa z momentu powołania i zatwierdzenia dokumentu" 
                field("Seminar Room Name"; Rec."Seminar Room Name")
                {
                    // Zasięg ApplicationArea
                    ApplicationArea = All;
                }
                
                // Skopiowane z zasobu adresy ulicy Sali do np. powiadamiania mailem gdzie mają studenci dojechać.
                field("Seminar Room Address"; Rec."Seminar Room Address")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }
                
                // Kopia dla numeru pokoju 
                field("Seminar Room Address 2"; Rec."Seminar Room Address 2")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }
                
                // Kopia dla PNA na dokumentację potwierdzającą w systemie raportowym 
                field("Seminar Room Post Code"; Rec."Seminar Room Post Code")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }

                // Kopia dla PNA, Miasta Miejscowości Sali
                field("Seminar Room City"; Rec."Seminar Room City")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }

                // Kopia na numer kontaktowy gdzie podzwonić jak rzutnik ulegnie awarii - pobrane wprost podczas zmiany RoomCode!
                field("Seminar Room Phone No."; Rec."Seminar Room Phone No.")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }

            }
            
            // To jedno z ważniejszych miejsc definiowania hierarchii Master-Detail (Nagłówek-Wiersze)
            // Sekcja ta podpina inną stronę (typ podstrony - ListPart) z wierszami rejestracji i integruje ją w wizualną część okna niżej!
            part(SeminarLines; "Seminar Registration Subpage")
            {
                // Hasło nadające nazwę ramce z podformularzem "Wiersze"
                Caption = 'Lines';
                // Bardzo istotny most spinający dane! Podstrona jest filtrowana by widzieć jedynie te uczestnictwa, które mają identyczny numer Nagłówka jak my (Pole "No.")! To zapobiega wyciekom uczestników ze szkolenia 1 do okna szkolenia 2.
                SubPageLink = "Seminar Registration No." = field("No.");
                // Udostępnienie wyświatlania w ramach RoleCenter i każdego panelu poszukiwań "Tell Me" na All. 
                ApplicationArea = All;
            }
        }
    }

    // Blok akcji interfejsu (Ribbon bar) 
    actions
    {
        area(Processing)
        {
            // Nowa akcja realizująca zadanie z wywoływaniem fakturowania (Codeunit 50010)
            action(CreateSalesInvoice)
            {
                Caption = 'Utwórz fakturę sprzedaży';
                Image = CreateDocument;
                // Wyświetlanie przycisku wysoko na głównym pasku (Promoted)
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                // Wyzwalacz zachodzący po kliknięciu klawisza przez użytkownika
                trigger OnAction()
                var
                    SeminarManagement: Codeunit "Seminar Management";
                begin
                    // Wywołanie wcześniej uzupełnionej i przetestowanej procedury na obecnym rekordzie (Rec)
                    SeminarManagement.CreateSalesInvoice(Rec);
                end;
            }
        }
    }
}
