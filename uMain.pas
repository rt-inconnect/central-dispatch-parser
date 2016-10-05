unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellAPI, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    OpenDialog: TOpenDialog;
    Memo: TMemo;
    pHeader: TPanel;
    Button: TButton;
    procedure ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

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
    Memo.Lines.LoadFromFile('out.txt');
  end;
end;

end.
