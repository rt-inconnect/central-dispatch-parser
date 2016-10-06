unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellAPI, Vcl.ExtCtrls,
  frxClass, frxExportPDF;

type
  TfmMain = class(TForm)
    OpenDialog: TOpenDialog;
    pHeader: TPanel;
    Button: TButton;
    frxPDFExport: TfrxPDFExport;
    frxReport: TfrxReport;
    procedure ButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

function parse(str, str2, ob: string): string;
var
  len: integer;
begin
  len := Length(str);
  result := Copy(ob, Pos(str, ob) + len - 1, Pos(str2, ob) - Pos(str, ob) - len);
end;

function copyUntils(str, ob: string): string;
begin
  result := Copy(ob, 0, pos(str, ob));
end;

function parseToEnd(str, ob: string): string;
var
len: integer;
begin
  len := length(str);
  result := Copy(ob, pos(str, ob), length(ob));
end;

function getFirstDigit(str: string): string;
var
 i : Smallint;
begin
  for i:=1 to Length(str) do if (str[i] in ['0'..'9']) then begin result := str[i]; break; end;
end;

function cutStart(num: integer; str: string): string;
begin
  result := Copy(str, num, Length(str));
end;

function inList(list: TStringList; search: string): integer;
var
 i : Smallint;
begin
  for i:=0 to list.Count do if (Pos(search, list[i]) > 0) then
  begin
    //ShowMessage(IntToStr(Pos(search, list[i])));
    result := i;
    break;
  end;
end;

procedure TfmMain.Button1Click(Sender: TObject);
var
  vList: TStringList;
  vLine, vCars, vYear, vMake, vModel: string;
  vIndex: integer;
begin
  vList := TStringList.Create;
  vList.LoadFromFile(ExtractFilePath(Application.ExeName) + 'out.txt');

  // Order ID
  vIndex := inList(vList, 'Order ID');
  if (vIndex >= 0) then
  begin
    vLine := vList[vIndex];
    TfrxMemoView(frxReport.FindObject('orId')).Memo.Text := cutStart(10, vLine);
  end;

  // Dispatch Sheet
  vIndex := vList.IndexOf('Dispatch Sheet') + 1;
  if (vIndex >= 0) then
  begin
    vLine := vList[vIndex];
    TfrxMemoView(frxReport.FindObject('dsSheet')).Memo.Text := vLine;
  end;

  // Car Information
  vIndex := inList(vList, 'VEHICLE INFORMATION');
  if (vIndex >= 0) then
  begin
    vLine := vList[vIndex];
    vLine := cutStart(21, vLine);
    vCars := copyUntils(' ', vLine);
    vLine := cutStart(Length(vCars) + 1, vLine);
    vYear := copyUntils(' ', vLine);
    vMake := cutStart(6, vLine);
    vMake := copyUntils(' ', vMake);
    vModel := parse(vMake, 'Type:', vLine);

    TfrxMemoView(frxReport.FindObject('crYear')).Memo.Text := vYear;
    TfrxMemoView(frxReport.FindObject('crMake')).Memo.Text := vMake;
    TfrxMemoView(frxReport.FindObject('crModel')).Memo.Text := vModel;

  end;

  // Pick Up Information
  vIndex := vList.IndexOf('PICKUP INFORMATION') + 1;
  if (vIndex >= 0) then
  begin
    vLine := vList[vIndex];
    TfrxMemoView(frxReport.FindObject('pkName')).Memo.Text := parse('', ' ' + getFirstDigit(vLine), vLine);
    TfrxMemoView(frxReport.FindObject('pkAddress')).Memo.Text := parse(' ' + getFirstDigit(vLine), 'Phone:', vLine);
    TfrxMemoView(frxReport.FindObject('pkPhone')).Memo.Text := parseToEnd('Phone:', vLine);
  end;

  // Delivery Information
  vIndex := vList.IndexOf('DELIVERY INFORMATION') + 1;
  if (vIndex >= 0) then
  begin
  vLine := vList[vIndex];
    TfrxMemoView(frxReport.FindObject('dyName')).Memo.Text := parse('', ' ' + getFirstDigit(vLine), vLine);
    TfrxMemoView(frxReport.FindObject('dyAddress')).Memo.Text := parse(' ' + getFirstDigit(vLine), 'Phone:', vLine);
    TfrxMemoView(frxReport.FindObject('dyPhone')).Memo.Text := parseToEnd('Phone:', vLine);
  end;

  // Report
  frxReport.ShowReport(true);
end;

procedure TfmMain.ButtonClick(Sender: TObject);
var filename, vLine, vCars, vYear, vMake, vModel: String;
    wPath, wExe: WideString;
    pPath, pExe: PWideChar;
    vList: TStringList;
    vIndex: integer;
begin
  if (OpenDialog.Execute) then
  begin
    // PDF to TXT
    filename := ExtractFilePath(String(OpenDialog.FileName))+ExtractFileName(String(OpenDialog.FileName));
    wPath := '"' + filename + '" "' + ExtractFilePath(Application.ExeName) + 'out.txt"';
    pPath := PWideChar(wPath);
    wExe := '"' + ExtractFilePath(Application.ExeName) + 'pdftotext.exe"';
    pExe := PWideChar(wExe);
    ShellExecute(0, 'open', pExe, pPath, nil, SW_HIDE);

    Sleep(3000);

    // Load TXT to TStringList
    vList := TStringList.Create;
    vList.LoadFromFile(ExtractFilePath(Application.ExeName) + 'out.txt');

    // Order ID
    vIndex := inList(vList, 'Order ID');
    if (vIndex >= 0) then
    begin
      vLine := vList[vIndex];
      TfrxMemoView(frxReport.FindObject('orId')).Memo.Text := cutStart(10, vLine);
    end;

    // Dispatch Sheet
    vIndex := vList.IndexOf('Dispatch Sheet') + 1;
    if (vIndex >= 0) then
    begin
      vLine := vList[vIndex];
      TfrxMemoView(frxReport.FindObject('dsSheet')).Memo.Text := vLine;
    end;

    // Car Information
    vIndex := inList(vList, 'VEHICLE INFORMATION');
    if (vIndex >= 0) then
    begin
      vLine := vList[vIndex];
      vLine := cutStart(21, vLine);
      vCars := copyUntils(' ', vLine);
      vLine := cutStart(Length(vCars) + 1, vLine);
      vYear := copyUntils(' ', vLine);
      vMake := cutStart(6, vLine);
      vMake := copyUntils(' ', vMake);
      vModel := parse(vMake, 'Type:', vLine);

      TfrxMemoView(frxReport.FindObject('crYear')).Memo.Text := vYear;
      TfrxMemoView(frxReport.FindObject('crMake')).Memo.Text := vMake;
      TfrxMemoView(frxReport.FindObject('crModel')).Memo.Text := vModel;

    end;

    // Pick Up Information
    vIndex := vList.IndexOf('PICKUP INFORMATION') + 1;
    if (vIndex >= 0) then
    begin
      vLine := vList[vIndex];
      TfrxMemoView(frxReport.FindObject('pkName')).Memo.Text := parse('', ' ' + getFirstDigit(vLine), vLine);
      TfrxMemoView(frxReport.FindObject('pkAddress')).Memo.Text := parse(' ' + getFirstDigit(vLine), 'Phone:', vLine);
      TfrxMemoView(frxReport.FindObject('pkPhone')).Memo.Text := parseToEnd('Phone:', vLine);
    end;

    // Delivery Information
    vIndex := vList.IndexOf('DELIVERY INFORMATION') + 1;
    if (vIndex >= 0) then
    begin
    vLine := vList[vIndex];
      TfrxMemoView(frxReport.FindObject('dyName')).Memo.Text := parse('', ' ' + getFirstDigit(vLine), vLine);
      TfrxMemoView(frxReport.FindObject('dyAddress')).Memo.Text := parse(' ' + getFirstDigit(vLine), 'Phone:', vLine);
      TfrxMemoView(frxReport.FindObject('dyPhone')).Memo.Text := parseToEnd('Phone:', vLine);
    end;

    // Report
    frxReport.ShowReport(true);
  end;
end;

end.
