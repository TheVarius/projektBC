table 50050 "Seminar Registration Line"
{
    Caption = 'Seminar Registration Line';

    fields
    {
        field(1; "Seminar Registration No."; Code[20]) //2.6 typ code length 20
        {
            Caption = 'Seminar Registration No.';
            /* 2.7 Relacja do tabeli
            „Seminar Registration
            Header” */
            TableRelation = "Seminar Registration Header";
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(3; "Bill-to Customer No."; Code[20]) //2.6 typ code length 20
        {
            Caption = 'Bill-to Customer No.';
            /* 2.7 Relacja do tabeli 18 „Customer” */
            TableRelation = Customer;
            //4.5 Można zmieniać wartość pola Bill-to Customer No. tylko dla niezarejestrowanego wiersza.
            trigger OnValidate()
            begin
                if Registered then
                    Error(ChangeCustomerErr);
            end;
        }

        field(4; "Participant Contact No."; Code[20]) //2.6 typ code length 20
        {
            Caption = 'Participant Contact No.';
            /* 2.7 Relacja do tabeli 5050 „Contact” */
            TableRelation = Contact;

            trigger OnValidate()
            begin
                CalcFields("Participant Name");
            end;
            /* 4.5
            Participant Contact No. – kiedy użytkownik wyświetli listę kontaktów, powinny być
            widoczne tylko te skojarzone z płatnikiem faktury Bill-to Customer No. */
            trigger OnLookup()
            var
                Contact: Record Contact;
                ContactBusinessRelation: Record "Contact Business Relation";
            begin
                if "Bill-to Customer No." = '' then
                    exit;
                /*4.5 
                Należy wykorzystać tabelę Customer (18) oraz tabelę Contact (5050) połączone 
                ze sobą poprzeztabelę Contact Business Relation (5054). */
                ContactBusinessRelation.Reset();
                ContactBusinessRelation.SetRange("Link to Table",
                    ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("No.", "Bill-to Customer No.");

                if ContactBusinessRelation.FindFirst() then begin
                    Contact.Reset();
                    Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
                    if Page.RunModal(Page::"Contact List", Contact) = Action::LookupOK then
                        Validate("Participant Contact No.", Contact."No.");
                end;
            end;
        }

        field(5; "Participant Name"; Text[100]) //2.6 typ text length 100
        {
            Caption = 'Participant Name';
            FieldClass = FlowField;
            /* 2.7
            FlowField, Lookup do
            odpowiedniej krotki
            tabeli 5050 “Contact” */
            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));
            Editable = false;
        }

        field(6; "Register Date"; Date)
        {
            Caption = 'Register Date';
            Editable = false; //2.7 Nieedytowalna
        }

        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            //2.7 Domyślna wartość „false”
            InitValue = false;
        }

        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
        }

        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
        }

        field(10; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 2; //2.7 AutoFormatType = 2


            trigger OnValidate()
            begin
                "Line Discount Amount" :=
                    Round("Seminar Price" * "Line Discount %" / 100);

                Amount :=
                    "Seminar Price" - "Line Discount Amount";
            end;
        }

        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5; //2.7 Decimal places 0:5
            /* 2.7 min 0, max 100 */
            MinValue = 0;
            MaxValue = 100;
            //4.5 Line Discount % – obliczenie wartości pól: Line Discount Amount i Amount
            trigger OnValidate()
            begin
                "Line Discount Amount" :=
                    Round("Seminar Price" * "Line Discount %" / 100);

                Amount :=
                    "Seminar Price" - "Line Discount Amount";
            end;
        }

        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            AutoFormatType = 1; //2.7 AutoFormatType = 1
            //4.5 Line Discount Amount – obliczenie wartości pól: Line Discount % oraz Amount.
            trigger OnValidate()
            begin
                if "Seminar Price" <> 0 then
                    "Line Discount %" :=
                        Round(("Line Discount Amount" / "Seminar Price") * 100, 0.00001);

                Amount :=
                    "Seminar Price" - "Line Discount Amount";
            end;
        }

        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1; //2.7 AutoFormatType = 1
            //4.5 Amount – obliczenie wartości pól: Line Discount Amount oraz Line Discount %.
            trigger OnValidate()
            begin
                "Line Discount Amount" :=
                    "Seminar Price" - Amount;

                if "Seminar Price" <> 0 then
                    "Line Discount %" :=
                        Round(("Line Discount Amount" / "Seminar Price") * 100, 0.00001);
            end;
        }

        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            /* 4.5 
            Można zarejestrować wiersz zaznaczając Registered. 
            System powinien wówczas uzupełnić
            pole Register Date wstawiając tam datę roboczą. */
            trigger OnValidate()
            begin
                if Registered then
                    "Register Date" := WorkDate()
                else
                    "Register Date" := 0D;
            end;
        }

        field(15; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            /*2.7
             Relacja do tabeli 36
            „Sales Header” dla typu
            dokumentu „Invoice”. */
            TableRelation = "Sales Header"."No."
                where("Document Type" = const(Invoice));

            Editable = false; //2.7 Pole nieedytowalne.
        }
        //pod calcfield xml
        field(50000; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Bill-to Customer No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Seminar Registration No.", "Line No.") //2.7 dwuatrybutowy klucz główny
        {
            Clustered = true;
            SumIndexFields = Amount; //2.7 opcja SumIndexFields = Amount
        }
    }

    trigger OnInsert()
    var
        SeminarHeader: Record "Seminar Registration Header";
    /* 4.5
    Rekord podczas wstawiania powinien zostać zainicjalizowany domyślnymi wartościami z
    nagłówka rejestracji:
    • Seminar Price
    • obliczenie pola Amount */
    begin
        if SeminarHeader.Get("Seminar Registration No.") then begin
            Validate("Seminar Price", SeminarHeader."Seminar Price");
            Validate(Amount, "Seminar Price");
        end;
    end;
    //4.6  Można usuwać tylko rekordy niezarejestrowane.
    trigger OnDelete()
    begin
        if Registered then
            Error(DeleteRegisteredErr);
    end;

    var
        DeleteRegisteredErr: Label 'Nie można usunąć zarejestrowanych wierszy.';
        ChangeCustomerErr: Label 'Nr nabywcy można zmienić tylko dla niezarejestrowanych wierszy.';

}