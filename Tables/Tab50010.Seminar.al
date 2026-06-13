table 50010 Seminar
{
    Caption = 'Seminar';
    DataCaptionFields = "Code", Name;

    fields
    {
        field(1; "Code"; Code[20]) //2.1 typ code length 20
        {
            Caption = 'Code';
        }

        field(2; Name; Text[50]) //2.2 typ Text length 50
        {
            Caption = 'Name';
            /* 4.1 
            Name – kiedy użytkownik wprowadzi 
            lub zmieni pole Name,
            należy uzupełnić pole
            Search Name (wielkie litery). */
            trigger OnValidate()
            begin
                if "Search Name" <> UpperCase(Name) then
                    "Search Name" := UpperCase(Name);
            end;
        }

        field(3; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1; //2.2 Decimal places 0:1
        }

        field(4; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }

        field(5; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }

        field(6; "Search Name"; Code[50]) //2.2 typ code length 50
        {
            Caption = 'Search Name';
        }

        field(7; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }

        field(8; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false; //2.2 Pole nieedytowalne
        }

        field(9; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    /*4.1
    Last Date Modified – kiedy rekord zostanie
    zmodyfikowany automatycznie, należy
    uzupełnić to pole datą roboczą. */

    trigger OnModify()
    begin
        "Last Date Modified" := WorkDate();
    end;
}