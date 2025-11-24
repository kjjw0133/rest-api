object Form3: TForm3
  Left = 0
  Top = 0
  Caption = '3'
  ClientHeight = 613
  ClientWidth = 893
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 224
    Top = 144
    Width = 50
    Height = 15
    Caption = #49324#50857#51088' ID'
  end
  object Label3: TLabel
    Left = 224
    Top = 213
    Width = 48
    Height = 15
    Caption = #48708#48128#48264#54840
  end
  object Label2: TLabel
    Left = 224
    Top = 325
    Width = 24
    Height = 15
    Caption = #51060#47492
  end
  object Label4: TLabel
    Left = 224
    Top = 269
    Width = 36
    Height = 15
    Caption = #51060#47700#51068
  end
  object Label5: TLabel
    Left = 296
    Top = 80
    Width = 116
    Height = 40
    Caption = #54924#50896#44032#51077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 224
    Top = 165
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
    Left = 224
    Top = 234
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
    Left = 224
    Top = 393
    Width = 265
    Height = 41
    Caption = #54924#50896#44032#51077
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit3: TEdit
    Left = 224
    Top = 346
    Width = 265
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Edit4: TEdit
    Left = 224
    Top = 290
    Width = 137
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object ComboBox1: TComboBox
    Left = 367
    Top = 290
    Width = 122
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = #51649#51217' '#51077#47141
    OnChange = ComboBox1Change
    Items.Strings = (
      '@naver.com'
      '@gmail.com'
      '@daum.net'
      '@nate.com')
  end
  object FDQueryMembers: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from chat')
    Left = 638
    Top = 408
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'Database=chating app'
      'User_Name=root'
      'Password=1234'
      'CharacterSet=utf8mb4'
      'DriverID=MySQL')
    Left = 560
    Top = 304
  end
end
