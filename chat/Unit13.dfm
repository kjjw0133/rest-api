object Form13: TForm13
  Left = 0
  Top = 0
  Caption = 'Form13'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Edit1: TEdit
    Left = 240
    Top = 97
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 40
    Top = 136
    Width = 329
    Height = 241
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 40
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 121
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Start/Stop'
    TabOrder = 3
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 8080
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    Left = 464
    Top = 168
  end
end
