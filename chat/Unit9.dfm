object Form9: TForm9
  Left = 0
  Top = 0
  Caption = 'Form9'
  ClientHeight = 440
  ClientWidth = 494
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 128
    Top = 143
    Width = 62
    Height = 25
    Caption = #48169' '#48264#54840
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 128
    Top = 303
    Width = 76
    Height = 25
    Caption = #48708#48128#48264#54840
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 280
    Top = 247
    Width = 20
    Height = 25
    Caption = '11'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 128
    Top = 247
    Width = 62
    Height = 25
    Caption = #51064#50896' '#49688
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 280
    Top = 191
    Width = 55
    Height = 25
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 128
    Top = 191
    Width = 38
    Height = 25
    Caption = #51060#47492
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 280
    Top = 143
    Width = 20
    Height = 25
    Caption = '11'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 280
    Top = 303
    Width = 55
    Height = 25
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 114
    Top = 40
    Width = 253
    Height = 65
    Caption = #52292#54021#48169' '#51221#48372
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -48
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object FDQueryMembers: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from chat')
    Left = 402
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
    Left = 466
    Top = 412
  end
end
