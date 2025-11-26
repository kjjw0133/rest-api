unit ServerMainUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  Web.HTTPApp, Web.ReqMulti, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient,System.IOUtils;

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
    function HandleLogin(Request: TWebRequest; Response: TWebResponse): Boolean;
    function HandleSignup(Request: TWebRequest; Response: TWebResponse): Boolean;
    function HandleLogout(Request: TWebRequest; Response: TWebResponse): Boolean;
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

function TWebModule1.HandleSignup(Request: TWebRequest; Response: TWebResponse): Boolean;
var
  Body, Username, Password, Name, Email, Phone: string;
  JsonObj, ResultObj: TJSONObject;
begin
  Result := True;
  SetCORSHeaders(Response);

  // POST 요청만 허용
  if Request.MethodType <> mtPost then
  begin
    Response.StatusCode := 405;
    Response.Content := '{"error":"Method not allowed"}';
    Exit;
  end;

  Body := Request.Content;
  JsonObj := TJSONObject.ParseJSONValue(Body) as TJSONObject;

  if JsonObj = nil then
  begin
    Response.StatusCode := 400;
    Response.Content := '{"error":"Invalid JSON"}';
    Exit;
  end;

  try
    Username := JsonObj.GetValue<string>('username');
    Password := JsonObj.GetValue<string>('password');

    // 선택적 필드
    if JsonObj.TryGetValue<string>('name', Name) then
      Name := JsonObj.GetValue<string>('name')
    else
      Name := '';

    if JsonObj.TryGetValue<string>('email', Email) then
      Email := JsonObj.GetValue<string>('email')
    else
      Email := '';

    if JsonObj.TryGetValue<string>('phone', Phone) then
      Phone := JsonObj.GetValue<string>('phone')
    else
      Phone := '';

    // 중복 체크
    FDQuery1.Close;
    FDQuery1.SQL.Text := 'SELECT COUNT(*) as cnt FROM users WHERE username = :u';
    FDQuery1.ParamByName('u').AsWideString := Username;
    FDQuery1.Open;

    if FDQuery1.FieldByName('cnt').AsInteger > 0 then
    begin
      ResultObj := TJSONObject.Create;
      try
        ResultObj.AddPair('success', TJSONBool.Create(False));
        ResultObj.AddPair('message', '이미 존재하는 사용자명입니다');
        Response.StatusCode := 400;
        Response.Content := ResultObj.Format;
      finally
        ResultObj.Free;
      end;
      Exit;
    end;

    // 사용자 생성
    FDQuery1.Close;
    FDQuery1.SQL.Text :=
      'INSERT INTO users (username, password, name, email, phone) VALUES (:u, :p, :n, :e, :ph)';
    FDQuery1.ParamByName('u').AsWideString := Username;
    FDQuery1.ParamByName('p').AsWideString := Password; // ※ 실제로는 해싱 필요
    FDQuery1.ParamByName('n').AsWideString := Name;
    FDQuery1.ParamByName('e').AsWideString := Email;
    FDQuery1.ParamByName('ph').AsWideString := Phone;
    FDQuery1.ExecSQL;

    // 생성된 ID 가져오기
    FDQuery1.Close;
    FDQuery1.SQL.Text := 'SELECT LAST_INSERT_ID() as new_id';
    FDQuery1.Open;

    ResultObj := TJSONObject.Create;
    try
      ResultObj.AddPair('success', TJSONBool.Create(True));
      ResultObj.AddPair('message', '회원가입이 완료되었습니다');
      ResultObj.AddPair('id', TJSONNumber.Create(FDQuery1.FieldByName('new_id').AsInteger));
      Response.Content := ResultObj.Format;
    finally
      ResultObj.Free;
    end;

  finally
    JsonObj.Free;
  end;
end;

function TWebModule1.HandleLogin(Request: TWebRequest; Response: TWebResponse): Boolean;
var
  Body, Username, Password: string;
  JsonObj, ResultObj: TJSONObject;
  UserId: Integer;
  IsLoggedIn: Integer;
begin
  Result := True;
  SetCORSHeaders(Response);

  // POST 요청만 허용
  if Request.MethodType <> mtPost then
  begin
    Response.StatusCode := 405;
    Response.Content := '{"error":"Method not allowed"}';
    Exit;
  end;

  Body := Request.Content;
  JsonObj := TJSONObject.ParseJSONValue(Body) as TJSONObject;

  if JsonObj = nil then
  begin
    Response.StatusCode := 400;
    Response.Content := '{"error":"Invalid JSON"}';
    Exit;
  end;

  try
    try
      Username := JsonObj.GetValue<string>('username');
      Password := JsonObj.GetValue<string>('password');

      // 사용자 인증
      FDQuery1.Close;
      FDQuery1.SQL.Text :=
        'SELECT id, username, name, email, IFNULL(is_logged_in, 0) as is_logged_in FROM users WHERE username = :u AND password = :p';
      FDQuery1.ParamByName('u').AsWideString := Username;
      FDQuery1.ParamByName('p').AsWideString := Password;
      FDQuery1.Open;

      ResultObj := TJSONObject.Create;
      try
        if not FDQuery1.Eof then
        begin
          UserId := FDQuery1.FieldByName('id').AsInteger;
          IsLoggedIn := FDQuery1.FieldByName('is_logged_in').AsInteger;

          // 이미 로그인 상태인지 확인 (선택사항 - 중복 로그인 허용하려면 주석 처리)
          {
          if IsLoggedIn = 1 then
          begin
            ResultObj.AddPair('success', TJSONBool.Create(False));
            ResultObj.AddPair('message', '이미 다른 곳에서 로그인되어 있습니다');
            Response.StatusCode := 409; // Conflict
            Response.Content := ResultObj.Format;
            Exit;
          end;
          }

          // 로그인 상태를 1로 업데이트
          FDQuery1.Close;
          FDQuery1.SQL.Text := 'UPDATE users SET is_logged_in = 1 WHERE id = :id';
          FDQuery1.ParamByName('id').AsInteger := UserId;
          FDQuery1.ExecSQL;

          // 업데이트된 사용자 정보 다시 조회
          FDQuery1.Close;
          FDQuery1.SQL.Text :=
            'SELECT id, username, name, email FROM users WHERE id = :id';
          FDQuery1.ParamByName('id').AsInteger := UserId;
          FDQuery1.Open;

          ResultObj.AddPair('success', TJSONBool.Create(True));
          ResultObj.AddPair('message', '로그인 성공');
          ResultObj.AddPair('id', TJSONNumber.Create(FDQuery1.FieldByName('id').AsInteger));
          ResultObj.AddPair('username', FDQuery1.FieldByName('username').AsWideString);

          // name과 email이 NULL일 수 있으므로 안전하게 처리
          if not FDQuery1.FieldByName('name').IsNull then
            ResultObj.AddPair('name', FDQuery1.FieldByName('name').AsWideString)
          else
            ResultObj.AddPair('name', '');

          if not FDQuery1.FieldByName('email').IsNull then
            ResultObj.AddPair('email', FDQuery1.FieldByName('email').AsWideString)
          else
            ResultObj.AddPair('email', '');

          ResultObj.AddPair('is_logged_in', TJSONBool.Create(True));
        end
        else
        begin
          ResultObj.AddPair('success', TJSONBool.Create(False));
          ResultObj.AddPair('message', '아이디 또는 비밀번호가 올바르지 않습니다');
          Response.StatusCode := 401; // Unauthorized
        end;

        Response.Content := ResultObj.Format;
      finally
        ResultObj.Free;
      end;

    except
      on E: Exception do
      begin
        Response.StatusCode := 500;
        ResultObj := TJSONObject.Create;
        try
          ResultObj.AddPair('error', '서버 오류: ' + E.Message);
          Response.Content := ResultObj.Format;
        finally
          ResultObj.Free;
        end;
      end;
    end;
  finally
    JsonObj.Free;
  end;
end;

function TWebModule1.HandleLogout(Request: TWebRequest; Response: TWebResponse): Boolean;
var
  Body, Username: string;
  JsonObj, ResultObj: TJSONObject;
  AffectedRows: Integer;
begin
  Result := True;
  SetCORSHeaders(Response);

  // POST 요청만 허용
  if Request.MethodType <> mtPost then
  begin
    Response.StatusCode := 405;
    Response.Content := '{"error":"Method not allowed"}';
    Exit;
  end;

  Body := Request.Content;
  JsonObj := TJSONObject.ParseJSONValue(Body) as TJSONObject;

  if JsonObj = nil then
  begin
    Response.StatusCode := 400;
    Response.Content := '{"error":"Invalid JSON"}';
    Exit;
  end;

  try
    Username := JsonObj.GetValue<string>('username');

    // 사용자 존재 여부 확인
    FDQuery1.Close;
    FDQuery1.SQL.Text := 'SELECT COUNT(*) as cnt FROM users WHERE username = :u';
    FDQuery1.ParamByName('u').AsWideString := Username;
    FDQuery1.Open;

    if FDQuery1.FieldByName('cnt').AsInteger = 0 then
    begin
      ResultObj := TJSONObject.Create;
      try
        ResultObj.AddPair('success', TJSONBool.Create(False));
        ResultObj.AddPair('message', '존재하지 않는 사용자입니다');
        Response.StatusCode := 404;
        Response.Content := ResultObj.Format;
      finally
        ResultObj.Free;
      end;
      Exit;
    end;

    // 로그인 상태를 0으로 업데이트
    FDQuery1.Close;
    FDQuery1.SQL.Text := 'UPDATE users SET is_logged_in = 0 WHERE username = :u';
    FDQuery1.ParamByName('u').AsWideString := Username;
    FDQuery1.ExecSQL;
    AffectedRows := FDQuery1.RowsAffected;

    ResultObj := TJSONObject.Create;
    try
      if AffectedRows > 0 then
      begin
        ResultObj.AddPair('success', TJSONBool.Create(True));
        ResultObj.AddPair('message', '로그아웃 성공');
        Response.StatusCode := 200;
      end
      else
      begin
        ResultObj.AddPair('success', TJSONBool.Create(False));
        ResultObj.AddPair('message', '로그아웃 처리 실패');
        Response.StatusCode := 500;
      end;
      Response.Content := ResultObj.Format;
    finally
      ResultObj.Free;
    end;

  finally
    JsonObj.Free;
  end;
end;
function TWebModule1.HandleUsers(Request: TWebRequest; Response: TWebResponse): Boolean;
var
  JsonObj, ResultObj: TJSONObject;
  JsonArray: TJSONArray;
  PathInfo: string;
  UserId: string;
  IsLoggedIn: Integer;
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
      // IFNULL을 사용하여 NULL을 0으로 변환
      FDQuery1.SQL.Text := 'SELECT id, username, name, email, phone, IFNULL(is_logged_in, 0) as is_logged_in FROM users';
      FDQuery1.Open;

      while not FDQuery1.Eof do
      begin
        JsonObj := TJSONObject.Create;
        JsonObj.AddPair('id', TJSONNumber.Create(FDQuery1.FieldByName('id').AsInteger));
        JsonObj.AddPair('username', FDQuery1.FieldByName('username').AsWideString);

        // NULL 값 안전하게 처리
        if not FDQuery1.FieldByName('name').IsNull then
          JsonObj.AddPair('name', FDQuery1.FieldByName('name').AsWideString)
        else
          JsonObj.AddPair('name', '');

        if not FDQuery1.FieldByName('email').IsNull then
          JsonObj.AddPair('email', FDQuery1.FieldByName('email').AsWideString)
        else
          JsonObj.AddPair('email', '');

        if not FDQuery1.FieldByName('phone').IsNull then
          JsonObj.AddPair('phone', FDQuery1.FieldByName('phone').AsWideString)
        else
          JsonObj.AddPair('phone', '');

        // IFNULL 사용했으므로 안전하게 AsInteger 가능
        JsonObj.AddPair('is_logged_in', TJSONBool.Create(
          FDQuery1.FieldByName('is_logged_in').AsInteger = 1));

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
      // IFNULL을 사용하여 NULL을 0으로 변환
      FDQuery1.SQL.Text :=
        'SELECT id, username, name, email, phone, IFNULL(is_logged_in, 0) as is_logged_in FROM users WHERE id = :id';
      FDQuery1.ParamByName('id').AsInteger := StrToIntDef(UserId, 0);
      FDQuery1.Open;

      if not FDQuery1.Eof then

      begin
        JsonObj.AddPair('id', TJSONNumber.Create(FDQuery1.FieldByName('id').AsInteger));
        JsonObj.AddPair('username', FDQuery1.FieldByName('username').AsWideString);

        // NULL 값 안전하게 처리
        if not FDQuery1.FieldByName('name').IsNull then
          JsonObj.AddPair('name', FDQuery1.FieldByName('name').AsWideString)
        else
          JsonObj.AddPair('name', '');

        if not FDQuery1.FieldByName('email').IsNull then
          JsonObj.AddPair('email', FDQuery1.FieldByName('email').AsWideString)
        else
          JsonObj.AddPair('email', '');

        if not FDQuery1.FieldByName('phone').IsNull then
          JsonObj.AddPair('phone', FDQuery1.FieldByName('phone').AsWideString)
        else
          JsonObj.AddPair('phone', '');

        // IFNULL 사용했으므로 안전하게 AsInteger 가능
        JsonObj.AddPair('is_logged_in', TJSONBool.Create(
          FDQuery1.FieldByName('is_logged_in').AsInteger = 1));
      end
      else
      begin
        Response.StatusCode := 404;
        JsonObj.AddPair('error', '사용자를 찾을 수 없습니다');
      end;

      Response.Content := JsonObj.ToJSON;
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
      if JsonObj = nil then
      begin
        Response.StatusCode := 400;
        Response.Content := '{"error": "Invalid JSON"}';
        Exit;
      end;

      ResultObj := TJSONObject.Create;
      try
        FDQuery1.Close;
        FDQuery1.SQL.Text := 'UPDATE users SET name = :name, email = :email, phone = :phone WHERE id = :id';
        FDQuery1.ParamByName('id').AsInteger := StrToIntDef(UserId, 0);
        FDQuery1.ParamByName('name').AsWideString := JsonObj.GetValue<String>('name');
        FDQuery1.ParamByName('email').AsWideString := JsonObj.GetValue<String>('email');
        FDQuery1.ParamByName('phone').AsWideString := JsonObj.GetValue<String>('phone');
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
      FDQuery1.SQL.Text := 'DELETE FROM users WHERE id = :id';
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

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  JsonObj: TJSONObject;
  JsonArray: TJSONArray;
begin
  // OPTIONS 요청 처리 (CORS preflight)
  if Request.Method = 'OPTIONS' then
  begin
    SetCORSHeaders(Response);
    Response.StatusCode := 200;
    Handled := True;
    Exit;
  end;

  // 루트 경로 처리 - API 정보 제공
  if (Request.PathInfo = '/') or (Request.PathInfo = '') then
  begin
    SetCORSHeaders(Response);
    Response.ContentType := 'text/html; charset=UTF-8';
    Response.Content := TFile.ReadAllText('C:\MYPROGRAM\delphi\rest api - 복사본\Win32\Debug\Untitled1.htm');
    Handled := True;
  end
  else if Request.PathInfo = '/signup' then
  begin
    SetCORSHeaders(Response);
    Response.ContentType := 'text/html; charset=UTF-8';
    Response.Content := TFile.ReadAllText('C:\MYPROGRAM\delphi\rest api - 복사본\Win32\Debug\Untitled2.htm');
    Handled := True;
  end
  // 회원가입 처리
  else if Request.PathInfo = '/api/signup' then
    Handled := HandleSignup(Request, Response)
  // 로그인 처리
  else if Request.PathInfo = '/api/login' then
    Handled := HandleLogin(Request, Response)
  // 로그아웃 처리
  else if Request.PathInfo = '/api/logout' then
    Handled := HandleLogout(Request, Response)
  // 사용자 API 처리
  else if Request.PathInfo.StartsWith('/api/users') then
    Handled := HandleUsers(Request, Response)
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
