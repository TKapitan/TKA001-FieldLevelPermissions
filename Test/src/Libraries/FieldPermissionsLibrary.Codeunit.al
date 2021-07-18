/// <summary>
/// Codeunit TST Field Permissions Library (ID 90001).
/// </summary>
codeunit 90001 "TST Field Permissions Library"
{
    SingleInstance = true;

    var
        LastCustomerNo: Code[20];

    /// <summary>
    /// Initialize restriction fields for test codeunits
    /// </summary>
    /// <param name="EnableRules">Boolean, specifies whether rules should be enabled.</param>
    procedure InitializeTKARestrictedFields(EnableRules: Boolean)
    var
        TKARestrictedField: Record "TKA Restricted Field";
    begin
        TKARestrictedField.DeleteAll(true);

        TKARestrictedField.Init();
        TKARestrictedField."Table No." := Database::Customer;
        TKARestrictedField."Field No." := 2; // Name;
        TKARestrictedField.Type := TKARestrictedField.Type::"Block All Changes";
        TKARestrictedField."Default Action" := TKARestrictedField."Default Action"::Blocked;
        TKARestrictedField.Enable := EnableRules;
        TKARestrictedField.Insert();

        TKARestrictedField.Init();
        TKARestrictedField."Table No." := Database::Customer;
        TKARestrictedField."Field No." := 3; // Search Name;
        TKARestrictedField.Type := TKARestrictedField.Type::"Allow Insert";
        TKARestrictedField."Default Action" := TKARestrictedField."Default Action"::Blocked;
        TKARestrictedField.Enable := EnableRules;
        TKARestrictedField.Insert();

        TKARestrictedField.Init();
        TKARestrictedField."Table No." := Database::Customer;
        TKARestrictedField."Field No." := 4; // Name 2;
        TKARestrictedField.Type := TKARestrictedField.Type::"Block All Changes";
        TKARestrictedField."Default Action" := TKARestrictedField."Default Action"::Allowed;
        TKARestrictedField.Enable := EnableRules;
        TKARestrictedField.Insert();

        TKARestrictedField.Init();
        TKARestrictedField."Table No." := Database::Customer;
        TKARestrictedField."Field No." := 5; // Address;
        TKARestrictedField.Type := TKARestrictedField.Type::"Allow Insert";
        TKARestrictedField."Default Action" := TKARestrictedField."Default Action"::Allowed;
        TKARestrictedField.Enable := EnableRules;
        TKARestrictedField.Insert();
    end;

    /// <summary>
    /// Initialize restriction field users with type user
    /// <param name="EnableRules">Boolean, specifies whether rules should be enabled.</param>
    /// <param name="ActionAllowed">Boolean, specifies whether the action of restricted field user should be set to true.</param>
    /// </summary>
    procedure InitializeTKARestrictedFieldUsersWithUser(EnableRules: Boolean; ActionAllowed: Boolean)
    var
        TKARestrictedFieldUser: Record "TKA Restricted Field User";
    begin
        TKARestrictedFieldUser.DeleteAll(true);

        TKARestrictedFieldUser.Init();
        TKARestrictedFieldUser."Table No." := Database::Customer;
        TKARestrictedFieldUser."Field No." := 2; // Name;
        TKARestrictedFieldUser."Restriction Type" := TKARestrictedFieldUser."Restriction Type"::"Block All Changes";
        TKARestrictedFieldUser.Type := TKARestrictedFieldUser.Type::User;
        TKARestrictedFieldUser.Validate(Code, UserId());
        TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Allowed;
        if not ActionAllowed then
            TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Blocked;
        TKARestrictedFieldUser.Enable := EnableRules;
        TKARestrictedFieldUser.Insert();

        TKARestrictedFieldUser.Init();
        TKARestrictedFieldUser."Table No." := Database::Customer;
        TKARestrictedFieldUser."Field No." := 3; // Search Name;
        TKARestrictedFieldUser."Restriction Type" := TKARestrictedFieldUser."Restriction Type"::"Allow Insert";
        TKARestrictedFieldUser.Type := TKARestrictedFieldUser.Type::User;
        TKARestrictedFieldUser.Validate(Code, UserId());
        TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Allowed;
        if not ActionAllowed then
            TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Blocked;
        TKARestrictedFieldUser.Enable := EnableRules;
        TKARestrictedFieldUser.Insert();

        TKARestrictedFieldUser.Init();
        TKARestrictedFieldUser."Table No." := Database::Customer;
        TKARestrictedFieldUser."Field No." := 4; // Name 2;
        TKARestrictedFieldUser."Restriction Type" := TKARestrictedFieldUser."Restriction Type"::"Block All Changes";
        TKARestrictedFieldUser.Type := TKARestrictedFieldUser.Type::User;
        TKARestrictedFieldUser.Validate(Code, UserId());
        TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Allowed;
        if not ActionAllowed then
            TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Blocked;
        TKARestrictedFieldUser.Enable := EnableRules;
        TKARestrictedFieldUser.Insert();

        TKARestrictedFieldUser.Init();
        TKARestrictedFieldUser."Table No." := Database::Customer;
        TKARestrictedFieldUser."Field No." := 5; // Address;
        TKARestrictedFieldUser."Restriction Type" := TKARestrictedFieldUser."Restriction Type"::"Allow Insert";
        TKARestrictedFieldUser.Type := TKARestrictedFieldUser.Type::User;
        TKARestrictedFieldUser.Validate(Code, UserId());
        TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Allowed;
        if not ActionAllowed then
            TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Blocked;
        TKARestrictedFieldUser.Enable := EnableRules;
        TKARestrictedFieldUser.Insert();
    end;

    /// <summary>
    /// Initialize restriction field users with type user group
    /// <param name="EnableRules">Boolean, specifies whether rules should be enabled.</param>
    /// <param name="ActionAllowed">Boolean, specifies whether the action of restricted field user should be set to true.</param>
    /// </summary>
    procedure InitializeTKARestrictedFieldUsersWithUserGroup(EnableRules: Boolean; ActionAllowed: Boolean)
    var
        UserGroup: Record "User Group";
        UserGroupMember: Record "User Group Member";
        TKARestrictedFieldUser: Record "TKA Restricted Field User";
    begin
        UserGroup.FindFirst();
        UserGroupMember.DeleteAll(true);

        UserGroupMember.Init();
        UserGroupMember."User Group Code" := UserGroup.Code;
        UserGroupMember."User Security ID" := UserSecurityId();
        UserGroupMember."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(UserGroupMember."Company Name"));
        UserGroupMember.Insert(true);

        TKARestrictedFieldUser.DeleteAll(true);

        TKARestrictedFieldUser.Init();
        TKARestrictedFieldUser."Table No." := Database::Customer;
        TKARestrictedFieldUser."Field No." := 2; // Name;
        TKARestrictedFieldUser."Restriction Type" := TKARestrictedFieldUser."Restriction Type"::"Block All Changes";
        TKARestrictedFieldUser.Type := TKARestrictedFieldUser.Type::"User Group";
        TKARestrictedFieldUser.Validate(Code, UserGroup.Code);
        TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Allowed;
        if not ActionAllowed then
            TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Blocked;
        TKARestrictedFieldUser.Validate(Enable, EnableRules);
        TKARestrictedFieldUser.Insert();

        TKARestrictedFieldUser.Init();
        TKARestrictedFieldUser."Table No." := Database::Customer;
        TKARestrictedFieldUser."Field No." := 3; // Search Name;
        TKARestrictedFieldUser."Restriction Type" := TKARestrictedFieldUser."Restriction Type"::"Allow Insert";
        TKARestrictedFieldUser.Type := TKARestrictedFieldUser.Type::"User Group";
        TKARestrictedFieldUser.Validate(Code, UserGroup.Code);
        TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Allowed;
        if not ActionAllowed then
            TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Blocked;
        TKARestrictedFieldUser.Validate(Enable, EnableRules);
        TKARestrictedFieldUser.Insert();

        TKARestrictedFieldUser.Init();
        TKARestrictedFieldUser."Table No." := Database::Customer;
        TKARestrictedFieldUser."Field No." := 4; // Name 2;
        TKARestrictedFieldUser."Restriction Type" := TKARestrictedFieldUser."Restriction Type"::"Block All Changes";
        TKARestrictedFieldUser.Type := TKARestrictedFieldUser.Type::"User Group";
        TKARestrictedFieldUser.Validate(Code, UserGroup.Code);
        TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Allowed;
        if not ActionAllowed then
            TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Blocked;
        TKARestrictedFieldUser.Validate(Enable, EnableRules);
        TKARestrictedFieldUser.Insert();

        TKARestrictedFieldUser.Init();
        TKARestrictedFieldUser."Table No." := Database::Customer;
        TKARestrictedFieldUser."Field No." := 5; // Address;
        TKARestrictedFieldUser."Restriction Type" := TKARestrictedFieldUser."Restriction Type"::"Allow Insert";
        TKARestrictedFieldUser.Type := TKARestrictedFieldUser.Type::"User Group";
        TKARestrictedFieldUser.Validate(Code, UserGroup.Code);
        TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Allowed;
        if not ActionAllowed then
            TKARestrictedFieldUser.Action := TKARestrictedFieldUser.Action::Blocked;
        TKARestrictedFieldUser.Validate(Enable, EnableRules);
        TKARestrictedFieldUser.Insert();
    end;

    /// <summary>
    /// Remove already defined user group member
    /// </summary>
    procedure RemoveUserGroupMember()
    var
        UserGroup: Record "User Group";
        UserGroupMember: Record "User Group Member";
    begin
        UserGroup.FindFirst();

        UserGroupMember.SetRange("User Group Code", UserGroup.Code);
        UserGroupMember.SetRange("User Security ID", UserSecurityId());
        UserGroupMember.DeleteAll();
    end;

    /// <summary>
    /// Restore defined user group member deleted using RemoveUserGroupMember()
    /// </summary>
    procedure RestoreUserGroupMember()
    var
        UserGroup: Record "User Group";
        UserGroupMember: Record "User Group Member";
    begin
        UserGroup.FindFirst();

        UserGroupMember.Init();
        UserGroupMember."User Group Code" := UserGroup.Code;
        UserGroupMember."User Security ID" := UserSecurityId();
        UserGroupMember."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(UserGroupMember."Company Name"));
        if not UserGroupMember.Insert(true) then;
    end;

    /// <summary>
    /// Initialize new customer record for modification.
    /// </summary>
    /// <param name="Customer">VAR Record Customer, newly created record.</param>
    procedure InitNewCustomerRecord(var Customer: Record Customer)
    begin
        InitNewCustomerRecord(0, '', Customer);
    end;

    /// <summary>
    /// Initialize new customer record for modification.
    /// </summary>
    /// <param name="FieldNo">Integer, no of field where we want a default value. If equal to 0 no default value is defined.</param>
    /// <param name="DefaultFieldValue">Text, default value for field specified in FieldNo.</param>
    /// <param name="Customer">VAR Record Customer, newly created record.</param>
    procedure InitNewCustomerRecord(FieldNo: Integer; DefaultFieldValue: Text; var Customer: Record Customer)
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        if LastCustomerNo = '' then
            LastCustomerNo := 'C000';
        LastCustomerNo := IncStr(LastCustomerNo);

        Customer.Init();
        Customer."No." := LastCustomerNo;
        Customer.Insert();

        if FieldNo <> 0 then begin
            RecordRef.GetTable(Customer);
            FieldRef := RecordRef.Field(FieldNo);
            FieldRef.Validate(DefaultFieldValue);
            RecordRef.Modify();
            RecordRef.SetTable(Customer);
        end;
    end;

    /// <summary>
    /// Verify whether the error message meet expectation
    /// </summary>
    /// <param name="RecordRef">RecordRef of changed table.</param>
    /// <param name="FieldRef">FieldRef of changed field.</param>
    procedure VerifyErrorText(RecordRef: RecordRef; FieldRef: FieldRef)
    var
        Assert: Codeunit Assert;
        CanNotChangeFieldErr: Label 'You can not change field %1 in table %2.', Comment = '%1 - Field Caption, %2 - Table Caption';
    begin
        Assert.ExpectedError(StrSubstNo(CanNotChangeFieldErr, FieldRef.Caption(), RecordRef.Caption()));
    end;
}