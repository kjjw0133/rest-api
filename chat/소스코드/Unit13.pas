unit Unit13;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.ScktComp,
  System.Generics.Collections;

type
  TClientInfo = class
    Socket: TCustomWinSocket;
    RoomId: Integer;
    NickName: string;
  end;

  TForm13 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    ServerSocket1: TServerSocket;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);

    procedure ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    Clients: TObjectList<TClientInfo>;
    procedure BroadcastToRoom(RoomId: Integer; const Msg: string);
    function FindClient(Socket: TCustomWinSocket): TClientInfo;
  public
  end;

var
  Form13: TForm13;

implementation

{$R *.dfm}

procedure TForm13.FormCreate(Sender: TObject);
begin
  Clients := TObjectList<TClientInfo>.Create(True);
  ServerSocket1.Port := 8080;
  ServerSocket1.Active := True;
//  ButtonSend.Enabled := False;
end;

procedure TForm13.ButtonStartClick(Sender: TObject);
begin
  ServerSocket1.Active := not ServerSocket1.Active;
  if ServerSocket1.Active then
  begin
    Memo1.Lines.Add('서버 시작 (포트 8080)');
//    ButtonStart.Caption := '서버 중지';
//    ButtonSend.Enabled := True;
  end
  else
  begin
    Memo1.Lines.Add('서버 중지됨');
//    ButtonStart.Caption := '서버 시작';
//    ButtonSend.Enabled := False;
    Clients.Clear;
  end;
end;

procedure TForm13.ServerSocket1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add(Format('클라이언트 접속: %s', [Socket.RemoteAddress]));
end;

procedure TForm13.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  C: TClientInfo;
begin
  C := FindClient(Socket);
  if C <> nil then
  begin
    Memo1.Lines.Add(Format('%s (%d번 방) 퇴장', [C.NickName, C.RoomId]));
    Clients.Remove(C);
  end;
end;

procedure TForm13.ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  Msg, Cmd, RoomStr, Nick, Text: string;
  RoomId: Integer;
  Parts: TArray<string>;
  C: TClientInfo;
begin
  Msg := Socket.ReceiveText;
  Memo1.Lines.Add('수신: ' + Msg);

  Parts := Msg.Split(['|']);
  if Length(Parts) < 2 then Exit;

  Cmd := Parts[0];

  if Cmd = 'JOIN' then
  begin
    if Length(Parts) < 3 then Exit;
    RoomStr := Parts[1];
    Nick := Parts[2];
    RoomId := StrToIntDef(RoomStr, 0);

    C := TClientInfo.Create;
    C.Socket := Socket;
    C.RoomId := RoomId;
    C.NickName := Nick;
    Clients.Add(C);

    Memo1.Lines.Add(Format('%s이(가) %d번 방에 입장', [Nick, RoomId]));
    BroadcastToRoom(RoomId, Format('%s님이 입장했습니다.', [Nick]));
  end
  else if Cmd = 'MSG' then
  begin
    if Length(Parts) < 4 then Exit;
    RoomId := StrToIntDef(Parts[1], 0);
    Nick := Parts[2];
    Text := Parts[3];

    BroadcastToRoom(RoomId, Format('%s: %s', [Nick, Text]));
  end;
end;

procedure TForm13.BroadcastToRoom(RoomId: Integer; const Msg: string);
var
  C: TClientInfo;
begin
  for C in Clients do
    if C.RoomId = RoomId then
      C.Socket.SendText(Msg);
end;

function TForm13.FindClient(Socket: TCustomWinSocket): TClientInfo;
var
  C: TClientInfo;
begin
  Result := nil;
  for C in Clients do
    if C.Socket = Socket then
      Exit(C);
end;

procedure TForm13.ButtonSendClick(Sender: TObject);
begin
  BroadcastToRoom(0, '[서버]: ' + Edit1.Text);
  Edit1.Clear;
end;

end.

