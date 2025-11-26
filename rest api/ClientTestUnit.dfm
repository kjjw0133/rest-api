object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'REST API '#53580#49828#53944' '#53364#46972#51060#50616#53944
  ClientHeight = 650
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 145
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 51
      Height = 15
      Caption = 'Base URL:'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 51
      Height = 15
      Caption = 'Endpoint:'
    end
    object Label5: TLabel
      Left = 16
      Top = 96
      Width = 65
      Height = 15
      Caption = 'Resource ID:'
    end
    object EditBaseURL: TEdit
      Left = 112
      Top = 13
      Width = 760
      Height = 23
      TabOrder = 0
      Text = 'http://localhost:8080'
    end
    object ComboBoxEndpoint: TComboBox
      Left = 112
      Top = 53
      Width = 760
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = ComboBoxEndpointChange
    end
    object EditResourceld: TEdit
      Left = 112
      Top = 93
      Width = 200
      Height = 23
      TabOrder = 2
    end
  end
  object PanelMiddle: TPanel
    Left = 0
    Top = 145
    Width = 900
    Height = 200
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label3: TLabel
      Left = 16
      Top = 8
      Width = 75
      Height = 15
      Caption = 'Request Body:'
    end
    object MemoRequestBody: TMemo
      Left = 16
      Top = 29
      Width = 856
      Height = 155
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 410
    Width = 900
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Label4: TLabel
      Left = 16
      Top = 8
      Width = 53
      Height = 15
      Caption = 'Response:'
    end
    object MemoResponse: TMemo
      Left = 16
      Top = 29
      Width = 856
      Height = 195
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 345
    Width = 900
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object LabelStatus: TLabel
      Left = 120
      Top = 24
      Width = 39
      Height = 15
      Caption = #45824#44592' '#51473
    end
    object BtnExecute: TButton
      Left = 16
      Top = 16
      Width = 89
      Height = 33
      Caption = #49892#54665
      TabOrder = 0
      OnClick = BtnExecuteClick
    end
  end
  object RESTClient1: TRESTClient
    Params = <>
    Left = 800
    Top = 16
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    Left = 800
    Top = 64
  end
  object RESTResponse1: TRESTResponse
    Left = 800
    Top = 112
  end
end
