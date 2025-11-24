object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 534
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 192
    Top = 128
    Width = 50
    Height = 15
    Caption = #49324#50857#51088' ID'
  end
  object Label3: TLabel
    Left = 192
    Top = 197
    Width = 48
    Height = 15
    Caption = #48708#48128#48264#54840
  end
  object Label2: TLabel
    Left = 192
    Top = 361
    Width = 48
    Height = 15
    Caption = #54924#50896#44032#51077
    OnClick = Label2Click
  end
  object Label4: TLabel
    Left = 382
    Top = 361
    Width = 75
    Height = 15
    Caption = #48708#48128#48264#54840' '#52286#44592
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 288
    Top = 65
    Width = 86
    Height = 47
    Caption = 'Login'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = Label2Click
  end
  object Edit1: TEdit
    Left = 192
    Top = 149
    Width = 265
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 192
    Top = 218
    Width = 265
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 192
    Top = 261
    Width = 265
    Height = 41
    Caption = #47196#44536#51064
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 308
    Width = 265
    Height = 37
    Caption = #44036#54200' '#47196#44536#51064
    TabOrder = 3
    OnClick = Button2Click
  end
  object FDQueryMembers: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from chat')
    Left = 622
    Top = 352
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    DriverID = 'MySQL'
    VendorLib = 'C:\MYPROGRAM\delphi\mysql\mysql-5.7.33-win32\lib\libmysql.dll'
    Left = 548
    Top = 256
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'Database=chating app'
      'User_Name=root'
      'Password=1234'
      'CharacterSet=utf8mb4'
      'DriverID=MySQL')
    Left = 620
    Top = 472
  end
end
