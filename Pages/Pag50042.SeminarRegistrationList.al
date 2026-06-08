page 50042 "Seminar Registration List"
{
    PageType = List;
    Caption = 'Seminar Registrations';
    SourceTable = "Seminar Registration Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    CardPageId = "Seminar Registration Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                
                field("Seminar Code"; Rec."Seminar Code")
                {
                    ApplicationArea = All;
                }
                
                field("Seminar Name"; Rec."Seminar Name")
                {
                    ApplicationArea = All;
                }
                
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ApplicationArea = All;
                }
                
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExportXML)
            {
                Caption = 'Export XML';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::"Export Seminar Participants");
                end;
            }
        }
    }
}
