unit data;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, Windows,lazfileutils;


type

  { TFileInfo }

  TFileInfo = class
    private
      fFileName: string;
      fCreatedDate: TDateTime;
      fChangedDate: TDateTime;
      function FileGetCreationTime(const AFileName: AnsiString): TDateTime;
      procedure SetFileDate(const AFileName: String; ADate: TDateTime);
    public
      property FileName: string read fFileName write fFileName;
      property CreatedDate: TDateTime read fCreatedDate write fCreatedDate;
      property ChangedDate: TDateTime read fChangedDate write fChangedDate;
      procedure SetFile(pFileName: String);
      procedure ChangeFileDate();
  end;

type
  TFileInfoList = class(specialize TFPGObjectList<TFileInfo>);

implementation


{ TFileInfo }

function TFileInfo.FileGetCreationTime(const AFileName: AnsiString): TDateTime;
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

procedure TFileInfo.SetFileDate(const AFileName: String; ADate: TDateTime);
var
  fileHandle: THandle;
  fileTime: TFILETIME;
  LFileTime: TFILETIME;
  LSysTime: TSystemTime;
begin
  try
    DecodeDate(aDate, LSysTime.Year, LSysTime.Month, LSysTime.Day);
    DecodeTime(aDate, LSysTime.Hour, LSysTime.Minute, LSysTime.Second, LSysTime.Millisecond);
    if SystemTimeToFileTime(LSysTime, LFileTime) then
    begin
      if LocalFileTimeToFileTime(LFileTime, fileTime) then
      begin
        fileHandle:= FileOpenUTF8(aFilename, fmOpenReadWrite or fmShareExclusive);
        SetFileTime(fileHandle, fileTime, fileTime, fileTime);
      end;
    end;
  finally
    FileClose(fileHandle);
  end;
end;

procedure TFileInfo.SetFile(pFileName: String);
begin
  FileName:= pFileName;
  CreatedDate:= FileGetCreationTime(FileName);
  ChangedDate:= FileDateToDateTime(FileAge(FileName));
end;

procedure TFileInfo.ChangeFileDate;
begin
  SetFileDate(FileName, ChangedDate);
  SetFile(FileName);
end;

end.

