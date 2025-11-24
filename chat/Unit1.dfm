object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 705
  ClientWidth = 803
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 133
    Top = 65
    Width = 69
    Height = 30
    Caption = #48169' '#51060#47492
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Transparent = False
  end
  object Label2: TLabel
    Left = 133
    Top = 101
    Width = 39
    Height = 17
    Caption = #51064#50896#49688
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Transparent = False
  end
  object Edit1: TEdit
    Left = 40
    Top = 546
    Width = 593
    Height = 55
    AutoSize = False
    TabOrder = 3
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 558
    Top = 546
    Width = 75
    Height = 55
    Caption = #51204#49569
    TabOrder = 0
    OnClick = Button1Click
  end
  object RichEdit1: TRichEdit
    Left = 40
    Top = 130
    Width = 593
    Height = 417
    Alignment = taCenter
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      'RichEdit1')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 40
    Top = 49
    Width = 593
    Height = 82
    TabOrder = 2
    object SpeedButton3: TSpeedButton
      Left = 504
      Top = 8
      Width = 81
      Height = 67
      Caption = #9776
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -35
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
    end
    object SpeedButton1: TSpeedButton
      Left = 0
      Top = 0
      Width = 95
      Height = 62
      Caption = #8592
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -48
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton1Click
    end
  end
  object FDQueryMembers: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from chat')
    Left = 702
    Top = 488
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    DriverID = 'MySQL'
    VendorLib = 'C:\MYPROGRAM\delphi\mysql\mysql-5.7.33-win32\lib\libmysql.dll'
    Left = 718
    Top = 408
  end
  object FDQueryMessage: TFDQuery
    SQL.Strings = (
      'select * from chat')
    Left = 526
    Top = 200
  end
  object FDQueryTIme: TFDQuery
    SQL.Strings = (
      'select * from chat')
    Left = 406
    Top = 264
  end
  object PopupMenu1: TPopupMenu
    Left = 152
    Top = 144
    object N4: TMenuItem
      Caption = #47560#51060#54168#51060#51648
    end
    object N1: TMenuItem
      Caption = #48169' '#51221#48372
    end
    object N2: TMenuItem
      Caption = #48169' '#45208#44032#44592
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'Database=chating app'
      'User_Name=root'
      'Password=1234'
      'CharacterSet=utf8mb4'
      'DriverID=MySQL')
    Left = 720
    Top = 312
  end
  object ClientSocket1: TClientSocket
    Active = False
    Address = '127.0.0.1'
    ClientType = ctNonBlocking
    Port = 8080
    OnConnect = ClientSocket1Connect
    OnRead = ClientSocket1Read
    Left = 672
    Top = 64
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 728
    Top = 136
  end
end
