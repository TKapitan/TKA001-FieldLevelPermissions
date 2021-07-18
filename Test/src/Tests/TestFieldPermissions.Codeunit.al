codeunit 90000 "TST Test Field Permissions"
{
    Subtype = Test;

    var
        FieldPermissionsLibrary: Codeunit "TST Field Permissions Library";

    // Part 1
    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithoutExceptionsBlockAnyChange()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(2, 'Default Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        Commit();

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer1, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithoutExceptionsAllowInsert()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(3, 'Default Search Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithoutExceptionsBlockAnyChange()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(4, 'Default Name 2', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithoutExceptionsAllowInsert()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(5, 'Default Address', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;
    end;

    // Part 2
    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserExceptionEnabledBlockAnyChangeAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(2, 'Default Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(true, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserExceptionEnabledAllowInsertAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(3, 'Default Search Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(true, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserExceptionEnabledBlockAnyChangeAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(4, 'Default Name 2', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(true, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserExceptionEnabledAllowInsertAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(5, 'Default Address', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(true, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;
    end;

    // Part 3
    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserExceptionDisabledBlockAnyChangeAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(2, 'Default Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(false, true);
        Commit();

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer1, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserExceptionDisabledAllowInsertAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(3, 'Default Search Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(false, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserExceptionDisabledBlockAnyChangeAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(4, 'Default Name 2', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(false, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserExceptionDisabledAllowInsertAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(5, 'Default Address', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(false, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;
    end;

    // Part 4
    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserExceptionEnabledBlockAnyChangeBlockForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(2, 'Default Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(true, false);
        Commit();

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer1, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserExceptionEnabledAllowInsertBlockForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(3, 'Default Search Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(true, false);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserExceptionEnabledBlockAnyChangeBlockForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(4, 'Default Name 2', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(true, false);
        Commit();

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer1, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserExceptionEnabledAllowInsertBlockForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(5, 'Default Address', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUser(true, false);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    // Part 5
    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserGroupExceptionDisabledBlockAnyChangeAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(2, 'Default Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(false, true);
        Commit();

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer1, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserGroupExceptionDisabledAllowInsertAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(3, 'Default Search Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(false, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserGroupExceptionDisabledBlockAnyChangeAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(4, 'Default Name 2', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(false, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserGroupExceptionDisabledAllowInsertAllowForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(5, 'Default Address', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(false, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;
    end;

    // Part 6
    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserGroupExceptionEnabledBlockAnyChangeBlockForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(2, 'Default Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(true, false);
        Commit();

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer1, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserGroupExceptionEnabledAllowInsertBlockForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(3, 'Default Search Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(true, false);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserGroupExceptionEnabledBlockAnyChangeBlockForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(4, 'Default Name 2', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(true, false);
        Commit();

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer1, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    [Test]
    procedure EnabledRestrictedFieldDefaultAllowedWithUserGroupExceptionEnabledAllowInsertBlockForException()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(5, 'Default Address', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(true, false);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        asserterror TryChangeCustomerField(Customer2, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);
    end;

    // Part 98
    [Test]
    procedure EnabledRestrictedFieldDefaultBlockedWithUserGroupExceptionEnabledBlockAnyChangeEnableForException_AddRemGroupMember()
    var
        Customer1: Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(2, 'Default Name', Customer1);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(true);
        FieldPermissionsLibrary.InitializeTKARestrictedFieldUsersWithUserGroup(true, true);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        FieldPermissionsLibrary.RemoveUserGroupMember();
        asserterror TryChangeCustomerField(Customer1, 2, 'New Value 2', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        FieldPermissionsLibrary.VerifyErrorText(RecordRef, FieldRef);

        // [WHEN] When Some Action 
        FieldPermissionsLibrary.RestoreUserGroupMember();
        TryChangeCustomerField(Customer1, 2, 'New Value 3', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        ;
    end;

    // Part 99
    [Test]
    procedure DisabledRestrictedFieldDefaultBlockedWithoutExceptionsBlockAnyChange()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(2, 'Default Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(false);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 2, 'New Value', RecordRef, FieldRef); // Name

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure DisabledRestrictedFieldDefaultBlockedWithoutExceptionsAllowInsert()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(3, 'Default Search Name', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(false);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 3, 'New Value', RecordRef, FieldRef); // Search Name

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure DisabledRestrictedFieldDefaultAllowedWithoutExceptionsBlockAnyChange()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(4, 'Default Name 2', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(false);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 4, 'New Value', RecordRef, FieldRef); // Name 2

        // [THEN] Then Expected Output
        ;
    end;

    [Test]
    procedure DisabledRestrictedFieldDefaultAllowedWithoutExceptionsAllowInsert()
    var
        Customer1, Customer2 : Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // [GIVEN] Given Some State 
        FieldPermissionsLibrary.InitNewCustomerRecord(Customer1);
        FieldPermissionsLibrary.InitNewCustomerRecord(5, 'Default Address', Customer2);
        FieldPermissionsLibrary.InitializeTKARestrictedFields(false);
        Commit();

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer1, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;

        // [WHEN] When Some Action 
        TryChangeCustomerField(Customer2, 5, 'New Value', RecordRef, FieldRef); // Address

        // [THEN] Then Expected Output
        ;
    end;

    local procedure TryChangeCustomerField(Customer: Record Customer; FieldNo: Integer; NewValue: Text; var RecordRef: RecordRef; var FieldRef: FieldRef)
    begin
        RecordRef.GetTable(Customer);
        FieldRef := RecordRef.Field(FieldNo);

        FieldRef.Validate(NewValue);
        RecordRef.Modify();
        RecordRef.SetTable(Customer);
    end;
}