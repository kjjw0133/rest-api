object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'Form8'
  ClientHeight = 473
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 225
    Top = 136
    Width = 39
    Height = 15
    Caption = #48169' '#51228#47785
  end
  object Label2: TLabel
    Left = 225
    Top = 165
    Width = 36
    Height = 15
    Caption = #51064#50896#49688
  end
  object Label3: TLabel
    Left = 272
    Top = 88
    Width = 100
    Height = 25
    Caption = #52292#54021#48169' '#49373#49457
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 280
    Top = 253
    Width = 75
    Height = 25
    Caption = #49373#49457
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 304
    Top = 133
    Width = 121
    Height = 23
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 304
    Top = 162
    Width = 121
    Height = 23
    TabOrder = 2
  end
  object RadioButton1: TRadioButton
    Left = 225
    Top = 216
    Width = 113
    Height = 17
    Caption = #51068#48152' '#52292#54021
    TabOrder = 3
  end
  object RadioButton2: TRadioButton
    Left = 320
    Top = 216
    Width = 113
    Height = 17
    Caption = #44277#44060' '#52292#54021
    Checked = True
    TabOrder = 4
    TabStop = True
  end
  object FDQueryMembers: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from chat')
    Left = 310
    Top = 368
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    DriverID = 'MySQL'
    VendorLib = 'C:\MYPROGRAM\delphi\mysql\mysql-5.7.33-win32\lib\libmysql.dll'
    Left = 548
    Top = 240
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
    Left = 553
    Top = 376
  end
end
