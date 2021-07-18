/// <summary>
/// Interface "TKA Restriction Type."
/// </summary>
interface "TKA Restriction Type"
{
    /// <summary>
    /// ShouldCheckFieldPermissionAccess
    /// Specifies whether system should check permission for field modification.
    /// </summary>
    /// <param name="ActionType">Enum "TKA Action Type", specifies action that caused this check (insert, modify, delete, rename).</param>
    /// <param name="FieldRef">FieldRef, specifies new value of the validated field.</param>
    /// <param name="xFieldRef">FieldRef. specifies old value of the validated field.</param>
    /// <returns>Return value of type Boolean, returns whether user access should be checked or not.</returns>
    procedure ShouldCheckFieldPermissionAccess(ActionType: Enum "TKA Action Type"; FieldRef: FieldRef; xFieldRef: FieldRef): Boolean;
}