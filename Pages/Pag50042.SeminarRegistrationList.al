// Strona "Seminar Registration List" (Lista rejestracji na szkolenia)
// Zbiorcze podsumowanie i zestawienie dokumentów będących poszczególnymi edycjami kursów z przypiętymi danymi podstawowymi.
// Widok przypominający wykaz faktur lub ofert w systemie, idealny do filtrowania i tworzenia raportów masowych w Excelu.
page 50042 "Seminar Registration List"
{
    // Ustala ten widok kaskadowo w rzędy jako Listę w WebKliencie
    PageType = List;
    // Oznacza ten nagłówek listowy w interfejsie po polsku/angielsku w zależności od translacji jako 'Seminar Registrations'
    Caption = 'Seminar Registrations';
    // Określa encję będącą rodzicem danych - w tym układzie Nagłówek Szkolenia dostarczający statystyki na każdy wiersz z tej listy
    SourceTable = "Seminar Registration Header";
    // Katalogowanie, by systemowa wyszukiwarka klasyfikowała to jako wykaz dokumentów (Lists) a nie ustawienia
    UsageCategory = Lists;
    // Widoczność strony odznaczona w każdej ewentualnie udostępnionej instancji / obszarze Business Central dla klienta
    ApplicationArea = All;
    // Dedykujemy temu obiektowi bycie tylko i wyłącznie prezentatorem (odpytującym z bazy SQL Read-Only Mode), z racji że lista dokumentów.
    Editable = false;
    // Skierowanie interakcji dwukrotnego kliknięcia lewym myszy by otworzyła okno szczegółów z edycją do wpisu (Kartotekę)
    CardPageId = "Seminar Registration Card";

    // Konfiguracja matrycy z wylistowanymi w pionie zestawieniami wpisów dla wszystkich szkoleń
    layout
    {
        // Główne rusztowanie
        area(Content)
        {
            // Konstrukcja wywołująca sekwencję powtarzania kolumn z rzędami tak długo aż serwer przestanie wysyłać odfiltrowane pakiety danych
            repeater(Group)
            {
                // Kod dokumentu z Nagłówka - "Numer 1, Numer 2..."
                field("No."; Rec."No.")
                {
                    // Ustalenie by z każdej licencji wyświetlało kolumnę
                    ApplicationArea = All;
                }
                
                // Ustalona data startu i początku rezerwacji dla grupy w sali
                field("Starting Date"; Rec."Starting Date")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }
                
                // Identyfikator wyciągniętego z biblioteki i odnośnego szkolenia by wiedzieć jaki profil tematyczny realizuje dana edycja dokumentu (np Excel Śr-Zaawansowany)
                field("Seminar Code"; Rec."Seminar Code")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }
                
                // Zrozumiała nazwa dla użytkownika biurowego
                field("Seminar Name"; Rec."Seminar Name")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }
                
                // Prezentuje pełne nazwisko delegowanego przez uczelnię lub firmę prowadzącego Instruktora dla tej edycji
                field("Instructor Name"; Rec."Instructor Name")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }
                
                // Ważna, zmienna w czasie flaga określająca co się dzieje z życiem i procesem edycji ("Planowanie", "Zakończono")
                field("Status"; Rec."Status")
                {
                    // Zasięg wyświetlania
                    ApplicationArea = All;
                }
            }
        }
    }

    // Struktura dodająca górny pasek nawigacyjny z przyciskami narzędzi (Ribbon Bar)
    actions
    {
        // Obszar na wprowadzanie rutynowych, procesujących zadania i przeliczających klawiszy funkcyjnych.
        area(Processing)
        {
            // Konkretny element interfejsu (Opcja do kliknięcia) eksportująca dane do zewnętrznego środowiska XML 
            action(ExportXML)
            {
                // Polskojęzyczny lub zdefiniowany bazowo tytuł wyświetlany na guziku - "Export XML"
                Caption = 'Export XML';
                // Narzuca obecność tego klawisza do wszystkich profili UI na tenancie i wszystkich modułach odblokowanych aplikacyjnie!
                ApplicationArea = All;

                // Kod blokujący zdarzenie nacisnięcia i egzekwujący zadanie
                trigger OnAction()
                begin
                    // Uruchamia potężny obiekt z bazy AL typu Xmlport - służący do bezpiecznej i formatowanej seryjnej produkcji plików zgodnych z Extensible Markup Language do przesyłania uczestników za zewnątrz. (Nomenklatura - ID XMLPortu = Export Seminar Participants) 
                    Xmlport.Run(Xmlport::"Export Seminar Participants");
                end;
            }
        }
    }
}
