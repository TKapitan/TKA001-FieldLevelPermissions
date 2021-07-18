/// <summary>
/// Page TKA Restricted Fields (ID 89000).
/// </summary>
page 89000 "TKA Restricted Fields"
{
    Caption = 'Restricted Fields';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "TKA Restricted Field";
    ApplicationArea = All;

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
                field("TableCaption"; RecTableCaption)
                {
                    Caption = 'Table Caption';
                    Editable = false;
                    ToolTip = 'Specifies caption of the table in which the field is.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        Rec.LookupTableAndField();
                        ReloadTableAndFieldCaptions()
                    end;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies field for which we want to define specific permissions.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("FieldCaption"; RecFieldCaption)
                {
                    Caption = 'Field Caption';
                    Editable = false;
                    ToolTip = 'Specifies field caption for which we want to define specific permissions.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        Rec.LookupTableAndField();
                        ReloadTableAndFieldCaptions()
                    end;
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies type of permission. Type defines what is or is not allowed.';
                    ApplicationArea = All;
                }
                field("Default Action"; Rec."Default Action")
                {
                    ToolTip = 'Specifies default action that is applied to defined table field. If the default action is "Allowed", everybode (except defined users) are able to edit the field. If the value is "Blocked", nobody except defined users is able to change field value.';
                    ApplicationArea = All;
                }
                field(Enable; Rec.Enable)
                {
                    ToolTip = 'Specifies whether the permission is active or not.';
                    ApplicationArea = All;
                }
                field("Number of Users"; Rec."Number of Users")
                {
                    ToolTip = 'Specifies number of user for whom this permission is defined. Only allowed user definitions are included.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(Access)
            {
                action("User and User Groups")
                {
                    Caption = 'User and User Groups';
                    ToolTip = 'Allows to define for which users or user groups the currently selected restricted field definition is specified.';
                    Image = Permission;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    RunObject = page "TKA Restricted Field Users";
                    RunPageLink = "Table No." = field("Table No."), "Field No." = field("Field No."), "Restriction Type" = field(Type), "Derived from User Group Code" = filter(<> '');
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(RecTableCaption);
        Clear(RecFieldCaption);
    end;

    trigger OnAfterGetRecord()
    begin
        ReloadTableAndFieldCaptions()
    end;

    var
        RecTableCaption, RecFieldCaption : Text;

    local procedure ReloadTableAndFieldCaptions()
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        if Rec."Table No." <> 0 then begin
            RecordRef.Open(Rec."Table No.");
            RecTableCaption := RecordRef.Caption();
            if Rec."Field No." <> 0 then begin
                FieldRef := RecordRef.Field(Rec."Field No.");
                RecFieldCaption := FieldRef.Caption();
            end;
        end;
    end;
}
