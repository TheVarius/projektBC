table 50030 "Seminar Room"
{
    Caption = 'Seminar Room';
    DataCaptionFields = "Code", Name;

    fields
    {
        field(1; "Code"; Code[20]) //2.4 typ code length 20
        {
            Caption = 'Code';
        }

        field(2; Name; Text[50]) //2.4 typ text length 50
        {
            Caption = 'Name';
        }

        field(3; Address; Text[50]) //2.4 typ text length 50
        {
            Caption = 'Address';
        }

        field(4; "Address 2"; Text[50]) //2.4 typ text length 50
        {
            Caption = 'Address 2';
        }

        field(5; City; Text[30]) //2.4 typ text length 30
        {
            Caption = 'City';
        }

        field(6; "Post Code"; Code[20]) //2.4 typ code length 20
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            // 4.3 Post Code – po wybraniu kodu pocztowego system ma uzupełnić pole City.
            trigger OnValidate()
            var
                PostCodeRec: Record "Post Code";
                DummyCounty: Text[30];
            begin
                if PostCodeRec.Get("Post Code", "Country/Region Code") then
                    City := PostCodeRec.City;

                PostCode.ValidatePostCode(
                    City,
                    "Post Code",
                    DummyCounty,
                    "Country/Region Code",
                    (CurrFieldNo <> 0) and GuiAllowed());
            end;
        }

        field(7; "Country/Region Code"; Code[10]) //2.4 typ code length 10
        {
            Caption = 'Country/Region Code';
            /* 2.4
            Relacja do tabeli 9 "Country/Region"
            */
            TableRelation = "Country/Region";
        }

        field(8; "Phone No."; Text[30]) //2.4 typ text length 30
        {
            Caption = 'Phone No.';
        }

        field(9; "Fax No."; Text[30]) //2.4 typ text length 30
        {
            Caption = 'Fax No.';
        }

        field(10; "Name 2"; Text[50]) //2.4 typ text length 20
        {
            Caption = 'Name 2';
        }

        field(11; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }

        field(12; "Internal/External"; Option)
        {
            /* 2.4
            Pole typu Option
            Opcje:
            - Internal
            - External
            */
            Caption = 'Internal/External';
            OptionMembers = Internal,External;
            OptionCaption = 'Internal,External';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    var
        PostCode: Record "Post Code";
}