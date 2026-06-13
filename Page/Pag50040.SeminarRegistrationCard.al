page 50040 "Seminar Registration Card"
{
    PageType = Card;
    Caption = 'Seminar Registration Card';
    SourceTable = "Seminar Registration Header";
    DataCaptionFields = "No.";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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

                field("Instructor Code"; Rec."Instructor Code")
                {
                    ApplicationArea = All;
                }

                field("Instructor Name"; Rec."Instructor Name")
                {
                    ApplicationArea = All;
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }

                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ApplicationArea = All;
                }

                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                }

                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }

                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                }
            }

            group("Seminar Room")
            {
                Caption = 'Seminar Room';

                field("Seminar Room Code"; Rec."Seminar Room Code")
                {
                    ApplicationArea = All;
                }

                field("Seminar Room Name"; Rec."Seminar Room Name")
                {
                    ApplicationArea = All;
                }

                field("Seminar Room Address"; Rec."Seminar Room Address")
                {
                    ApplicationArea = All;
                }

                field("Seminar Room Address 2"; Rec."Seminar Room Address 2")
                {
                    ApplicationArea = All;
                }

                field("Seminar Room Post Code"; Rec."Seminar Room Post Code")
                {
                    ApplicationArea = All;
                }

                field("Seminar Room City"; Rec."Seminar Room City")
                {
                    ApplicationArea = All;
                }

                field("Seminar Room Phone No."; Rec."Seminar Room Phone No.")
                {
                    ApplicationArea = All;
                }

            }

            part(SeminarLines; "Seminar Registration Subpage")
            {
                Caption = 'Lines';
                SubPageLink = "Seminar Registration No." = field("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateSalesInvoice)
            {
                Caption = 'Utwórz fakturę sprzedaży';
                Image = CreateDocument;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SeminarManagement: Codeunit "Seminar Management";
                begin
                    SeminarManagement.CreateSalesInvoice(Rec);
                end;
            }
        }
    }
}