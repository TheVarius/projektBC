// Obiekt typu XMLport "Export Seminar Participants"
// Bardzo silne, natywne narzędzie środowiska Dynamics AL przeznaczone do importu/eksportu i parsowania danych.
// Służy tutaj do wyekstrahowania sformatowanych hierarchicznie danych uczestników szkoleń (wraz z informacjami z nagłówków edycji szkoleń)
// i zapisu ich do strumieniowego formatu znakowanego XML, co pozwala na bezproblemową wymianę na zewnątrz (Integracja EDI, Excel itp.).
//
// OBSŁUGIWANE POLA PRZEZ FRAGMENTY KODU (ZALEŻNOŚCI):
// - trigger OnAfterGetRecord() (w węźle Participant) -> ODCZYTUJE: SeminarRegLine."Bill-to Customer No.", Cust.Name, MODYFIKUJE ZMIENNĄ XML: Customer_Name
xmlport 50070 "Export Seminar Participants"
{
    // Etykieta portu eksportującego wyświetlana jako ewentualny tytuł strony Request Page jeśli występuje 
    Caption = 'Export Seminar Participants';
    // Jedna z najważniejszych dyrektyw silnika - narzuca strukturę pracy portu jako kierunek wylotowy informacji ze środowiska bazodanowego (Read-Only z Bazy -> Write do Pliku .xml)
    Direction = Export;
    // Opcja warunkująca, jakim translatorem posłuży się system strumieniowy. Może to być CSV, Fixed Text lub tutaj najpotężniejszy obiektowy i tagowany Xml. 
    Format = Xml;
    // Ustalanie czy chcemy używać wbudowanego graficznego ekranu filtrowania parametrów przez użytkownika przed właściwym startem algorytmu zrzutu. Daje okno "Request Page" do wpisania np 'Tylko szkolenie numer X'
    UseRequestPage = true;

    // Główna bryła decyzyjna - determinuje wcięciami w kodzie schemat drzewa XML jaki wygeneruje port. 
    schema
    {
        // ------------------
        // POZIOM 1 - ROOT 
        // ------------------
        // Stworzenie wirtualnego, opisowego taga tekstowego nie wywodzącego się z bazy danych, stanowiącego absolutny korzeń (ROOT node) całego wypuszczanego pliku by nie sypało błędami XML.
        // Wygeneruje to w pliku <Seminar_Registration_Participant_List> ... </Seminar_Registration_Participant_List> na samych krańcach wyjścia. 
        textelement(Seminar_Registration_Participant_List)
        {
            // ------------------
            // POZIOM 2 - NAGŁÓWEK 
            // ------------------
            // Węzeł drugiego rzędu spięty na sztywno z pętlą przechodzącą sekwencyjnie po tabeli Nagłówka Rejestracji, wiersz bazy pod wierszem by stworzyć tag elementu.
            tableelement(SeminarRegHeader; "Seminar Registration Header")
            {
                // Przedefiniowanie nazwy tagu z długiej i brzydkiej jak wyżej na pożądany zgrabniejszy skrót dla tagu wyjściowego z informacjami ogólnymi (XML <Seminar> ... </Seminar>)
                XmlName = 'Seminar';
                // Optymalizacyjne narzucenie silnikowi, by wymusił przeliczenie wirtualnych zapytan FlowField podciągniętych z innych miejsc na etapie wyciągania dla pola Imienia!
                CalcFields = "Instructor Name";
                // Udostępnienie wybranym polom (po Numerze i Kodzie Szkolenia) miejsca w oknie do filtrowania dla użytkownika (UseRequestPage na froncie interfejsu przed startem).  
                RequestFilterFields = "No.", "Seminar Code";

                // Definicje tagów wewnętrznych (Leaf nodes) elementu nadrzędnego. Silnik automatycznie wpakuje zrekursowaną z "No." informację pomiędzy znaczniki dla każdej pętli:
                // <Registration_No>SR-100</Registration_No>
                fieldelement(Registration_No; SeminarRegHeader."No.")
                {
                    // Brak dedykowanej logiki modyfikującej w samej definicji pola wylotu 
                }

                // Generacja tagu z Kodem przedmiotu szkoleniowego np. BCA
                fieldelement(Seminar_Code; SeminarRegHeader."Seminar Code")
                {
                    // Puste ciało.
                }

                // Generacja pełnej rozbudowanej nazwy
                fieldelement(Seminar_Name; SeminarRegHeader."Seminar Name")
                {
                    // Puste ciało.
                }

                // Generacja znacznika ze sformatowaną systemowo datą rozpoczęcia np. 2026-06-03
                fieldelement(Starting_Date; SeminarRegHeader."Starting Date")
                {
                    // Puste ciało.
                }

                // Generacja znacznika numerycznego dziesiętnego ułamek z czasu
                fieldelement(Seminar_Duration; SeminarRegHeader."Seminar Duration")
                {
                    // Puste ciało.
                }

                // Generacja elementu instruktora o którego poprawne wyliczenie z bazy dba zdefiniowany u góry parametr CalcFields
                fieldelement(Instructor_Name; SeminarRegHeader."Instructor Name")
                {
                    // Puste ciało.
                }

                // Generacja znacznika przechowującego skopiowaną po walidacji wartość przypisaną do udostępnionego obiektu z tabeli Sali (Nazwa sali/Lokalizacja).
                fieldelement(Room_Name; SeminarRegHeader."Seminar Room Name")
                {
                    // Puste ciało.
                }

                // ------------------
                // POZIOM 3 - LINIE (SZCZEGÓŁY UCZESTNIKÓW Z PODFORMULARZA EDYCJI - CHILD NODE)
                // ------------------
                // Drugie wywołanie pętli bazodanowej podczepionej relacyjnie w środek pętli u góry. Tworzy powtarzające się węzły dla każdego uczestnika kursu (Tabela rejestracji Line) dla danego Nagłówka.
                tableelement(SeminarRegLine; "Seminar Registration Line")
                {
                    // Nowy węzeł otworzy się tagiem w formacie <Participant> ... </Participant> pod każdym wyższym tagiem <Seminar> do którego dany wiersz pasuje. 
                    XmlName = 'Participant';
                    // Absolutnie konieczna deklaracja by wiersze szły razem z Nagłówkami zdefiniowanymi wyżej w schemacie wcięć 
                    LinkTable = SeminarRegHeader;
                    // Wytłumaczenie silnikowi jak skorelować iterację linii by wiedzieć że to "Jego wiersze a nie innej edycji szkolenia". Prawdziwa moc tworzenia relacji N->1 gdzie wiersz ma kolumnę "Seminar Registration No." z taką samą treścią co nagłówek z numerem klucza "No." (Relacja Primary Key -> Foreign Key). 
                    LinkFields = "Seminar Registration No." = field("No.");
                    // Ustalanie w algorytmie obiegowym zabezpieczenia (Zero occurrences allowed). Jeśli edycja szkolenia nie ma zapisanego ani jednego wiersza uczestnika, parser ma i tak generować poprawnie sformatowany nagłówek nadrzędny bez zagnieżdżeń (zignoruje błąd "no-child") 
                    MinOccurs = Zero;
                    // Ponowne zadbanie by obliczył nam za kulisami system wartość do pola Participant Name bo jest ono w bazie pustym wektorem połączonym z FlowFieldem i rzuca pustym stringiem
                    CalcFields = "Participant Name";

                    // Znacznik reprezentujący klienta korporacyjnego nabywającego pozycję szkoleniową
                    fieldelement(Customer_No; SeminarRegLine."Bill-to Customer No.")
                    {
                        // Nic tu nie robimy, prosto do pliku eksportuje Nabywce... 
                    }

                    // A TUTAJ TWORZYMY SAMEMU PUCHA-TAG (Wirtualne, zmienne tekstowe)
                    // Nie bierzemy po prostu kolumny z bazy, ale definiujemy zmienną w pamięci RAM 'Customer_Name' by wpakować ją później poprzez customową logikę biznesową napisaną pod spodem do XML'a wewnątrz <Customer_Name>Teks</Customer_Name>. 
                    textelement(Customer_Name)
                    {
                        // Definicja samego znacznika który zostanie podstawiony. Otwarcie klamr.
                    }

                    // Generacja tagu na wpisany manualnie wiersz numeru kontaktu CRM
                    fieldelement(Contact_No; SeminarRegLine."Participant Contact No.")
                    {
                        // Puste ciało.
                    }

                    // Znacznik pod który podstawiona zostanie skalkulowana przez CalcFields przyjacielska nazwa fizycznego słuchacza biorącego udział na ławce obozowej np. "Jan Kowalski" (Name)
                    fieldelement(Participant_Name; SeminarRegLine."Participant Name")
                    {
                        // Puste ciało.
                    }

                    // Wbudowana funkcja API dla XMLPortów w Business Central - Kod uruchamiany wybiórczo PO TYM, JAK zaciągniemy z serwera dane dla KONKRETNEGO pojedynczego iterowanego wiersza a tuż PRZED wstrzyknięciem w struktury zapisywanego formatu w wyjściowym buforze pliku. Umożliwia pisanie sztucznej modyfikacji!
                    trigger OnAfterGetRecord()
                    var
                        // Tymczasowy wektor łączący się na moment z ogromną globalną listą Kontrahentów Nabywców 
                        Cust: Record Customer;
                    begin
                        // Kod zabezpiecza naszą własną sztucznie stworzoną zmienną (textelement) Customer_Name która nie egzystuje w wierszu a ma polecieć do pliku.
                        // Odkrywamy numer Customer No, przesyłamy ułamek zapytania by znaleźć pełną tabelaryczną kartotekę danego klienta
                        if Cust.Get(SeminarRegLine."Bill-to Customer No.") then
                            // Gdy system odnajdzie dopasowanie Nabywcy na wierszu do rekordu, pakujemy uciągnięte z Nabywcy "Name" w naszą sztuczną zmienną (Ustawiamy zmienną globalną bloku pod wyjście)
                            Customer_Name := Cust.Name
                        else
                            // Nie znaleziono go lub usunięto - wypuść pusty znacznik xml bez napisu w środku (zabezpieczenie przed pomyłkami zapamiętanymi w wierszach a wyrzuconymi w Master-słownikach)  
                            Customer_Name := '';
                    end;
                }
            }
        }
    }

    // Dodatkowa, nieobligatoryjna strefa definicji front-endowych. Moduł ekranu zapytaniowego dla XML portu "UseRequestPage = true" wyżej wymaga określenia jego zachowania. Możemy u góry narzucić mu własne niestandardowe kontrolki UI np checkboxy, inputy.
    requestpage
    {
        // Obszar na wprowadzanie opcji wizualnych przed wejściem z klawisza uruchom by przefiltrować logikę przed pobraniem bazy pod kątem eksportu
        layout
        {
            // Puste strefy (używany jest tylko domyślny formularz oparty na uregulowanych z góry propertach np "RequestFilterFields"!)
            area(content)
            {
                // Tutaj system domyślnie wstawi pola do wpisywania filtrowania po kodzie dokumentu i dacie bez naszego udziału w pisaniu logiki na tej ramce.
            }
        }

        // Dodatkowe customowe guziki u góry na oknie przed wysłaniem komendy export by odpalić inne kalkulacje w tle 
        actions
        {
            // Często pozostawiane nieruszone dla typowo bazodanowych zrzutów bez głębszej logiki przed-eksportowej.
            area(processing)
            {
                // Obecnie skrypt nie zawiera niestandardowych modyfikacji dla obszaru przedwstępnego procesu XML'a
            }
        }
    }
}
