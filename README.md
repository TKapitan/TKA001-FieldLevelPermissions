# Field Level Permissions

## Basic functionality

This extension adds new functionality to allow users to specify who can or can not change field values. Users can specify a specific user or whole user group.

### Restricted Fields

The configuration can be found as "Restricted Fields". You can specify the table/field that we want to restrict for some users on this page.

The field "Type" specify what is or is not allowed. The standard values are "Block All Changes" and "Allow Insert". The first one does not allow to change from/to any value. "Allow Insert" allows to change the value from the blank value to any other value. If the field was not empty, the user is not able to change the value.

"Default Action" specify whether the default action is that anybody can change the value except specific users ("Default Action" = Allowed) or nobody except specific users can change the value ("Default Action" = Blocked).

The rule is active only when Enable is true.

### Restricted Field Users

On the page "Restricted Fields", we can also specify exceptions for the specific record. This can be done using the "User and User Groups" action.

We can specify a user or user group who can or can not change the field specified on the Restricted Field record on this page. Only enabled records are evaluated.

#### Evaluation order

The exceptions are evaluated in the following order.

1) Is Blocked for User Group?
2) Is Allowed for User Group?
3) Is Blocked for User?
4) Is Allowed for User?

The last matching rule is used (= if the field change is blocked for all users from group ABC, but it is allowed for user XYZ who is a member of ABC, the user still can change the value of the field even if his group can not).

## Extendability

### Enum 89000 "TKA Restriction Type"

This enum contains values for Restricted Field "Type" field. The enum is extendible and implements the interface "TKA Restriction Type".

If you want to add a new value, the enum extension and it's values has to implement this interface and define procedure ShouldCheckFieldPermissionAccess(ActionType: Enum "TKA Action Type"; FieldRef: FieldRef; xFieldRef: FieldRef): Boolean;

The method contains three parameters - action that happened (Insert, Rename, Modify, Delete) and the new and old field value. The function must return whether the user permissions should be evaluated. If the return value is false, the rule is not evaluated

### Table 89000 "TKA Restricted Field"

#### Integration event OnBeforeLookupTableAndField(var Field: Record Field; RestrictedField: Record "TKA Restricted Field")

This event allows predefining filters on table/field selection lookup. To apply additional filters on available fields, apply them on the Field record parameter.

### Table 89001 "TKA Restricted Field User"

#### Integration event OnValidateCodeFieldBeforeParsing(var RestrictedFieldUser: Record "TKA Restricted Field User"; var IsHandled: Boolean)

This event allows skipping standard validation of the Code field. This field manages how user group or user field permission is defined.

#### Integration event OnBeforeHandleUserGroupPermission(var RestrictedFieldUser: Record "TKA Restricted Field User"; var IsHandled: Boolean)

This event allows changing how user group permissions are handled. You can evaluate and manage user groups permissions by yourself and skip default behaviour with the IsHandled parameter.

### Codeunit 89000 "TKA Field Level Perm. Mgt."

#### Integration event OnCheckFieldPermissionBeforeCheck(ActionType: Enum "TKA Action Type"; FieldRef: FieldRef; xFieldRef: FieldRef; var IsHandled: Boolean)

This event allows to evaluate whether field change should be evaluated or not.

#### Integration event OnAfterGetDatabaseTableTriggerSetupForFieldLevelPermission(TableId: Integer; var OnDatabaseInsert: Boolean; var OnDatabaseDelete: Boolean; var OnDatabaseModify: Boolean; var OnDatabaseRename: Boolean)

This event allows to change whether table action (insert, delete, rename, modify) should be evaluated for specific table.

#### Integration event OnFindUserAccessToFieldBeforeDecision(RestrictedField: Record "TKA Restricted Field"; var CurrentEvaluatedAccess: Option "Not Defined",Allowed,Blocked; var IsHandled: Boolean)

Using this event you are able to evaluate final condition whether user can change specific field. You can resolve everything by yourself by returning IsHandled = true or change final access by changing CurrentEvaluatedAccess variable.
