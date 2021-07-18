/// <summary>
/// Page TKA Restricted Field Users (ID 89001).
/// </summary>
page 89001 "TKA Restricted Field Users"
{
    Caption = 'Restricted Field Users';
    PageType = List;
    UsageCategory = None;
    SourceTable = "TKA Restricted Field User";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies number of the table in which the field is.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies field for which we want to define specific permissions.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Restriction Type"; Rec."Restriction Type")
                {
                    ToolTip = 'Specifies type of permission. Type defines what is or is not allowed.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies type of permission group. The permissions could be granted to specific user or whole user group.';
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies code of specific user or user group based on type field.';
                    ApplicationArea = All;
                }
                field("Action"; Rec."Action")
                {
                    ToolTip = 'Specifies action that is applied to defined table field for this user or user group. If the action is "Allowed", defined user or user group are allowed to change field value. If the value is "Blocked", defined user or user group are not allowed to change field value.';
                    ApplicationArea = All;
                }
                field(Enable; Rec.Enable)
                {
                    ToolTip = 'Specifies whether the user/user group definition is active or not.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestOnChangeDerivedRecord();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestOnChangeDerivedRecord();
    end;
}
