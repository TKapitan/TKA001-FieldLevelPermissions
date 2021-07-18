/// <summary>
/// Table TKA Restricted Field (ID 89000).
/// </summary>
table 89000 "TKA Restricted Field"
{
    Caption = 'Restricted Field';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
            DataClassification = SystemMetadata;

            trigger OnLookup()
            begin
                LookupTableAndField();
            end;
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
            NotBlank = true;
            TableRelation = Field."No." where(TableNo = field("Table No."));
            DataClassification = SystemMetadata;

            trigger OnLookup()
            begin
                LookupTableAndField();
            end;
        }
        field(3; Type; Enum "TKA Restriction Type")
        {
            Caption = 'Type';
            DataClassification = SystemMetadata;
        }
        field(4; "Default Action"; Option)
        {
            Caption = 'Default Action';
            OptionMembers = Allowed,Blocked;
            OptionCaption = 'Allowed,Blocked';
            DataClassification = SystemMetadata;
        }
        field(50; Enable; Boolean)
        {
            Caption = 'Enable';
            DataClassification = SystemMetadata;
        }
        field(500; "Number of Users"; Integer)
        {
            Caption = 'Number of Users';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("TKA Restricted Field User" where("Table No." = field("Table No."), "Field No." = field("Field No."), "Restriction Type" = field(Type), Type = const(User), Enable = const(true)));
        }

    }

    keys
    {
        key(Key1; "Table No.", "Field No.", Type)
        {
            Clustered = true;
        }
        key(Key2; "Table No.", Enable) { }
    }

    trigger OnDelete()
    var
        RestrictedFieldUser: Record "TKA Restricted Field User";
    begin
        RestrictedFieldUser.SetRange("Table No.", Rec."Table No.");
        RestrictedFieldUser.SetRange("Field No.", Rec."Field No.");
        RestrictedFieldUser.SetRange("Restriction Type", Rec.Type);
        RestrictedFieldUser.DeleteAll();
    end;

    trigger OnRename()
    var
        RenameNotAllowedErr: Label 'Rename is not allowed.';
    begin
        Error(RenameNotAllowedErr);
    end;

    /// <summary>
    /// Lookup table and field (allow user to choose table amd field) and save selected values to current record (Rec).
    /// </summary>
    procedure LookupTableAndField()
    var
        Field: Record Field;
        FieldSelection: Codeunit "Field Selection";
    begin
        OnBeforeLookupTableAndField(Field, Rec);
        if not FieldSelection.Open(Field) then begin
            Rec."Table No." := 0;
            Rec."Field No." := 0;
            exit;
        end;
        Rec.Validate("Table No.", Field.TableNo);
        Rec.Validate("Field No.", Field."No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupTableAndField(var Field: Record Field; RestrictedField: Record "TKA Restricted Field")
    begin
    end;
}