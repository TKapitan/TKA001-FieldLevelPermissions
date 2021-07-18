/// <summary>
/// Table TKA Restricted Field User (ID 89001).
/// </summary>
table 89001 "TKA Restricted Field User"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            Editable = false;
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
            DataClassification = SystemMetadata;
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
            Editable = false;
            NotBlank = true;
            TableRelation = Field."No." where(TableNo = field("Table No."));
            DataClassification = SystemMetadata;
        }
        field(3; "Restriction Type"; Enum "TKA Restriction Type")
        {
            Caption = 'Restriction Type';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = User,"User Group";
            OptionCaption = 'User,User Group';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                Rec.TestField(Enable, false);
            end;
        }
        field(5; "Code"; Code[50])
        {
            Caption = 'Code';
            TableRelation = if (Type = const(User)) User."User Name" else
            if (Type = const("User Group")) "User Group".Code;
            ValidateTableRelation = false;
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            var
                User: Record User;
                IsHandled: Boolean;
            begin
                Rec.TestField(Enable, false);
                OnValidateCodeFieldBeforeParsing(Rec, IsHandled);
                if IsHandled then
                    exit;

                case Rec.Type of
                    Rec.Type::User:
                        begin
                            User.SetRange("User Name", Rec.Code);
                            User.FindFirst();

                            Rec."User Security ID" := User."User Security ID";
                        end;
                    Rec.Type::"User Group":
                        HandleUserGroupPermission();
                end;
            end;
        }
        field(6; "Action"; Option)
        {
            Caption = 'Action';
            OptionMembers = Allowed,Blocked;
            OptionCaption = 'Allowed,Blocked';
            DataClassification = SystemMetadata;
        }
        field(25; "Derived from User Group Code"; Code[20])
        {
            Caption = 'Derived from User Group Code';
            Editable = false;
            TableRelation = "User Group".Code;
            DataClassification = CustomerContent;
        }
        field(26; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            Editable = false;
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(50; Enable; Boolean)
        {
            Caption = 'Enable';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if Rec.Type = Rec.Type::"User Group" then
                    HandleUserGroupPermission();
            end;
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.", "Restriction Type", Type, Code, "Derived from User Group Code")
        {
            Clustered = true;
        }
    }

    trigger OnRename()
    var
        RenameNotAllowedErr: Label 'Rename is not allowed.';
    begin
        Error(RenameNotAllowedErr);
    end;

    trigger OnDelete()
    begin
        Rec.TestField(Enable, false);
    end;

    /// <summary>
    /// Tests current record whether is derived from user group. If so, the error is returned.
    /// </summary>
    procedure TestOnChangeDerivedRecord()
    var
        DerivedFromGroupErr: Label 'This record is derived from user group %1 hence the user can not be deleted manually.', Comment = '%1 - Name of group from which the record is derived.';
    begin
        if Rec."Derived from User Group Code" <> '' then
            Error(DerivedFromGroupErr, Rec."Derived from User Group Code");
    end;

    /// <summary>
    /// CreateUserFromUserGroup.
    /// </summary>
    /// <param name="UserGroupRestrictedFieldUser">Record "TKA Restricted Field User".</param>
    /// <param name="NewUserGroupMember">Record "User Group Member".</param>
    procedure CreateUserFromUserGroup(UserGroupRestrictedFieldUser: Record "TKA Restricted Field User"; var NewUserGroupMember: Record "User Group Member")
    var
        RestrictedFieldUser: Record "TKA Restricted Field User";
    begin
        NewUserGroupMember.CalcFields("User Name");

        RestrictedFieldUser.Init();
        RestrictedFieldUser.Validate("Table No.", UserGroupRestrictedFieldUser."Table No.");
        RestrictedFieldUser.Validate("Field No.", UserGroupRestrictedFieldUser."Field No.");
        RestrictedFieldUser.Validate(Type, RestrictedFieldUser.Type::User);
        RestrictedFieldUser.Validate(Code, NewUserGroupMember."User Name");
        RestrictedFieldUser.Validate("Derived from User Group Code", UserGroupRestrictedFieldUser.Code);
        RestrictedFieldUser.Validate("User Security ID", NewUserGroupMember."User Security ID");
        RestrictedFieldUser.Validate("Restriction Type", UserGroupRestrictedFieldUser."Restriction Type");
        RestrictedFieldUser.Validate(Action, UserGroupRestrictedFieldUser.Action);
        RestrictedFieldUser.Validate(Enable, UserGroupRestrictedFieldUser.Enable);
        RestrictedFieldUser.Insert(true);
    end;

    local procedure HandleUserGroupPermission()
    var
        UserGroup: Record "User Group";
        UserGroupMember: Record "User Group Member";
        RestrictedFieldUser: Record "TKA Restricted Field User";

        IsHandled: Boolean;
    begin
        if Rec.Type <> Rec.Type::"User Group" then
            exit;

        UserGroup.Get(Rec.Code);

        OnBeforeHandleUserGroupPermission(Rec, IsHandled);
        if IsHandled then
            exit;

        if not Rec.Enable then begin
            RestrictedFieldUser.SetRange("Table No.", Rec."Table No.");
            RestrictedFieldUser.SetRange("Field No.", Rec."Field No.");
            RestrictedFieldUser.SetRange(Type, Type::User);
            RestrictedFieldUser.SetRange("Derived from User Group Code", Code);
            RestrictedFieldUser.DeleteAll(false);
        end else begin
            UserGroupMember.SetRange("User Group Code", Rec.Code);
            if UserGroupMember.FindSet() then
                repeat
                    CreateUserFromUserGroup(Rec, UserGroupMember);
                until UserGroupMember.Next() < 1;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateCodeFieldBeforeParsing(var RestrictedFieldUser: Record "TKA Restricted Field User"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeHandleUserGroupPermission(var RestrictedFieldUser: Record "TKA Restricted Field User"; var IsHandled: Boolean)
    begin
    end;
}