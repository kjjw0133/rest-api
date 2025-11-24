
unit Unit7;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.ExtCtrls;

type
  TForm7 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    Button4: TButton;
    Button6: TButton;
    Edit1: TEdit;
    Button1: TButton;
    FDConnection1: TFDConnection;
    Button2: TButton;
    ScrollBox1: TScrollBox;
    FDQueryMembers: TFDQuery;
    Timer1: TTimer;
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure ChatPanelClick(Sender: TObject);
  public
    UserNo : Integer;
    procedure LoadChat(Silent: Boolean = False);
  end;

var
  Form7: TForm7;

implementation

uses unit1,unit2,unit3,unit4,unit5,unit6,unit8,unit10,unit11;

{$R *.dfm}

procedure TForm7.LoadChat(Silent: Boolean = False);
var
  ChatPanel: TPanel;
  RoomNameLabel, MemberCountLabel, DateLabel, TimeLabel, LastMsgLabel: TLabel;
  TopOffset: Integer;
begin
  FDQueryMembers.Close;
  FDQueryMembers.SQL.Text :=
    'SELECT chating.c_no, chat_user.ChatRoomId, '+
    'chat.chatroomname AS room_name, chat.num AS member_count, ' +
    'DATE_FORMAT(chating.nowtime, "%Y-%m-%d") AS date, '+
    'DATE_FORMAT(chating.nowtime, "%H:%i") AS time, ' +
    'chating.contents AS last_message FROM chat_user '+
    'JOIN chat ON chat_user.ChatRoomId = chat.ChatRoomId '+
    'JOIN ( SELECT c.* FROM chating c JOIN ( '+
    'SELECT ChatRoomId, MAX(nowtime) AS latest_time '+
    'FROM chating GROUP BY ChatRoomId ' +
    ') latest ON c.ChatRoomId = latest.ChatRoomId  ' +
    'AND c.nowtime = latest.latest_time '+
    ') chating ON chat_user.ChatRoomId = chating.ChatRoomId '+
    'WHERE chat_user.userno = :userno AND chating.contents IS NOT NULL '+
    'ORDER BY chating.nowtime asc ';

  FDQueryMembers.ParamByName('userno').AsInteger := UserNo;
  FDQueryMembers.Open;

  ScrollBox1.DestroyComponents;

  TopOffset := 10;
  while not FDQueryMembers.Eof do
  begin
    ChatPanel := TPanel.Create(ScrollBox1);
    ChatPanel.Parent := ScrollBox1;
    ChatPanel.Align := alTop;
    ChatPanel.Height := 60;
    ChatPanel.Caption := '';
    ChatPanel.Tag := FDQueryMembers.FieldByName('ChatRoomId').AsInteger;
    ChatPanel.OnClick := ChatPanelClick;

    RoomNameLabel := TLabel.Create(ChatPanel);
    RoomNameLabel.Parent := ChatPanel;
    RoomNameLabel.Left := 10;
    RoomNameLabel.Top := 8;
    RoomNameLabel.Font.Style := [fsBold];
    RoomNameLabel.Caption := FDQueryMembers.FieldByName('room_name').AsString;
    RoomNameLabel.Tag := ChatPanel.Tag;
    RoomNameLabel.OnClick := ChatPanelClick;

    MemberCountLabel := TLabel.Create(ChatPanel);
    MemberCountLabel.Parent := ChatPanel;
    MemberCountLabel.Left := 200;
    MemberCountLabel.Top := 8;
    MemberCountLabel.Caption := Format('인원: %d명',
      [FDQueryMembers.FieldByName('member_count').AsInteger]);
    MemberCountLabel.Tag := ChatPanel.Tag;
    MemberCountLabel.OnClick := ChatPanelClick;

    DateLabel := TLabel.Create(ChatPanel);
    DateLabel.Parent := ChatPanel;
    DateLabel.Left := 10;
    DateLabel.Top := 30;
    DateLabel.Caption := FDQueryMembers.FieldByName('date').AsString + ' ' +
                         FDQueryMembers.FieldByName('time').AsString;
    DateLabel.Tag := ChatPanel.Tag;
    DateLabel.OnClick := ChatPanelClick;

    LastMsgLabel := TLabel.Create(ChatPanel);
    LastMsgLabel.Parent := ChatPanel;
    LastMsgLabel.Left := 200;
    LastMsgLabel.Top := 30;
    LastMsgLabel.Caption := FDQueryMembers.FieldByName('last_message').AsString;
    LastMsgLabel.Tag := ChatPanel.Tag;
    LastMsgLabel.OnClick := ChatPanelClick;

    TopOffset := TopOffset + ChatPanel.Height + 5;
    FDQueryMembers.Next;
  end;

  if (FDQueryMembers.RecordCount = 0) and (not Silent) then
    ShowMessage('참여 중인 채팅방이 없습니다.');

  FDQueryMembers.Close;
end;

procedure TForm7.Timer1Timer(Sender: TObject);
begin
  try
    LoadChat(True);
  except
  end;
end;

procedure TForm7.ChatPanelClick(Sender: TObject);
var
  RoomID: Integer;
  qryUserNo, qryNum: Integer;
  qryChatRoomId: Integer;
  qryChatRoomName, qryName: string;
begin
  if Sender is TPanel then
    RoomID := (Sender as TPanel).Tag
  else if Sender is TLabel then
    RoomID := (Sender as TLabel).Tag
  else
    Exit;

  FDQueryMembers.Close;
  FDQueryMembers.SQL.Text :=
    ' SELECT cu.ChatRoomId, c.num, u.userno, c.chatroomname, u.name '+
    ' FROM chat_user cu '+
    ' JOIN chat c ON c.ChatRoomId = cu.ChatRoomId '+
    ' JOIN user u ON u.userno = cu.userno '+
    ' WHERE c.ChatRoomId = :RoomId AND u.userno = :UserNo ';

  FDQueryMembers.ParamByName('RoomId').AsInteger := RoomID;
  FDQueryMembers.ParamByName('UserNo').AsInteger := Self.UserNo;
  FDQueryMembers.Open;

  try
    if FDQueryMembers.IsEmpty then
    begin
      ShowMessage('해당 방의 정보가 없습니다.');
      Exit;
    end;

    qryChatRoomId := FDQueryMembers.FieldByName('ChatRoomId').AsInteger;
    qryNum := FDQueryMembers.FieldByName('num').AsInteger;
    qryUserNo := FDQueryMembers.FieldByName('userno').AsInteger;
    qryChatRoomName := FDQueryMembers.FieldByName('chatroomname').AsString;
    qryName := FDQueryMembers.FieldByName('name').AsString;

    // 📌 핵심 수정: 소켓 연결 먼저 확인하고 연결
    if not Form1.ClientSocket1.Active then
    begin
      try
        Form1.ClientSocket1.Address := '127.0.0.1';
        Form1.ClientSocket1.Port := 8080;
        Form1.ClientSocket1.Active := True;

        // 소켓 연결이 완료될 때까지 잠깐 대기 (선택사항)
        Sleep(100);
      except
        on E: Exception do
        begin
          ShowMessage('서버 연결 실패: ' + E.Message);
          Exit;
        end;
      end;
    end;

    // 📌 방 정보 먼저 설정 (JoinChatRoom에서 CurrentRoomID를 사용하므로)
    Form1.JoinChatRoom(qryChatRoomId, qryNum, qryChatRoomName);

    // 📌 채팅 초기화
    Form1.InitializeChat(qryChatRoomId, qryNum, qryUserNo, qryName, qryChatRoomName);

    ShowMessage('채팅방 ' + IntToStr(qryChatRoomId) + ' 입장 (방명: ' + qryChatRoomName + ')');

    Form1.Show;
    Self.Hide;

  finally
    FDQueryMembers.Close;
  end;
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
  Application.CreateForm(TForm11, Form11);
  Form11.Show;
end;

procedure TForm7.Button3Click(Sender: TObject);
begin
  Form8.Show;
end;

procedure TForm7.Button1Click(Sender: TObject);
begin
  if not IsLoggedIn then
  begin
    if Form3.ShowModal = mrOk then
    begin
      IsLoggedIn := True;

      Edit1.Enabled   := True;
      Edit2.Enabled   := True;
      Button6.Enabled := True;
      Button2.Enabled := True;
      Button3.Enabled := True;
      Button4.Caption := '로그아웃';
      LoadChat;

      Timer1.Interval := 5000;
      Timer1.Enabled := True;
    end;
  end
  else
  begin
    IsLoggedIn := False;
    CurrentUser.ID := '';
    CurrentUser.Name := '';
    CurrentUser.Role := '';

    Edit1.Enabled   := False;
    Edit2.Enabled   := False;
    Button6.Enabled := False;
    Button2.Enabled := False;
    Button3.Enabled := False;
    Button4.Caption := '로그인';

    ScrollBox1.DestroyComponents;
    ShowMessage('로그아웃 되었습니다.');

    Timer1.Enabled := False;
  end;
end;

procedure TForm7.Button4Click(Sender: TObject);
begin
  if not IsLoggedIn then
  begin
    if Form2.ShowModal = mrOk then
    begin
      IsLoggedIn := True;

      Edit1.Enabled   := True;
      Edit2.Enabled   := True;
      Button6.Enabled := True;
      Button2.Enabled := True;
      Button3.Enabled := True;
      Button4.Caption := '로그아웃';
      LoadChat;

      Timer1.Interval := 5000;
      Timer1.Enabled := True;
    end;
  end
  else
  begin
    IsLoggedIn := False;
    CurrentUser.ID := '';
    CurrentUser.Name := '';
    CurrentUser.Role := '';

    Edit1.Enabled   := False;
    Edit2.Enabled   := False;
    Button6.Enabled := False;
    Button4.Caption := '로그인';

    ScrollBox1.DestroyComponents;
    ShowMessage('로그아웃 되었습니다.');

    Timer1.Enabled := False;
  end;
end;

procedure TForm7.Button6Click(Sender: TObject);
var
  ChatRoomID, num, userno: Integer;
  chatpw, chatroomname: String;
begin
  if not IsLoggedIn then
  begin
    ShowMessage('로그인이 필요합니다.');
    Exit;
  end;

  userno := CurrentUser.UserNo;

  if not TryStrToInt(Trim(Edit2.Text), ChatRoomID) then
  begin
    ShowMessage('유효한 방 번호를 입력하세요.');
    Exit;
  end;

  chatpw := Trim(Edit1.Text);

  FDQueryMembers.Close;
  FDQueryMembers.SQL.Text :=
    'SELECT chatpw, num, ChatRoomId, chatroomname ' +
    'FROM chat ' +
    'WHERE chatpw = :chatpw AND ChatRoomId = :ChatRoomID';
  FDQueryMembers.ParamByName('chatpw').AsString := chatpw;
  FDQueryMembers.ParamByName('ChatRoomID').AsInteger := ChatRoomID;
  FDQueryMembers.Open;

  if FDQueryMembers.IsEmpty then
  begin
    ShowMessage('비밀번호가 일치하지 않거나 존재하지 않는 방입니다.');
    Exit;
  end;

  chatroomname := FDQueryMembers.FieldByName('chatroomname').AsString;
  num := FDQueryMembers.FieldByName('num').AsInteger;

  // 📌 소켓 연결 확인 및 연결
  if not Form1.ClientSocket1.Active then
  begin
    try
      Form1.ClientSocket1.Address := '127.0.0.1';
      Form1.ClientSocket1.Port := 8080;
      Form1.ClientSocket1.Active := True;
      Sleep(100);
    except
      on E: Exception do
      begin
        ShowMessage('서버 연결 실패: ' + E.Message);
        Exit;
      end;
    end;
  end;

  Form1.JoinChatRoom(ChatRoomID, num, chatroomname);
  Form1.InitializeChat(ChatRoomID, num, userno, CurrentUser.Name, chatroomname);
  Form1.Show;
  Self.Hide;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
  if not IsLoggedIn then
  begin
    Button2.Enabled := False;
    Button3.Enabled := False;
  end
  else
  begin
    Button2.Enabled := True;
    Button3.Enabled := True;
  end;

  Timer1.Interval := 5000;
  Timer1.Enabled := False;
end;

end.
