table 50050 "Seminar Registration Line"
{
    Caption = 'Seminar Registration Line';

    fields
    {
        field(1; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            TableRelation = "Seminar Registration Header";
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Registered then
                    Error(ChangeCustomerErr);
            end;
        }

        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Contact: Record Contact;
                ContactBusinessRelation: Record "Contact Business Relation";
            begin
                if "Bill-to Customer No." = '' then
                    exit;

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

        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));
            Editable = false;
        }

        field(6; "Register Date"; Date)
        {
            Caption = 'Register Date';
            Editable = false;
        }

        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
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
            AutoFormatType = 2;

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
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;

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
            AutoFormatType = 1;

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
            AutoFormatType = 1;

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
            TableRelation = "Sales Header"."No."
                where("Document Type" = const(Invoice));

            Editable = false;
        }
    }

    keys
    {
        key(PK; "Seminar Registration No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }

    trigger OnInsert()
    var
        SeminarHeader: Record "Seminar Registration Header";
    begin
        if SeminarHeader.Get("Seminar Registration No.") then begin
            Validate("Seminar Price", SeminarHeader."Seminar Price");
            Validate(Amount, "Seminar Price");
        end;
    end;

    trigger OnDelete()
    begin
        if Registered then
            Error(DeleteRegisteredErr);
    end;

    var
        DeleteRegisteredErr: Label 'Registered lines cannot be deleted.';
        ChangeCustomerErr: Label 'Bill-to Customer No. can only be changed for unregistered lines.';

}
