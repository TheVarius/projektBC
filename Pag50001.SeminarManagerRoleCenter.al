page 50001 "Seminar Manager Role Center"
{
    PageType = RoleCenter;
    Caption = 'Seminar Manager';

    layout
    {
        area(RoleCenter)
        {
        }
    }

    actions
    {
        area(Sections)
        {
            group(Lists)
            {
                Caption = 'Lists';

                action(Seminars)
                {
                    Caption = 'Seminars';
                    RunObject = page "Seminar List";
                    ApplicationArea = All;
                }
                action(Instructors)
                {
                    Caption = 'Instructors';
                    RunObject = page "Instructor List";
                    ApplicationArea = All;
                }
                action(Rooms)
                {
                    Caption = 'Seminar Rooms';
                    RunObject = page "Seminar Room List";
                    ApplicationArea = All;
                }
                action(Registrations)
                {
                    Caption = 'Seminar Registrations';
                    RunObject = page "Seminar Registration List";
                    ApplicationArea = All;
                }
            }
        }
    }
}

profile "Seminar Manager"
{
    Caption = 'Seminar Manager';
    RoleCenter = "Seminar Manager Role Center";
    Enabled = true;
    Promoted = true;
}
