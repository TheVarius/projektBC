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
            var
                ConfirmWorkSubChange: Label 'Czy na pewno chcesz zmienić typ pracownika?';
            begin
                if not Confirm(ConfirmWorkSubChange, false) then begin
                    "Worker/Subcontractor" := xRec."Worker/Subcontractor";
                    exit;
                end;

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
                ConfirmWorkSubChange: Label 'Czy chcesz zmienić typ pracownika? Może spowodować utratę danych';
            begin
                if "Worker/Subcontractor" <> "Worker/Subcontractor"::Worker then begin
                    if not Confirm(ConfirmWorkSubChange, false) then begin
                        "Resource No." := '';
                        exit;
                    end;
                    "Worker/Subcontractor" := "Worker/Subcontractor"::Worker;
                    "Vendor No." := '';
                end;

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
                ConfirmWorkSubChange: Label 'Czy chcesz zmienić typ pracownika? Może spowodować utratę danych';
            begin
                if "Worker/Subcontractor" <> "Worker/Subcontractor"::Subcontractor then begin
                    if not Confirm(ConfirmWorkSubChange, false) then begin
                        "Vendor No." := '';
                        exit;
                    end;
                    "Worker/Subcontractor" := "Worker/Subcontractor"::Subcontractor;
                    "Resource No." := '';
                end;

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
