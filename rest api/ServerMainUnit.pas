unit ServerMainUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  Web.HTTPApp, Web.ReqMulti, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient;

type
  TWebModule1 = class(TWebModule)
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest;
      Response: TWebResponse;
      var Handled: Boolean);
  private
    function HandleUsers(Request: TWebRequest; Response: TWebResponse): Boolean;
    function HandleProducts(Request: TWebRequest; Response: TWebResponse): Boolean;
    procedure SetCORSHeaders(Response: TWebResponse);
  public
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TWebModule1.SetCORSHeaders(Response: TWebResponse);
begin
  Response.SetCustomHeader('Access-Control-Allow-Origin', '*');
  Response.SetCustomHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  Response.SetCustomHeader('Access-Control-Allow-Headers', 'Content-Type');
  Response.ContentType := 'application/json; charset=utf-8';
end;

function TWebModule1.HandleUsers(Request: TWebRequest; Response: TWebResponse): Boolean;
var
  JsonObj, ResultObj: TJSONObject;
  JsonArray: TJSONArray;
  PathInfo: string;
  UserId: string;
  id : integer;
  name,email : String;
begin
  Result := True;
  SetCORSHeaders(Response);

  PathInfo := Request.PathInfo;

  // GET /api/users - 사용자 목록 조회
  if (Request.MethodType = mtGet) and (PathInfo = '/api/users') then
  begin
    JsonArray := TJSONArray.Create;
    try
      FDQuery1.Close;
      FDQuery1.SQL.Text := 'select id, name, email from test';
      FDQuery1.Open;

      while not FDQuery1.Eof do
      begin
        JsonObj := TJSONObject.Create;
        JsonObj.AddPair('id', TJSONNumber.Create(FDQuery1.Fields[0].AsInteger));
        JsonObj.AddPair('name', FDQuery1.Fields[1].AsString);
        JsonObj.AddPair('email', FDQuery1.Fields[2].AsString);
        JsonArray.AddElement(JsonObj);
        FDQuery1.Next;
      end;

      Response.Content := JsonArray.ToJSON;
    finally
      JsonArray.Free;
    end;
  end

  // GET /api/users/{id} - 특정 사용자 조회
  else if (Request.MethodType = mtGet) and PathInfo.StartsWith('/api/users/') then
  begin
    UserId := PathInfo.Replace('/api/users/', '');
    JsonObj := TJSONObject.Create;
    try
      FDQuery1.Close;
      FDQuery1.SQL.Text := 'select id, name, email, phone from test where id = :id ';
      FDQuery1.ParamByName('id').AsInteger := StrToIntDef(UserId,0);
      FDQuery1.Open;

      while not FDQuery1.Eof do
      begin
        JsonObj.AddPair('id', TJSONNumber.Create(FDQuery1.Fields[0].AsInteger));
        JsonObj.AddPair('name', FDQuery1.Fields[1].AsString);
        JsonObj.AddPair('email', FDQuery1.Fields[2].AsString);
        JsonObj.AddPair('phone', FDQuery1.Fields[3].AsString);
        FDQuery1.Next;
      end;
      Response.Content := JsonObj.ToJSON;
    finally
      JsonObj.Free;
    end;
  end

 // POST /api/users - 사용자 생성 (DB에 INSERT)
  else if (Request.MethodType = mtPost) and (PathInfo = '/api/users') then
  begin
    JsonObj := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;
    try
      if JsonObj = nil then
      begin
        Response.StatusCode := 400;
        Response.Content := '{"error": "Invalid JSON"}';
        Exit;
      end;

      try
        FDQuery1.Close;
        FDQuery1.SQL.Text := 'INSERT INTO test(name, email, phone) VALUES(:name, :email, :phone)';
        FDQuery1.ParamByName('name').AsString := JsonObj.GetValue<string>('name');
        FDQuery1.ParamByName('email').AsString := JsonObj.GetValue<string>('email');
        FDQuery1.ParamByName('phone').AsString := JsonObj.GetValue<string>('phone');
        FDQuery1.ExecSQL;

        FDQuery1.Close;
        FDQuery1.SQL.Text := 'SELECT LAST_INSERT_ID() as new_id';
        FDQuery1.Open;

        ResultObj := TJSONObject.Create;
        try
          ResultObj.AddPair('success', TJSONBool.Create(True));
          ResultObj.AddPair('message', '사용자가 생성되었습니다');
          ResultObj.AddPair('id', TJSONNumber.Create(FDQuery1.FieldByName('new_id').AsInteger));
          ResultObj.AddPair('data', JsonObj.Clone as TJSONObject);
          Response.Content := ResultObj.ToJSON;
        finally
          ResultObj.Free;
        end;
      finally
        FDQuery1.Close;
      end;
    finally
      JsonObj.Free;
    end;
  end

  // PUT /api/users/{id} - 사용자 수정
  else if (Request.MethodType = mtPut) and PathInfo.StartsWith('/api/users/') then
  begin
    UserId := PathInfo.Replace('/api/users/', '');
    JsonObj := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;
    try
      ResultObj := TJSONObject.Create;
      try
        FDQuery1.Close;
        FDQuery1.SQL.Text := 'UPDATE test SET name = :name, email = :email, phone = :phone where id = :id ';
        FDQuery1.ParamByName('id').AsInteger := StrToIntDef(UserId, 0);
        FDQuery1.ParamByName('name').AsString := JsonObj.GetValue<String>('name');
        FDQuery1.ParamByName('email').AsString := JsonObj.GetValue<String>('email');
        FDQuery1.ParamByName('phone').AsString := JsonObj.GetValue<String>('phone');
        FDQuery1.ExecSQL;


        ResultObj.AddPair('success', TJSONBool.Create(True));
        ResultObj.AddPair('message', '사용자 정보가 수정되었습니다');
        ResultObj.AddPair('id', TJSONNumber.Create(StrToIntDef(UserId, 0)));
        Response.Content := ResultObj.ToJSON;
      finally
        ResultObj.Free;
      end;
    finally
      JsonObj.Free;
    end;
  end

  // DELETE /api/users/{id} - 사용자 삭제
  else if (Request.MethodType = mtDelete) and PathInfo.StartsWith('/api/users/') then
  begin
    UserId := PathInfo.Replace('/api/users/', '');
    ResultObj := TJSONObject.Create;
    try
      FDQuery1.Close;
      FDQuery1.SQL.Text := 'DELETE FROM test WHERE id = :id ';
      FDQuery1.ParamByName('id').AsInteger := StrToIntDef(UserId, 0);
      FDQuery1.ExecSQL;

      ResultObj.AddPair('success', TJSONBool.Create(True));
      ResultObj.AddPair('message', '사용자가 삭제되었습니다');
      ResultObj.AddPair('id', TJSONNumber.Create(StrToIntDef(UserId, 0)));
      Response.Content := ResultObj.ToJSON;
    finally
      ResultObj.Free;
    end;
  end
  else
  begin
    Response.StatusCode := 404;
    Response.Content := '{"error": "User endpoint not found"}';
  end;
end;

function TWebModule1.HandleProducts(Request: TWebRequest; Response: TWebResponse): Boolean;
var
  JsonObj: TJSONObject;
  JsonArray: TJSONArray;
begin
  Result := True;
  SetCORSHeaders(Response);

  // GET /api/products - 상품 목록 조회
  if (Request.MethodType = mtGet) and (Request.PathInfo = '/api/products') then
  begin
    JsonArray := TJSONArray.Create;
    try
      JsonObj := TJSONObject.Create;
      JsonObj.AddPair('id', TJSONNumber.Create(1));
      JsonObj.AddPair('name', '노트북');
      JsonObj.AddPair('price', TJSONNumber.Create(1500000));
      JsonArray.AddElement(JsonObj);

      JsonObj := TJSONObject.Create;
      JsonObj.AddPair('id', TJSONNumber.Create(2));
      JsonObj.AddPair('name', '마우스');
      JsonObj.AddPair('price', TJSONNumber.Create(30000));
      JsonArray.AddElement(JsonObj);

      Response.Content := JsonArray.ToJSON;
    finally
      JsonArray.Free;
    end;
  end
  else
  begin
    Response.StatusCode := 404;
    Response.Content := '{"error": "Product endpoint not found"}';
  end;
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  JsonObj: TJSONObject;
  JsonArray: TJSONArray;
begin
  // 루트 경로 처리 - API 정보 제공
  if (Request.PathInfo = '/') or (Request.PathInfo = '') then
  begin
    SetCORSHeaders(Response);

    JsonObj := TJSONObject.Create;
    try
      JsonObj.AddPair('status', 'running');
      JsonObj.AddPair('message', 'REST API Server is running');
      JsonObj.AddPair('version', '1.0');

      JsonArray := TJSONArray.Create;
      JsonArray.Add('GET /api/users - 사용자 목록 조회');
      JsonArray.Add('GET /api/users/{id} - 특정 사용자 조회');
      JsonArray.Add('POST /api/users - 사용자 생성');
      JsonArray.Add('PUT /api/users/{id} - 사용자 수정');
      JsonArray.Add('DELETE /api/users/{id} - 사용자 삭제');
      JsonArray.Add('GET /api/products - 상품 목록 조회');

      JsonObj.AddPair('endpoints', JsonArray);

      Response.Content := JsonObj.Format;
    finally
      JsonObj.Free;
    end;

    Handled := True;
  end
  // 사용자 API 처리
  else if Request.PathInfo.StartsWith('/api/users') then
    Handled := HandleUsers(Request, Response)
  // 상품 API 처리
  else if Request.PathInfo.StartsWith('/api/products') then
    Handled := HandleProducts(Request, Response)
  // 그 외 잘못된 경로
  else
  begin
    SetCORSHeaders(Response);
    Response.StatusCode := 404;
    Response.Content := '{"error": "Invalid endpoint", "path": "' + Request.PathInfo + '"}';
    Handled := True;
  end;
end;

end.
