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
  object Button: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Open...'
    TabOrder = 0
    OnClick = ButtonClick
  end
  object Memo: TMemo
    Left = 8
    Top = 39
    Width = 619
    Height = 253
    TabOrder = 1
  end
  object OpenDialog: TOpenDialog
    Left = 600
    Top = 8
  end
end
