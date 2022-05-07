unit functions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Windows;

function FileGetCreationTime(const AFileName: AnsiString): TDateTime;

implementation

function FileGetCreationTime(const AFileName: AnsiString): TDateTime;
var
  SearchRec: TSearchRec;
  SysTime: SYSTEMTIME;
  FileTime: TFILETIME;
begin
  if FindFirst(AFileName, faAnyFile, SearchRec) = 0 then
  begin
    FileTimeToLocalFileTime(SearchRec.FindData.ftCreationTime, FileTime);
    FileTimeToSystemTime(FileTime, SysTime);
    Result := SystemTimeToDateTime(SysTime);
  end;
end;



end.

