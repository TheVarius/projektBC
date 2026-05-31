xmlport 50100 "Export Seminar Participants"
{
    Caption = 'Eksport uczestników szkolenia';
    Direction = Export;
    Format = Xml;
    UseRequestPage = true;

    schema
    {
        textelement(Seminar_Registration_Participant_List)
        {
            tableelement(SeminarRegHeader; "Seminar Registration Header")
            {
                XmlName = 'Seminar';
                RequestFilterFields = "No.", "Seminar Code";

                fieldelement(Registration_No; SeminarRegHeader."No.")
                {

                }

                fieldelement(Seminar_Code; SeminarRegHeader."Seminar Code")
                {

                }

                fieldelement(Seminar_Name; SeminarRegHeader."Seminar Name")
                {

                }

                fieldelement(Starting_Date; SeminarRegHeader."Starting Date")
                {

                }

                fieldelement(Seminar_Duration; SeminarRegHeader."Seminar Duration")
                {

                }

                fieldelement(Instructor_Name; SeminarRegHeader."Instructor Name")
                {

                }

                fieldelement(Room_Name; SeminarRegHeader."Seminar Room Name")
                {

                }

                tableelement(SeminarRegLine; "Seminar Registration Line")
                {
                    XmlName = 'Participant';
                    LinkTable = SeminarRegHeader;
                    LinkFields = "Seminar Registration No." = field("No.");
                    MinOccurs = Zero;

                    fieldelement(Customer_No; SeminarRegLine."Bill-to Customer No.")
                    {

                    }

                    textelement(Customer_Name)
                    {

                    }

                    fieldelement(Contact_No; SeminarRegLine."Participant Contact No.")
                    {

                    }

                    fieldelement(Participant_Name; SeminarRegLine."Participant Name")
                    {

                    }

                    trigger OnAfterGetRecord()
                    var
                        Cust: Record Customer;
                    begin
                        if Cust.Get(SeminarRegLine."Bill-to Customer No.") then
                            Customer_Name := Cust.Name
                        else
                            Customer_Name := '';
                    end;
                }
            }
        }
    }
}
