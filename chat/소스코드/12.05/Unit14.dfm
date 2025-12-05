object Form14: TForm14
  Left = 0
  Top = 0
  Caption = 'ChatApp'
  ClientHeight = 700
  ClientWidth = 436
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object userCountLabel: TLabel
    Left = 63
    Top = 113
    Width = 96
    Height = 44
    Caption = #52828#44396' ??'#47749
  end
  object PanelHeader: TPanel
    Left = 0
    Top = 0
    Width = 436
    Height = 43
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LabelTitle: TLabel
      Left = 70
      Top = 10
      Width = 42
      Height = 30
      Caption = #52828#44396
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SpeedButtonSearch: TSpeedButton
      Left = 300
      Top = 15
      Width = 30
      Height = 30
      Caption = #62733
      Flat = True
    end
    object LabelClose: TLabel
      Left = 390
      Top = 8
      Width = 16
      Height = 32
      Cursor = crHandPoint
      Caption = #215
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object PanelActions: TPanel
    Left = 0
    Top = 43
    Width = 436
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 37
    object Edit2: TEdit
      Left = 56
      Top = 6
      Width = 380
      Height = 51
      Color = 16250871
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object ScrollBox1: TScrollBox
    Left = 48
    Top = 137
    Width = 395
    Height = 508
    Color = clWhite
    ParentColor = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 113
    Width = 57
    Height = 527
    Align = alLeft
    TabOrder = 3
    ExplicitTop = 130
    ExplicitHeight = 510
    object SpeedButton1: TSpeedButton
      Left = 0
      Top = 24
      Width = 42
      Height = 49
      Caption = #52828#44396' '#52285
    end
    object SpeedButton2: TSpeedButton
      Left = 0
      Top = 96
      Width = 42
      Height = 49
      Caption = #47700#51064' '#52292#54021' '#52285
    end
    object SpeedButton3: TSpeedButton
      Left = 0
      Top = 168
      Width = 42
      Height = 49
      Caption = #45908#48372#44592'('#47560#51060' '#54168#51060#51648')'
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 640
    Width = 436
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 4
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'Database=chating app'
      'User_Name=root'
      'Password=1234'
      'CharacterSet=utf8mb4'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 88
    Top = 296
  end
  object FDQueryMembers: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from user')
    Left = 312
    Top = 424
  end
  object Timer1: TTimer
    Left = 350
    Top = 376
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\MYPROGRAM\delphi\mysql\mysql-5.7.33-win32\lib\libmysql.dll'
    Left = 208
    Top = 352
  end
end
