/// <summary>
/// Codeunit TST Field Perm. Test Runner (ID 90002).
/// </summary>
codeunit 90002 "TST Field Perm. Test Runner"
{
    Subtype = TestRunner;
    TableNo = "Test Method Line";
    TestIsolation = Function;
    Permissions = TableData "AL Test Suite" = rimd, TableData "Test Method Line" = rimd;

    trigger OnRun()
    begin
        ALTestSuite.Get(Rec."Test Suite");
        CurrentTestMethodLine.Copy(Rec);
        TestRunnerMgt.RunTests(Rec);
    end;

    trigger OnBeforeTestRun(CodeunitID: Integer; CodeunitName: Text; FunctionName: Text; FunctionTestPermissions: TestPermissions): Boolean
    begin
        exit(
          TestRunnerMgt.PlatformBeforeTestRun(
            CodeunitID, COPYSTR(CodeunitName, 1, 30), COPYSTR(FunctionName, 1, 128), FunctionTestPermissions, ALTestSuite.Name, CurrentTestMethodLine.GetFilter("Line No.")));
    end;

    trigger OnAfterTestRun(CodeunitID: Integer; CodeunitName: Text; FunctionName: Text; FunctionTestPermissions: TestPermissions; IsSuccess: Boolean)
    begin
        TestRunnerMgt.PlatformAfterTestRun(
          CodeunitID, COPYSTR(CodeunitName, 1, 30), COPYSTR(FunctionName, 1, 128), FunctionTestPermissions, IsSuccess, ALTestSuite.Name,
          CurrentTestMethodLine.GetFilter("Line No."));
    end;

    var
        ALTestSuite: Record "AL Test Suite";
        CurrentTestMethodLine: Record "Test Method Line";
        TestRunnerMgt: Codeunit "Test Runner - Mgt";
}