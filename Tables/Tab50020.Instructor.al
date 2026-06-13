table 50020 Instructor
{
    Caption = 'Instructor';
    DataCaptionFields = "Code", Name;

    fields
    {
        field(1; "Code"; Code[20]) // 2.2 typ code length 20
        {
            Caption = 'Code';
        }

        field(2; Name; Text[100]) //2.2 typ Text length 100
        {
            Caption = 'Name';
        }

        field(3; "Worker/Subcontractor"; Option)
        {
            /* 2.2
            Pole typu Option
            Opcje:
            - Worker
            - Subontractor
            */
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

        field(4; "Resource No."; Code[20]) //2.2 typ code length 20
        {
            Caption = 'Resource No.';
            /* 2.2
            Relacja do tabeli 156 "Resource",
            Type = Person
            */
            TableRelation = Resource where(Type = const(Person));

            trigger OnValidate()

            var
                Resource: Record Resource;
                ConfirmWorkSubChange: Label 'Czy chcesz zmienić typ pracownika? Może spowodować utratę danych';
            /* 4.2
            Resource No. – po wybraniu numeru zasobu, 
            system ma odpowiednio uzupełnić pole
            Name tylko w przypadku, 
            gdy wartość pola Worker/Subcontractor to Worker. */
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

        field(5; "Vendor No."; Code[20]) //2.2 typ code length 20
        {
            Caption = 'Vendor No.';
            /* 2.2
            Relacja do tabeli 23 "Vendor"
            */
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vendor: Record Vendor;
                ConfirmWorkSubChange: Label 'Czy chcesz zmienić typ pracownika? Może spowodować utratę danych';
            /* 4.2
            Vendor No. – po wybraniu numeru dostawcy, 
            system ma odpowiednio uzupełnić pole
            Name tylko w przypadku, 
            gdy wartość pola Worker/Subcontractor to Subcontractor. */

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