unit BetterDLLSearchPath;

{$mode delphi}

interface

uses
  windows, sysutils;

const
  LOAD_LIBRARY_SEARCH_DEFAULT_DIRS=$1000;
  LOAD_LIBRARY_SEARCH_USER_DIRS=$400;

var
  AddDllDirectory: function(dir: PWideChar):pointer; stdcall;
  SetDefaultDllDirectories: function(v: dword):BOOL; stdcall;

implementation

function AddDllDirectoryNI(dir: PWideChar):pointer; stdcall;
begin
  result:=nil;
end;

function SetDefaultDllDirectoriesNI(v:dword):BOOL; stdcall;
begin
  result:=false;
end;

procedure BetterDLLSearchPathInit;
var
  k: THandle;
  p: widestring;
begin
  k:=LoadLibrary('kernel32.dll');
  SetDefaultDllDirectories:=GetProcAddress(k,'SetDefaultDllDirectories');
  AddDllDirectory:=GetProcAddress(k,'AddDllDirectory');

  if assigned(SetDefaultDllDirectories) then
    SetDefaultDllDirectories(LOAD_LIBRARY_SEARCH_DEFAULT_DIRS or LOAD_LIBRARY_SEARCH_USER_DIRS)
  else
    SetDefaultDllDirectories:=@SetDefaultDllDirectoriesNI;

  if assigned(AddDllDirectory) then
  begin
{$ifdef cpu32}
    p:=ExtractFilePath(ParamStr(0))+'win32';
{$else}
    p:=ExtractFilePath(ParamStr(0))+'win64';
{$endif}
    AddDllDirectory(@p[1]);
  end
  else
    AddDllDirectory:=@AddDllDirectoryNI;
end;

initialization
  BetterDLLSearchPathInit;

end.

