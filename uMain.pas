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
    Button1: TButton;
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
  len := length(str);
  result := Copy(ob, pos(str, ob) + len - 1, pos(str2, ob) - pos(str, ob) - len);
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

procedure TfmMain.Button1Click(Sender: TObject);
var
  vList: TStringList;
begin
  vList := TStringList.Create;
  vList.LoadFromFile('out.txt');
  ShowMessage(getFirstDigit(vList[33]));
  TfrxMemoView(frxReport.FindObject('pkName')).Memo.Text := parse('', ' ' + getFirstDigit(vList[33]), vList[33]);
  TfrxMemoView(frxReport.FindObject('pkAddress')).Memo.Text := parse(' ' + getFirstDigit(vList[33]), 'Phone:', vList[33]);
  TfrxMemoView(frxReport.FindObject('pkPhone')).Memo.Text := parseToEnd('Phone:', vList[33]);
  frxReport.ShowReport(true);
end;

procedure TfmMain.ButtonClick(Sender: TObject);
var filename : String;
    wPath, wExe: WideString;
    pPath, pExe: PWideChar;
begin
  if (OpenDialog.Execute) then
  begin
    filename := ExtractFilePath(String(OpenDialog.FileName))+ExtractFileName(String(OpenDialog.FileName));
    wPath := '"' + filename + '" "' + ExtractFilePath(Application.ExeName) + 'out.txt"';
    pPath := PWideChar(wPath);
    wExe := '"' + ExtractFilePath(Application.ExeName) + 'pdftotext.exe"';
    pExe := PWideChar(wExe);
    ShellExecute(0, 'open', pExe, pPath, nil, SW_HIDE);
  end;
end;

end.
