unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, FileUtil,
  data;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonChange: TButton;
    ButtonAddFiles: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelLastChanged: TLabel;
    LabelCreatedDate: TLabel;
    LabelFileName: TLabel;
    ListBoxFiles: TListBox;
    OpenDialog: TOpenDialog;
    procedure ButtonAddFilesClick(Sender: TObject);
    procedure ButtonChangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabelCreatedDateClick(Sender: TObject);
    procedure ListBoxFilesSelectionChange(Sender: TObject; User: boolean);
  private
    FileList: TFileInfoList;
    procedure CreateFileList(Files: TStrings);
    procedure UpdateList;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ButtonAddFilesClick(Sender: TObject);
begin

  if OpenDialog.Execute then
  begin
    CreateFileList(OpenDialog.Files);
  end;
end;

procedure TForm1.ButtonChangeClick(Sender: TObject);
var
  SelectedFile: TFileInfo;
begin
  if ListBoxFiles.ItemIndex <> -1 then
  begin
    SelectedFile:= FileList[ListBoxFiles.ItemIndex];
    SelectedFile.ChangeFileDate;
    ListBoxFilesSelectionChange(nil, true);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FileList:= TFileInfoList.Create;
end;

procedure TForm1.LabelCreatedDateClick(Sender: TObject);
begin

end;

procedure TForm1.ListBoxFilesSelectionChange(Sender: TObject; User: boolean);
var
  SelectedFileInfo: TFileInfo;
begin
  if ListBoxFiles.ItemIndex <> -1 then
  begin;
    SelectedFileInfo:= FileList[ListBoxFiles.ItemIndex];
    LabelFileName.Caption:= SelectedFileInfo.FileName;
    LabelCreatedDate.Caption:= DateTimeToStr(SelectedFileInfo.CreatedDate);
    LabelLastChanged.Caption:= DateTimeToStr(SelectedFileInfo.ChangedDate);
  end else begin
    LabelFileName.Caption:= '';
    LabelCreatedDate.Caption:= '';
    LabelLastChanged.Caption:= '';
  end;
end;

procedure TForm1.CreateFileList(Files: TStrings);
var
  I: Integer;
  CurrentFileName: String;
  CurrentFileInfo: TFileInfo;
begin
  FileList.Clear;
  for I:= 0 to Files.Count - 1 do
  begin
    CurrentFileName:= Files[i];
    if FileExists(CurrentFileName) then
    begin
      CurrentFileInfo:= TFileInfo.Create;
      CurrentFileInfo.SetFile(CurrentFileName);
      FileList.Add(CurrentFileInfo);
    end;
  end;

  UpdateList;
end;

procedure TForm1.UpdateList;
var
  I: Integer;
begin
  ListBoxFiles.Clear;

  for I:= 0 to FileList.Count - 1 do
  begin
    ListBoxFiles.AddItem(FileList[i].FileName, FileList[i]);
  end;
end;

end.

