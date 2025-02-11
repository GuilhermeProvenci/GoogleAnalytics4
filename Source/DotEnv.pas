unit DotEnv;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TDotEnv = class
  private
    FVariables: TDictionary<string, string>;
    function ParseLine(const Line: string): Boolean;
  public
    constructor Create(const FilePath: string = '.env');
    destructor Destroy; override;
    function Get(const Key: string; const Default: string = ''): string;
  end;

implementation

{ TDotEnv }

constructor TDotEnv.Create(const FilePath: string);
var
  FileStream: TFileStream;
  StringList: TStringList;
  Line: string;
begin
  FVariables := TDictionary<string, string>.Create;

  if not FileExists(FilePath) then
    Exit;

  StringList := TStringList.Create;
  try
    FileStream := TFileStream.Create(FilePath, fmOpenRead or fmShareDenyNone);
    try
      StringList.LoadFromStream(FileStream, TEncoding.UTF8);
    finally
      FileStream.Free;
    end;

    for Line in StringList do
      ParseLine(Line);
  finally
    StringList.Free;
  end;
end;

destructor TDotEnv.Destroy;
begin
  FVariables.Free;
  inherited;
end;

function TDotEnv.ParseLine(const Line: string): Boolean;
var
  Key, Value: string;
  EqualPos: Integer;
begin
  Result := False;

  Key := Trim(Line);

  if (Key = '') or (Key.StartsWith('#')) then
    Exit;

  EqualPos := Pos('=', Key);
  if EqualPos < 2 then
    Exit;

  Key := Trim(Copy(Line, 1, EqualPos - 1));
  Value := Trim(Copy(Line, EqualPos + 1, Length(Line)));

  if (Value.StartsWith('"') and Value.EndsWith('"')) or
     (Value.StartsWith('''') and Value.EndsWith('''')) then
    Value := Copy(Value, 2, Length(Value) - 2);

  FVariables.AddOrSetValue(UpperCase(Key), Value);
  Result := True;
end;

function TDotEnv.Get(const Key: string; const Default: string = ''): string;
begin
  if not FVariables.TryGetValue(UpperCase(Key), Result) then
    Result := Default;
end;

end.

