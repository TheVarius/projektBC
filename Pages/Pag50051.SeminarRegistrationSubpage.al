// Strona "Seminar Registration Subpage" (Podstrona wierszy rejestracji)
// Typowo zaprojektowana jako okno wylistowania podczepiane i osadzane jako "Dziecko" (Child) na głównej formie dokumentu w sekcji 'part'.
// Pokazuje, weryfikuje oraz edytuje detale pojedynczych zwerbowanych Nabywców pod ten konkretnie odfiltrowany z góry szkoleniowy numer Nagłówka.
page 50051 "Seminar Registration Subpage"
{
    // Systemowe zdefiniowanie specyfiki bycia częścią - oddelegowuje wyświetlanie całego "wielkiego" layoutu a przystosowuje stronę do wstrzyknięcia jej jedynie jako małej rameczki osadzonej wewnątrz PageType Card (ListPart) 
    PageType = ListPart;
    // Oznacza ramkę w razie potrzeby wyciągania osobno, w naszym układzie jest to wpisane również w 'Card' z góry
    Caption = 'Lines';
    // Oparcie modelu biznesowego kontrolki o tabelę Line (szczegółów w systemie N->1 Master Detail). To powiązanie pobiera rekordy przypisanej logiki fakturowej klienta.
    SourceTable = "Seminar Registration Line";
    // Bardzo pożyteczna optymalizacja! Ustawia by komitowanie i transakcyjny zapis wstawianego nowego uczestnika na ten pusty wiersz poczekał, aż użytkownik opuści linię by zapisać wprowadzane po kolei "Nabywca"-> "Cena" -> "Rabat". Przyspiesza i niweluje martwe wpisy w SQL.
    DelayedInsert = true;
    // Opcja dodająca niesamowitą zaletę modułowi ERP. Jeśli u góry podpięty "No." ma linię "Line No" 10000 i 20000 a ja zechcę wcisnąć pomiędzy nie nowego typka, to BC po zaznaczeniu AutoSplitKey dorzuci mi sam "15000" nie niszcząc indeksów u dołu. Ułatwia wstawianie "pomiędzy".
    AutoSplitKey = true;

    // Miejsce prezentacyjne podformularza
    layout
    {
        // Określa powiązanie robocze (Zawartość edytowalna pod listę)
        area(Content)
        {
            // Ponownie repeater, by wyświetlić dane "Dziecka" dla wierszy iteracyjnie tak by zbudowało kaskadowo Excelową siatkę formularza w ramce partu (Sekcji linii).
            repeater(Group)
            {
                // Kolumna ukazująca kod firmy zaangażowanej w proces opłacania faktur uczestnika
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    // Widoczność nadana uprawnieniami domyślnymi All z kompilatora Dynamics 365 
                    ApplicationArea = All;
                }
                
                // Kolumna z kodem z bazy adresów Kontaktów CRM (Prawdziwy z krwi i kości Iksiński wpisywany po nrze)
                field("Participant Contact No."; Rec."Participant Contact No.")
                {
                    // Ustalenie obszaru w którym dana kontrolka ma sens bytu na platformie. Tutaj wszędzie. 
                    ApplicationArea = All;
                }
                
                // Kolumna zaciągana wirtualnym bytem z tabeli powiązanej - prezentująca w czytelnym formacie pełną informację personalną "Adam Nowak"
                field("Participant Name"; Rec."Participant Name")
                {
                    // Widoczność
                    ApplicationArea = All;
                }
                
                // Kolumna operacyjna odnotowująca fizyczny dzień "przypieczętowania" jego zgłoszenia na szkoleniu z datownikiem na zablokowanie zmian klienta
                field("Register Date"; Rec."Register Date")
                {
                    // Ustalenie globalnej widoczności w module AL aplikacji by zapobiegać błędom dla innych ról używających tej list-partycji np. asystentom 
                    ApplicationArea = All;
                }
                
                // Kolumna prezentująca termin zaakceptowania w pełni potwierdzenia od Nabywcy na bycie w tym kursie 
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    // Widoczność modułowa
                    ApplicationArea = All;
                }
                
                // Kolumna pobierająca cennik zdefiniowany i odgórnie wrzucony tu przez trigger na wyższym poziome Nagłówka. Wylicza pole Amount po odliczeniu pola Discount!
                field("Seminar Price"; Rec."Seminar Price")
                {
                    // Nadanie widoczności
                    ApplicationArea = All;
                }
                
                // Kolumna ze sztucznie (Ręcznie) nałożonym przez kasjera upustem na udział by móc korygować odrębną strategię biznesową na uczestniku od Nabywcy (Zniżka na bilety X procent na pozycję numer Y).
                field("Line Discount %"; Rec."Line Discount %")
                {
                    // Pokaz we wszystkich modułach licencyjnych 
                    ApplicationArea = All;
                }
                
                // Kolumna operacyjna wprost wykazująca o ile matematycznie zbijana jest cena podstawowa dla Iksińskiego (Ustawienie obniżania np 40 Euro)
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    // Pokaz
                    ApplicationArea = All;
                }
                
                // Wyliczony ułamek wartości bazowej pomniejszonej i sfinalizowanej po wszystkich rabatach, to co "płaci nabywca za Jana" sumowane ze wszystkimi innymi Nabywcami podliczone w FlowField na samej górze w nagłówku jako Suma Zysków Edycji (Amount)
                field("Amount"; Rec."Amount")
                {
                    // Pokaz bez ograniczeń podlicencjowych czy modułowych (Essential, Premium wylaczone by wszystko działo)
                    ApplicationArea = All;
                }
                
                // CheckBox decydujący by wysyłać dyspozycję czy Nabywcę na tę pozycję będzie stać fakturować, tak by system przepisał to pod proces 'tworzenia faktury VAT po szkoleniach'
                field("To Invoice"; Rec."To Invoice")
                {
                    // Odznaczone pole 
                    ApplicationArea = All;
                }
                
                // Checkbox organizacyjny. Przypisuje w triggerze "Register Date" na datę WorkDate() odcinając Nabywcę i pozycję od usunięcia bądź modyfikacji wstecz. 
                field("Registered"; Rec."Registered")
                {
                    // Udostępnia kontrolkę interaktywną na froncie dla każdej aplikacji odpalającej ten layout 
                    ApplicationArea = All;
                }
                
                // Pole będące dowodem ostatecznym ukończenia obozu dla celów np. posprzedażnych kampanii lub druku zaświadczeń dla kadry Płatnika 
                field("Participated"; Rec."Participated")
                {
                    // Ekspozycja
                    ApplicationArea = All;
                }
                
                // Uzupełniane rzadko z palca a często z procesu fakturowania pole z relacją ścisłą do systemowej struktury i kartoteki Wysłanej Faktury Sprzedaży ERP Dynamicsa (Sales Header type Invoice). Nierozerwalny łącznik obiegowy pieniądza. 
                field("Invoice No."; Rec."Invoice No.")
                {
                    // Ustalona wartość All na udostępnienie w systemowym widoku dla ListPartu 
                    ApplicationArea = All;
                }
            }
        }
    }
}
