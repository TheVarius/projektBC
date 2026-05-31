table 50040 "Seminar Registration Header"
{
    Caption = 'Seminar Registration Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }

        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if (xRec."Starting Date" <> 0D) and
                   (Status <> Status::Planning)
                then
                    Error(StartingDateStatusErr);
            end;
        }

        field(3; "Seminar Code"; Code[20])
        {
            Caption = 'Seminar Code';
            TableRelation = Seminar where(Blocked = const(false));

            trigger OnValidate()
            var
                Seminar: Record Seminar;
                SeminarRegLine: Record "Seminar Registration Line";
            begin
                SeminarRegLine.Reset();
                SeminarRegLine.SetRange("Seminar Registration No.", "No.");
                SeminarRegLine.SetRange(Registered, true);

                if SeminarRegLine.FindFirst() then
                    Error(SeminarWithRegisteredLinesModifyErr);

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

        field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';
        }

        field(5; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
            TableRelation = Instructor;

            trigger OnValidate()
            begin
                CalcFields("Instructor Name");
            end;
        }

        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Instructor.Name where(Code = field("Instructor Code")));
            Editable = false;
        }

        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Planning,Registration,Finished,Cancelled;
            OptionCaption = 'Planning,Registration,Finished,Cancelled';
        }

        field(8; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
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

        field(11; "Seminar Room Code"; Code[20])
        {
            Caption = 'Seminar Room Code';
            TableRelation = "Seminar Room";

            trigger OnValidate()
            var
                SeminarRoom: Record "Seminar Room";
            begin
                if SeminarRoom.Get("Seminar Room Code") then begin

                    if SeminarRoom."Maximum Participants" < "Maximum Participants" then
                        Message(RoomCapacityWarnMsg);

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

        field(12; "Seminar Room Name"; Text[50])
        {
            Caption = 'Seminar Room Name';
        }

        field(13; "Seminar Room Address"; Text[50])
        {
            Caption = 'Seminar Room Address';
        }

        field(14; "Seminar Room Address 2"; Text[50])
        {
            Caption = 'Seminar Room Address 2';
        }

        field(15; "Seminar Room Post Code"; Code[20])
        {
            Caption = 'Seminar Room Post Code';
        }

        field(16; "Seminar Room City"; Text[30])
        {
            Caption = 'Seminar Room City';
        }

        field(17; "Seminar Room Phone No."; Text[30])
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
                if Status = Status::Cancelled then
                    exit;

                if xRec."Seminar Price" = "Seminar Price" then
                    exit;

                if Confirm(UpdateLinesQst, false) then begin

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

    trigger OnInsert()
    begin
        "Posting Date" := WorkDate();
    end;

    trigger OnDelete()
    begin
        if not (Status in [Status::Planning, Status::Cancelled]) then
            Error(DeleteStatusErr);
    end;

    trigger OnRename()
    begin
        Error(RenameErr);
    end;

    var
        SeminarWithRegisteredLinesModifyErr: Label 'Seminar with registered lines cannot be modified.';
        StartingDateStatusErr: Label 'Starting Date can only be changed for Planning status.';
        DeleteStatusErr: Label 'Only Planning or Cancelled registrations can be deleted.';
        RenameErr: Label 'Changing registration number is not allowed.';
        RoomCapacityWarnMsg: Label 'Room capacity is lower than maximum seminar participants.';
        UpdateLinesQst: Label 'Do you want to update seminar price on all unregistered lines?';
}
