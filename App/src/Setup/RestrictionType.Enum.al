/// <summary>
/// Enum TKA Restriction Type (ID 89000).
/// </summary>
enum 89000 "TKA Restriction Type" implements "TKA Restriction Type"
{
    Extensible = true;

    value(0; "Block All Changes")
    {
        Caption = 'Block All Changes';
        Implementation = "TKA Restriction Type" = "TKA Rest. Type-All Chngs.";
    }
    value(5; "Allow Insert")
    {
        Caption = 'Allow Insert';
        Implementation = "TKA Restriction Type" = "TKA Rest. Type-All.Insert";
    }
}