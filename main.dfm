object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 40
    Top = 168
    Width = 75
    Height = 25
    Action = AStartNewThread
    TabOrder = 0
  end
  object ProgressBar1: TProgressBar
    Left = 144
    Top = 176
    Width = 150
    Height = 17
    TabOrder = 1
  end
  object ActionList1: TActionList
    Left = 352
    Top = 48
    object AStartNewThread: TAction
      Caption = 'Start'
      OnExecute = AStartNewThreadExecute
    end
  end
end
