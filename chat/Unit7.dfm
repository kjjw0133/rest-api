object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 676
  ClientWidth = 950
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 394
    Top = 72
    Width = 79
    Height = 32
    Caption = #52292#54021' '#50545
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 22
    Width = 66
    Height = 15
    Caption = #48169' '#53076#46300' '#51077#47141
  end
  object Label4: TLabel
    Left = 241
    Top = 22
    Width = 90
    Height = 15
    Caption = #48169' '#48708#48128#48264#54840' '#51077#47141
  end
  object Edit2: TEdit
    Left = 98
    Top = 19
    Width = 121
    Height = 23
    Enabled = False
    TabOrder = 0
  end
  object Button3: TButton
    Left = 834
    Top = 250
    Width = 75
    Height = 25
    Caption = #52292#54021#48169' '#49373#49457
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 705
    Top = 18
    Width = 75
    Height = 25
    Caption = #47196#44536#51064
    TabOrder = 2
    OnClick = Button4Click
  end
  object Button6: TButton
    Left = 506
    Top = 18
    Width = 75
    Height = 25
    Caption = #52292#54021#48169' '#51077#51109
    TabOrder = 3
    OnClick = Button6Click
  end
  object Edit1: TEdit
    Left = 337
    Top = 19
    Width = 121
    Height = 23
    Enabled = False
    PasswordChar = '*'
    TabOrder = 4
  end
  object Button1: TButton
    Left = 786
    Top = 18
    Width = 75
    Height = 25
    Caption = #54924#50896#44032#51077
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 730
    Top = 250
    Width = 75
    Height = 25
    Caption = #47560#51060#54168#51060#51648
    TabOrder = 6
    OnClick = Button2Click
  end
  object ScrollBox1: TScrollBox
    Left = 131
    Top = 110
    Width = 593
    Height = 505
    TabOrder = 7
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'Database=chating app'
      'User_Name=root'
      'Password=1234'
      'CharacterSet=utf8mb4'
      'DriverID=MySQL')
    Left = 632
    Top = 424
  end
  object FDQueryMembers: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from user')
    Left = 312
    Top = 424
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 800
    Top = 376
  end
end
