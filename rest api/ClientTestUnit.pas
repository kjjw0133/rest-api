unit ClientTestUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON;

type
  TForm2 = class(TForm)
    PanelTop: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    EditBaseURL: TEdit;
    ComboBoxEndpoint: TComboBox;
    EditResourceld: TEdit;
    PanelMiddle: TPanel;
    Label3: TLabel;
    MemoRequestBody: TMemo;
    PanelBottom: TPanel;
    Label4: TLabel;
    MemoResponse: TMemo;
    PanelButtons: TPanel;
    BtnExecute: TButton;
    LabelStatus: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxEndpointChange(Sender: TObject);
    procedure BtnExecuteClick(Sender: TObject);
  private
    procedure ShowExampleBody;
    procedure ExecuteRequest;
    function MethodToString(Method: TRESTRequestMethod): string;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.ComboBoxEndpointChange(Sender: TObject);
begin
  ShowExampleBody;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  // 엔드포인트 목록 초기화
  ComboBoxEndpoint.Items.Clear;
  ComboBoxEndpoint.Items.Add('GET /api/users - 사용자 목록 조회');
  ComboBoxEndpoint.Items.Add('GET /api/users/{id} - 특정 사용자 조회');
  ComboBoxEndpoint.Items.Add('POST /api/users - 사용자 생성');
  ComboBoxEndpoint.Items.Add('PUT /api/users/{id} - 사용자 수정');
  ComboBoxEndpoint.Items.Add('DELETE /api/users/{id} - 사용자 삭제');
  ComboBoxEndpoint.Items.Add('GET /api/products - 상품 목록 조회');
  ComboBoxEndpoint.ItemIndex := 0;

  // 기본 URL은 FormUnit1에서 설정됨
  if EditBaseURL.Text = '' then
    EditBaseURL.Text := 'http://localhost:8080';

  ShowExampleBody;
end;

procedure TForm2.ShowExampleBody;
var
  JsonObj: TJSONObject;
begin
  MemoRequestBody.Lines.Clear;

  case ComboBoxEndpoint.ItemIndex of
    2: // POST /api/users
    begin
      JsonObj := TJSONObject.Create;
      try
        JsonObj.AddPair('name', 'test');
        JsonObj.AddPair('email', 'test@example.com');
        JsonObj.AddPair('phone', '010-1111-2222');
        MemoRequestBody.Text := JsonObj.Format;
      finally
        JsonObj.Free;
      end;
    end;
    3: // PUT /api/users/{id}
    begin
      JsonObj := TJSONObject.Create;
      try
        JsonObj.AddPair('name', 'test(수정)');
        JsonObj.AddPair('email', 'test_update@example.com');
        JsonObj.AddPair('phone', '010-3333-4444');
        MemoRequestBody.Text := JsonObj.Format;
      finally
        JsonObj.Free;
      end;
      EditResourceld.Text := '1';
    end;
    1, 4: // GET, DELETE /api/users/{id}
      EditResourceld.Text := '1';
  else
    EditResourceld.Text := '';
  end;
end;

procedure TForm2.BtnExecuteClick(Sender: TObject);
begin
  ExecuteRequest;
end;

function TForm2.MethodToString(Method: TRESTRequestMethod): string;
begin
  case Method of
    TRESTRequestMethod.rmGET: Result := 'GET';
    TRESTRequestMethod.rmPOST: Result := 'POST';
    TRESTRequestMethod.rmPUT: Result := 'PUT';
    TRESTRequestMethod.rmDELETE: Result := 'DELETE';
    TRESTRequestMethod.rmPATCH: Result := 'PATCH';
  else
    Result := 'UNKNOWN';
  end;
end;

procedure TForm2.ExecuteRequest;
var
  Method: TRESTRequestMethod;
  Endpoint: string;
  Resourceld: string;
  JsonValue: TJSONValue;
begin
  try
    BtnExecute.Enabled := False;
    LabelStatus.Caption := '요청 중...';
    Application.ProcessMessages;

    // Base URL 설정
    RESTClient1.BaseURL := EditBaseURL.Text;

    // Resource ID 가져오기
    Resourceld := Trim(EditResourceld.Text);

    // 엔드포인트와 메서드 설정
    RESTRequest1.Params.Clear;
    case ComboBoxEndpoint.ItemIndex of
      0: // GET /api/users
      begin
        Endpoint := '/api/users';
        Method := TRESTRequestMethod.rmGET;
      end;
      1: // GET /api/users/{id}
      begin
        Endpoint := '/api/users/' + Resourceld;
        Method := TRESTRequestMethod.rmGET;
      end;
      2: // POST /api/users
      begin
        Endpoint := '/api/users';
        Method := TRESTRequestMethod.rmPOST;
      end;
      3: // PUT /api/users/{id}
      begin
        Endpoint := '/api/users/' + Resourceld;
        Method := TRESTRequestMethod.rmPUT;
      end;
      4: // DELETE /api/users/{id}
      begin
        Endpoint := '/api/users/' + Resourceld;
        Method := TRESTRequestMethod.rmDELETE;
      end;
      5: // GET /api/products
      begin
        Endpoint := '/api/products';
        Method := TRESTRequestMethod.rmGET;
      end;
    else
      Endpoint := '/api/users';
      Method := TRESTRequestMethod.rmGET;
    end;

    RESTRequest1.Resource := Endpoint;
    RESTRequest1.Method := Method;

    // Request Body 설정 (POST, PUT의 경우)
    if (Method in [TRESTRequestMethod.rmPOST, TRESTRequestMethod.rmPUT]) and
       (MemoRequestBody.Text <> '') then
    begin
      RESTRequest1.ClearBody;
      RESTRequest1.AddBody(MemoRequestBody.Text, TRESTContentType.ctAPPLICATION_JSON);
    end;

    // 요청 실행
    RESTRequest1.Execute;

    // 응답 표시
    MemoResponse.Lines.Clear;
    MemoResponse.Lines.Add('=== Request ===');
    MemoResponse.Lines.Add('URL: ' + RESTClient1.BaseURL + Endpoint);
    MemoResponse.Lines.Add('Method: ' + MethodToString(Method));
    MemoResponse.Lines.Add('');
    MemoResponse.Lines.Add('=== Response ===');
    MemoResponse.Lines.Add('Status: ' + IntToStr(RESTResponse1.StatusCode) + ' ' + RESTResponse1.StatusText);
    MemoResponse.Lines.Add('');

    // JSON 포맷팅
    try
      JsonValue := TJSONObject.ParseJSONValue(RESTResponse1.Content);
      if JsonValue <> nil then
      begin
        try
          MemoResponse.Lines.Add(JsonValue.Format);
        finally
          JsonValue.Free;
        end;
      end
      else
        MemoResponse.Lines.Add(RESTResponse1.Content);
    except
      MemoResponse.Lines.Add(RESTResponse1.Content);
    end;

    LabelStatus.Caption := '완료! Status: ' + IntToStr(RESTResponse1.StatusCode);

  except
    on E: Exception do
    begin
      MemoResponse.Lines.Clear;
      MemoResponse.Lines.Add('에러 발생: ' + E.Message);
      LabelStatus.Caption := '에러 발생';
    end;
  end;

  BtnExecute.Enabled := True;
end;

end.
