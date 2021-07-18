/// <summary>
/// Codeunit TKA Field Level Perm. Mgt. (ID 89000).
/// </summary>
codeunit 89000 "TKA Field Level Perm. Mgt."
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Table, Database::"User Group Member", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventUserGroupMember(var Rec: Record "User Group Member")
    var
        RestrictedFieldUser: Record "TKA Restricted Field User";
    begin
        if Rec.IsTemporary() then
            exit;

        RestrictedFieldUser.SetRange(Type, RestrictedFieldUser.Type::"User Group");
        RestrictedFieldUser.SetRange(Code, Rec."User Group Code");
        RestrictedFieldUser.SetRange(Enable, true);
        if RestrictedFieldUser.FindSet() then
            repeat
                RestrictedFieldUser.CreateUserFromUserGroup(RestrictedFieldUser, Rec);
            until RestrictedFieldUser.Next() < 1;
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Group Member", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventUserGroupMember(var Rec: Record "User Group Member")
    var
        RestrictedFieldUser: Record "TKA Restricted Field User";
    begin
        if Rec.IsTemporary() then
            exit;

        RestrictedFieldUser.SetRange(Type, RestrictedFieldUser.Type::User);
        RestrictedFieldUser.SetRange("User Security ID", Rec."User Security ID");
        RestrictedFieldUser.SetRange("Derived from User Group Code", Rec."User Group Code");
        RestrictedFieldUser.DeleteAll()
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterGetDatabaseTableTriggerSetup', '', false, false)]
    local procedure GetDatabaseTableTriggerSetup(TableId: Integer; var OnDatabaseInsert: Boolean; var OnDatabaseDelete: Boolean; var OnDatabaseModify: Boolean; var OnDatabaseRename: Boolean)
    var
        RestrictedField: Record "TKA Restricted Field";
    begin
        RestrictedField.SetRange("Table No.", TableId);
        RestrictedField.SetRange(Enable, true);
        if not RestrictedField.IsEmpty() then begin
            OnDatabaseInsert := true;
            OnDatabaseRename := true;
            OnDatabaseModify := true;
            OnDatabaseDelete := true;
        end;
        OnAfterGetDatabaseTableTriggerSetupForFieldLevelPermission(TableId, OnDatabaseInsert, OnDatabaseDelete, OnDatabaseModify, OnDatabaseRename);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseInsert', '', false, false)]
    local procedure OnAfterOnDatabaseInsert(RecRef: RecordRef)
    begin
        CheckFieldPermission(RecRef, "TKA Action Type"::Insert);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseRename', '', false, false)]
    local procedure OnAfterOnDatabaseRename(xRecRef: RecordRef; RecRef: RecordRef)
    begin
        CheckFieldPermission(RecRef, xRecRef, "TKA Action Type"::Rename);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseModify', '', false, false)]
    local procedure OnAfterOnDatabaseModify(RecRef: RecordRef)
    begin
        CheckFieldPermission(RecRef, "TKA Action Type"::MOdify);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseDelete', '', false, false)]
    local procedure OnAfterOnDatabaseDelete(RecRef: RecordRef)
    begin
        CheckFieldPermission(RecRef, "TKA Action Type"::Delete);
    end;

    local procedure CheckFieldPermission(RecordRef: RecordRef; ActionType: Enum "TKA Action Type")
    var
        xRecordRef: RecordRef;
    begin
        if not xRecordRef.Get(RecordRef.RecordId()) then
            xRecordRef := RecordRef;
        CheckFieldPermission(RecordRef, xRecordRef, ActionType);
    end;

    local procedure CheckFieldPermission(RecordRef: RecordRef; xRecordRef: RecordRef; ActionType: Enum "TKA Action Type")
    var
        RestrictedField: Record "TKA Restricted Field";

        FieldRef: FieldRef;
        xFieldRef: FieldRef;
        IsHandled: Boolean;

        RestrictionType: Interface "TKA Restriction Type";
    begin
        RestrictedField.SetRange("Table No.", RecordRef.Number());
        RestrictedField.SetRange(Enable, true);
        if RestrictedField.FindSet() then
            repeat
                IsHandled := false;
                FieldRef := RecordRef.Field(RestrictedField."Field No.");
                xFieldRef := xRecordRef.Field(RestrictedField."Field No.");
                if Format(FieldRef.Value()) <> Format((xFieldRef.Value())) then begin
                    OnCheckFieldPermissionBeforeCheck(ActionType, FieldRef, xFieldRef, IsHandled);
                    if not IsHandled then begin
                        RestrictionType := RestrictedField.Type;
                        if RestrictionType.ShouldCheckFieldPermissionAccess(ActionType, FieldRef, xFieldRef) then
                            FindUserAccessToField(RestrictedField);
                    end;
                end;
            until RestrictedField.Next() < 1;
    end;

    local procedure FindUserAccessToField(RestrictedField: Record "TKA Restricted Field")
    var
        RestrictedFieldUser: Record "TKA Restricted Field User";

        FieldRef: FieldRef;
        RecordRef: RecordRef;
        IsHandled: Boolean;

        AccessFinal: Option "Not Defined",Allowed,Blocked;
        CannotChangeFieldValueErr: Label 'You can not change field %1 in table %2.', Comment = '%1 - Caption of field that can not be changed, %2 - Caption of corresponding table';
    begin
        AccessFinal := AccessFinal::"Not Defined";
        RestrictedFieldUser.SetRange("Table No.", RestrictedField."Table No.");
        RestrictedFieldUser.SetRange("Field No.", RestrictedField."Field No.");
        RestrictedFieldUser.SetRange(Type, RestrictedFieldUser.Type::User);
        RestrictedFieldUser.SetRange("User Security ID", UserSecurityId());
        RestrictedFieldUser.SetRange(Enable, true);

        // First Check Derived from User Group
        RestrictedFieldUser.SetFilter("Derived from User Group Code", '<>''''');
        RestrictedFieldUser.SetRange(Action, RestrictedFieldUser."Action"::Blocked);
        if not RestrictedFieldUser.IsEmpty() then
            AccessFinal := AccessFinal::Blocked;

        RestrictedFieldUser.SetRange(Action, RestrictedFieldUser."Action"::Allowed);
        if not RestrictedFieldUser.IsEmpty() then
            AccessFinal := AccessFinal::Allowed;

        // Then Check Permissions specified directly on the User level
        RestrictedFieldUser.SetRange("Derived from User Group Code", '');
        RestrictedFieldUser.SetRange(Action, RestrictedFieldUser."Action"::Blocked);
        if not RestrictedFieldUser.IsEmpty() then
            AccessFinal := AccessFinal::Blocked;

        RestrictedFieldUser.SetRange(Action, RestrictedFieldUser."Action"::Allowed);
        if not RestrictedFieldUser.IsEmpty() then
            AccessFinal := AccessFinal::Allowed;

        if (AccessFinal = AccessFinal::"Not Defined") and (RestrictedField."Default Action" = RestrictedField."Default Action"::Blocked) then
            AccessFinal := AccessFinal::Blocked;

        OnFindUserAccessToFieldBeforeDecision(RestrictedField, AccessFinal, IsHandled);
        if IsHandled then
            exit;

        if AccessFinal = AccessFinal::Blocked then begin
            RecordRef.Open(RestrictedField."Table No.");
            FieldRef := RecordRef.Field(RestrictedField."Field No.");
            Error(CannotChangeFieldValueErr, FieldRef.Caption(), RecordRef.Caption());
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckFieldPermissionBeforeCheck(ActionType: Enum "TKA Action Type"; FieldRef: FieldRef; xFieldRef: FieldRef; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetDatabaseTableTriggerSetupForFieldLevelPermission(TableId: Integer; var OnDatabaseInsert: Boolean; var OnDatabaseDelete: Boolean; var OnDatabaseModify: Boolean; var OnDatabaseRename: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindUserAccessToFieldBeforeDecision(RestrictedField: Record "TKA Restricted Field"; var CurrentEvaluatedAccess: Option "Not Defined",Allowed,Blocked; var IsHandled: Boolean)
    begin
    end;
}