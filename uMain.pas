unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellAPI;

type
  TfmMain = class(TForm)
    OpenDialog: TOpenDialog;
    Button: TButton;
    Memo: TMemo;
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
    wPath := '"' + filename + '" "' + 'out"';
    pPath := PWideChar(wPath);
    wExe := '"' + ExtractFilePath(Application.ExeName) + 'pdftohtml.exe"';
    pExe := PWideChar(wExe);
    Memo.Lines.Add(wExe);
    filename := ShellExecute(0, 'open', pExe, pPath, nil, SW_HIDE).ToString;
  end;
end;

end.
