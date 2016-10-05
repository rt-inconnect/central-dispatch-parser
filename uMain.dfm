object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Central Dispatch Parser'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 41
    Width = 635
    Height = 259
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 71
    ExplicitWidth = 619
    ExplicitHeight = 253
  end
  object pHeader: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 41
    Align = alTop
    TabOrder = 1
    object Button: TButton
      Left = 14
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Open...'
      TabOrder = 0
      OnClick = ButtonClick
    end
  end
  object OpenDialog: TOpenDialog
    Left = 600
    Top = 8
  end
end
