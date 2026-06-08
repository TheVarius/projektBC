table 50020 Instructor
{
    Caption = 'Instructor';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }

        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }

        field(3; "Worker/Subcontractor"; Option)
        {
            Caption = 'Worker/Subcontractor';
            OptionMembers = Worker,Subcontractor;
            OptionCaption = 'Worker,Subcontractor';

            trigger OnValidate()
            begin
                if "Worker/Subcontractor" <> xRec."Worker/Subcontractor" then begin
                    Name := '';
                    "Resource No." := '';
                    "Vendor No." := '';
                end;
            end;
        }

        field(4; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Person));

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if "Worker/Subcontractor" <> "Worker/Subcontractor"::Worker then
                    exit;

                if Resource.Get("Resource No.") then
                    Name := Resource.Name
                else
                    Name := '';
            end;
        }

        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if "Worker/Subcontractor" <> "Worker/Subcontractor"::Subcontractor then
                    exit;

                if Vendor.Get("Vendor No.") then
                    Name := Vendor.Name
                else
                    Name := '';
            end;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
