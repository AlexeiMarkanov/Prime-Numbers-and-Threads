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
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 217
    Top = 0
    Height = 141
    ExplicitLeft = 216
    ExplicitTop = 32
    ExplicitHeight = 100
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 182
    Width = 447
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 217
    Height = 141
    Align = alLeft
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 141
    Width = 447
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 40
    ExplicitTop = 135
    ExplicitWidth = 305
    object Button1: TButton
      Left = 16
      Top = 10
      Width = 75
      Height = 25
      Action = AStartNewThread
      TabOrder = 0
    end
    object ProgressBar1: TProgressBar
      Left = 105
      Top = 18
      Width = 176
      Height = 17
      TabOrder = 1
    end
  end
  object Memo2: TMemo
    Left = 220
    Top = 0
    Width = 227
    Height = 141
    Align = alClient
    TabOrder = 3
    ExplicitLeft = 248
    ExplicitWidth = 199
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
