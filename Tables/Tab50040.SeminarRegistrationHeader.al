table 50040 "Seminar Registration Header"
{
    Caption = 'Seminar Registration Header';

    fields
    {
        field(1; "No."; Code[20]) //2.6 typ code length 20
        {
            Caption = 'No.';
        }

        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            /* 4.4 Można zmienić wartość pola Starting Date tylko, gdy status ma wartość Planowane */
            trigger OnValidate()
            begin
                if Status <> Status::Planning then
                    Error(StartingDateStatusErr);
            end;
        }

        field(3; "Seminar Code"; Code[20]) //2.6 typ code length 20
        {
            Caption = 'Seminar Code';
            /* 2.6 Relacja do tabeli Seminar
               4.4 Można wybrać tylko szkolenie, które nie jest zablokowane
             */
            TableRelation = Seminar where(Blocked = const(false));

            trigger OnValidate()
            var
                Seminar: Record Seminar;
                SeminarRegLine: Record "Seminar Registration Line";
            begin
                SeminarRegLine.Reset();
                SeminarRegLine.SetRange("Seminar Registration No.", "No.");
                SeminarRegLine.SetRange(Registered, true);
                /* 4.4 
                Pole Seminar Code można zmienić (czyli wybrać inną wartość) tylko, gdy wiersze rejestracji
                szkolenia nie zostały jeszcze zarejestrowane */
                if SeminarRegLine.FindFirst() then
                    Error(SeminarWithRegisteredLinesModifyErr);
                /* 4.4
                Seminar Code – kiedy użytkownik wybierze kod szkolenia, 
                powinny zostać uzupełnione
                pola: Seminar Name, Seminar Duration, 
                Minimum Participants, Maximum
                Participants, Seminar Price. */
                if Seminar.Get("Seminar Code") then begin
                    "Seminar Name" := Seminar.Name;
                    "Seminar Duration" := Seminar."Seminar Duration";
                    "Minimum Participants" := Seminar."Minimum Participants";
                    "Maximum Participants" := Seminar."Maximum Participants";

                    Validate("Seminar Price", Seminar."Seminar Price");
                end else begin
                    "Seminar Name" := '';
                    "Seminar Duration" := 0;
                    "Minimum Participants" := 0;
                    "Maximum Participants" := 0;
                    "Seminar Price" := 0;
                end;
            end;
        }

        field(4; "Seminar Name"; Text[50]) //2.6 typ text length 50
        {
            Caption = 'Seminar Name';
        }

        field(5; "Instructor Code"; Code[20]) //2.6 typ code length 20
        {
            Caption = 'Instructor Code';
            /* 2.6 Relacja do tabeli Instructor */
            TableRelation = Instructor;

            /*4.4 
            Kiedy użytkownik wprowadzi lub zmieni pole Instructor Code automatycznie zostanie
            odświeżone pole Instructor Name. 
            Uwaga: należy skorzystać z funkcji dedykowanej do pól
            typu FlowField, bo takim jest Instructor Name. */
            trigger OnValidate()
            begin
                CalcFields("Instructor Name");
            end;
        }

        field(6; "Instructor Name"; Text[100]) //2.6 typ text length 100
        {
            Caption = 'Instructor Name';
            FieldClass = FlowField;
            /* 2.6
            FlowField typu Lookup do
            odpowiedniej krotki tabeli
            Instructor, pole nieedytowalne */
            CalcFormula = lookup(Instructor.Name where(Code = field("Instructor Code")));
            Editable = false;
        }

        field(7; Status; Option)
        {
            Caption = 'Status';
            /* 2.6
            Pole typu Option
            Opcje: Planning, Registration,
            Finished, Cancelled */
            OptionMembers = Planning,Registration,Finished,Cancelled;
            OptionCaption = 'Planning,Registration,Finished,Cancelled';
        }

        field(8; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            /* 2.6 Decimal Places 0:1 */
            DecimalPlaces = 0 : 1;
        }

        field(9; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }

        field(10; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }

        field(11; "Seminar Room Code"; Code[20]) //2.6 typ code length 20
        {
            Caption = 'Seminar Room Code';
            /* 2.6 Relacja do tabeli "SeminarRoom" */
            TableRelation = "Seminar Room";

            trigger OnValidate()
            var
                SeminarRoom: Record "Seminar Room";
            begin
                if SeminarRoom.Get("Seminar Room Code") then begin
                    /* 4.4 
                    kiedy użytkownik wybierze kod sali szkoleniowej, to system
                    wyświetli ostrzeżenie, jeśli wybrana sala ma pojemność mniejszą niż maksymalna
                    liczba uczestników wybranego szkolenia. */
                    if SeminarRoom."Maximum Participants" < "Maximum Participants" then
                        Message(RoomCapacityWarnMsg);
                    /* 4.4
                    Następnie powinny zostać uzupełnione pola:
                    Seminar Room Name, Seminar Room Address, Seminar Room Address 2, 
                    Seminar Room, Post Code, Seminar Room City, Seminar Room Phone No. */
                    "Seminar Room Name" := SeminarRoom.Name;
                    "Seminar Room Address" := SeminarRoom.Address;
                    "Seminar Room Address 2" := SeminarRoom."Address 2";
                    "Seminar Room Post Code" := SeminarRoom."Post Code";
                    "Seminar Room City" := SeminarRoom.City;
                    "Seminar Room Phone No." := SeminarRoom."Phone No.";

                end else begin
                    "Seminar Room Name" := '';
                    "Seminar Room Address" := '';
                    "Seminar Room Address 2" := '';
                    "Seminar Room Post Code" := '';
                    "Seminar Room City" := '';
                    "Seminar Room Phone No." := '';
                end;
            end;
        }


        field(12; "Seminar Room Name"; Text[50]) //2.6 typ text length 50
        {
            Caption = 'Seminar Room Name';
        }

        field(13; "Seminar Room Address"; Text[50]) //2.6 typ text length 50
        {
            Caption = 'Seminar Room Address';
        }

        field(14; "Seminar Room Address 2"; Text[50]) //2.6 typ text length 50
        {
            Caption = 'Seminar Room Address 2';
        }

        field(15; "Seminar Room Post Code"; Code[20]) //2.6 typ code length 20
        {
            /* 2.6 Relacja do tabeli 225 "PostCode" */
            Caption = 'Seminar Room Post Code';
            TableRelation = "Post Code";
        }

        field(16; "Seminar Room City"; Text[30]) //2.6 typ text length 30
        {
            Caption = 'Seminar Room City';
        }

        field(17; "Seminar Room Phone No."; Text[30]) //2.6 typ text length 30
        {
            Caption = 'Seminar Room Phone No.';
        }

        field(18; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';

            trigger OnValidate()
            var
                SeminarLine: Record "Seminar Registration Line";
            begin
                // 4.4 Jeśli użytkownik zmieni pole Seminar Price (status różny od Cancelled)
                if Status = Status::Cancelled then
                    exit;

                if xRec."Seminar Price" = "Seminar Price" then
                    exit;
                //4.4 system pyta, czy zaktualizować pole Seminar Price
                if Confirm(UpdateLinesQst, false) then begin
                    /* 4.4 
                    zaktualizuje wszystkie niezarejestrowane wiersze (czyli
                    ustawi w niezarejestrowanych wierszach pole Seminar Price na nową wartość podaną w
                    nagłówku rejestracji. */
                    SeminarLine.Reset();
                    SeminarLine.SetRange("Seminar Registration No.", "No.");
                    SeminarLine.SetRange(Registered, false);

                    if SeminarLine.FindSet() then
                        repeat
                            SeminarLine.Validate("Seminar Price", "Seminar Price");
                            SeminarLine.Modify(true);
                        until SeminarLine.Next() = 0;
                end;
            end;
        }

        field(20; Amount; Decimal)
        {
            Caption = 'Amount';
            /* 2.6
            FlowField, suma odpowiednich
            kwot z tabeli "Seminar
            Registration Line" */
            FieldClass = FlowField;
            CalcFormula = sum("Seminar Registration Line".Amount
                where("Seminar Registration No." = field("No.")));
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    /* 4.4
    Podczas wstawiania rekordu należy ustawić 
    domyślne wartości pól:
    • Posting Date – wypełnić datą roboczą */
    trigger OnInsert()
    begin
        "Posting Date" := WorkDate();
    end;
    /* 4.4 Można usuwać tylko rekordy ze statusem Planowane lub Odwołane */
    trigger OnDelete()
    begin
        if not (Status in [Status::Planning, Status::Cancelled]) then
            Error(DeleteStatusErr);
    end;
    /*  4.4 Nie można zmienić nazwy (czyli wartości klucza głównego) rekordu. */
    trigger OnRename()
    begin
        Error(RenameErr);
    end;

    var
        SeminarWithRegisteredLinesModifyErr: Label 'Nie można modyfikować seminarium z zarejestrowanymi wierszami.';
        StartingDateStatusErr: Label 'Data rozpoczęcia może być zmieniona tylko dla statusu Planowanie.';
        DeleteStatusErr: Label 'Można usunąć tylko rejestracje o statusie Planowanie lub Anulowano.';
        RenameErr: Label 'Zmiana numeru rejestracji jest niedozwolona.';
        RoomCapacityWarnMsg: Label 'Pojemność sali jest mniejsza niż maksymalna liczba uczestników seminarium.';
        UpdateLinesQst: Label 'Czy chcesz zaktualizować cenę seminarium we wszystkich niezarejestrowanych wierszach?';
}