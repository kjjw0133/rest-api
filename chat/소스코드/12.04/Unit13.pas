unit Unit13;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, math, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet;

type
  TForm13 = class(TForm)
    LabelTitle: TLabel;
    pnlSearch: TPanel;
    pbSearchBG: TPaintBox;
    edtSearch: TEdit;
    lbFriends: TListBox;
    PanelBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    userCountLabel: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure pbSearchBGPaint(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure edtSearchEnter(Sender: TObject);
    procedure edtSearchExit(Sender: TObject);
    procedure lbFriendsMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure lbFriendsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbFriendsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FAllNames: TStringList;
    procedure PopulateAllNames;
    procedure FilterList(const Keyword: string);
    procedure DrawMagnifier(const C: TCanvas; const R: TRect);
  public
  end;

var
  Form13: TForm13;
  status: Boolean = False;


implementation

{$R *.dfm}
uses unit8,Unit7, unit2,unit1;

const
  AVATAR_SIZE = 36;    // 프로필 아이콘 크기
  ITEM_PADDING = 8;
  RADIUS = 24;         // 검색창 — 카톡 스타일 완전 둥근 곡률

procedure TForm13.FormCreate(Sender: TObject);
var
  Rgn: HRGN;
begin
  FAllNames := TStringList.Create;
  PopulateAllNames;

  lbFriends.Style := lbOwnerDrawVariable;
  lbFriends.DoubleBuffered := True;

  FilterList('');

  pbSearchBG.SendToBack;

  // 패널을 둥글게 만들기
  Rgn := CreateRoundRectRgn(0, 0, pnlSearch.Width + 1, pnlSearch.Height + 1,
                            pnlSearch.Height, pnlSearch.Height);
  SetWindowRgn(pnlSearch.Handle, Rgn, True);
end;

{ ---------------- Data load ---------------- }
procedure TForm13.PopulateAllNames;
var
  username : String;
begin
//   test있는 곳에 데이터 베이스에서 가져온 친구 추가된 유저를 가져옴
//  FDQuery1.Close;
//  FDQuery1.SQL.Text := 'select * from friend where status = :status ';
//  FDQuery1.Open;
//
//  FDQuery1.FieldByName('requester_id').AsString := username;
//  FDQuery1.FieldByName('receiver_id').AsString := username;

  FAllNames.Clear;
  FAllNames.Add('test1');
  FAllNames.Add('한국어 테스트');
  FAllNames.Add('test3');
  FAllNames.Add('test4');
  FAllNames.Add('test5');
  FAllNames.Add('test6');
  FAllNames.Add('test7');
  FAllNames.Add('test8');
  FAllNames.Add('test9');
  FAllNames.Add('test10');
end;

{ ---------------- Filter ---------------- }
procedure TForm13.FilterList(const Keyword: string);
var
  i: Integer;
  s: string;
begin
  lbFriends.Items.BeginUpdate;
  try
    lbFriends.Items.Clear;

    for i := 0 to FAllNames.Count - 1 do
    begin
      s := FAllNames[i];
      if (Keyword = '') or (Pos(LowerCase(Keyword), LowerCase(s)) > 0) then
        lbFriends.Items.Add(s);
    end;

    lbFriends.ItemIndex := -1;
  finally
    lbFriends.Items.EndUpdate;
  end;

  lbFriends.Invalidate;
end;

procedure TForm13.edtSearchChange(Sender: TObject);
begin
  FilterList(Trim(edtSearch.Text));
end;

procedure TForm13.edtSearchEnter(Sender: TObject);
begin
  pbSearchBG.Invalidate;
end;

procedure TForm13.edtSearchExit(Sender: TObject);
begin
  pbSearchBG.Invalidate;
end;

{ ---------------- PaintBox: search bar ---------------- }
procedure TForm13.pbSearchBGPaint(Sender: TObject);
var
  C: TCanvas;
  R: TRect;
  PenCol: TColor;
begin
  C := pbSearchBG.Canvas;
  R := pbSearchBG.ClientRect;

  if edtSearch.Focused then
    PenCol := RGB(100,160,255)
  else
    PenCol := $00C8C8C8;

  C.Brush.Style := bsSolid;
  C.Brush.Color := clWhite;
  C.Pen.Style := psSolid;
  C.Pen.Color := PenCol;
  C.Pen.Width := 1;

  InflateRect(R, -1, -1);

  C.RoundRect(
    R.Left, R.Top, R.Right, R.Bottom,
    R.Height, R.Height
  );

  DrawMagnifier(C, Rect(
    R.Left + 8,
    R.Top + (R.Height - 20) div 2,
    R.Left + 8 + 20,
    R.Top + (R.Height - 20) div 2 + 20
  ));
end;

{ ---------------- Magnifier icon ---------------- }
procedure TForm13.DrawMagnifier(const C: TCanvas; const R: TRect);
//var
//  cx, cy, r: Integer;
//  OldPenWidth: Integer;
begin
//  cx := (R.Left + R.Right) div 2 - 2;
//  cy := (R.Top + R.Bottom) div 2 - 2;
//  r  := 6;
//  OldPenWidth := C.Pen.Width;
//  C.Pen.Width := 1;
//  C.Pen.Color := clGray;
//  C.Brush.Style := bsClear;
//
//  C.Ellipse(cx - r, cy - r, cx + r, cy + r);
//
//  C.MoveTo(cx + Round(r*0.7), cy + Round(r*0.7));
//  C.LineTo(cx + r + 6, cy + r + 6);
//
//  C.Pen.Width := OldPenWidth;
end;

{ ---------------- List item height ---------------- }
procedure TForm13.lbFriendsMeasureItem(Control: TWinControl; Index: Integer;
  var Height: Integer);
begin
  Height := Max(AVATAR_SIZE + ITEM_PADDING, 46);
end;

{ ---------------- Owner Draw list ---------------- }
procedure TForm13.lbFriendsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  C: TCanvas;
  sName: string;
  isSel: Boolean;
  YCenter: Integer;
  avatarRect, radioRect, R: TRect;
  colBg: TColor;
  TextLeft: Integer;
begin
  C := lbFriends.Canvas;
  sName := lbFriends.Items[Index];
  isSel := (lbFriends.ItemIndex = Index);

  if odSelected in State then
    C.Brush.Color := $00F0F8FF
  else
    C.Brush.Color := clWhite;
  C.FillRect(Rect);

  YCenter := (Rect.Top + Rect.Bottom) div 2;

  avatarRect.Left   := Rect.Left + ITEM_PADDING;
  avatarRect.Right  := avatarRect.Left + AVATAR_SIZE;
  avatarRect.Top    := YCenter - AVATAR_SIZE div 2;
  avatarRect.Bottom := avatarRect.Top + AVATAR_SIZE;

  colBg := RGB(
    150 + (Ord(sName[1]) * 3) mod 100,
    120 + (Ord(sName[1]) * 5) mod 100,
    160 + (Ord(sName[1]) * 7) mod 80
  );

  C.Brush.Color := colBg;
  C.Pen.Color := colBg;
  C.Ellipse(avatarRect.Left, avatarRect.Top, avatarRect.Right, avatarRect.Bottom);

  C.Font.Name := 'Segoe UI';
  C.Font.Size := 10;
  C.Font.Style := [fsBold];
  C.Font.Color := clWhite;

  DrawText(C.Handle, PChar(Copy(sName,1,1)), 1,
    avatarRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE);

  TextLeft := avatarRect.Right + ITEM_PADDING;

  R := Rect;
  R.Left := TextLeft;
  R.Right := Rect.Right - 40;

  C.Font.Size := 11;
  C.Font.Style := [];
  C.Font.Color := clWindowText;

  DrawText(C.Handle, PChar(sName), Length(sName), R,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE);

  radioRect.Left := Rect.Right - ITEM_PADDING - 18;
  radioRect.Right := radioRect.Left + 18;
  radioRect.Top := YCenter - 9;
  radioRect.Bottom := radioRect.Top + 18;

  C.Brush.Style := bsClear;
  C.Pen.Color := $00C8C8C8;
  C.Ellipse(radioRect.Left, radioRect.Top, radioRect.Right, radioRect.Bottom);

  if isSel then
  begin
    C.Brush.Style := bsSolid;
    C.Brush.Color := RGB(100,160,255);
    C.Pen.Color := C.Brush.Color;
    C.Ellipse(radioRect.Left+5, radioRect.Top+5,
              radioRect.Right-5, radioRect.Bottom-5);
  end;
end;

procedure TForm13.lbFriendsClick(Sender: TObject);
begin
  lbFriends.Invalidate;
end;

procedure TForm13.btnOKClick(Sender: TObject);
type
  TLetters = array[0..25] of String;
const
  LETTERS: TLetters = (
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
    'q','r','s','t','u','v','w','x','y','z'
  );
var
  num,chatpw, RandChar,chatroomname: String;
  I, R,ChatRoomID, userno,ChatType: Integer;
begin
  ChatType := form8.ChatType;
  chatroomname := Form8.chatroomname;

  if lbFriends.ItemIndex >= 0 then
    ShowMessage('선택: ' + lbFriends.Items[lbFriends.ItemIndex])
  else
    ShowMessage('항목을 선택하세요.');
    Randomize;
  chatpw := '';
  userno := CurrentUser.UserNo;

    for I := 1 to 8 do
    begin
      if Random(2) = 0 then
      begin
        R := Random(26);
        RandChar := LETTERS[R];
      end
      else
      begin
        R := Random(10);
        RandChar := IntToStr(R);
      end;
      chatpw := chatpw + RandChar;
    end;

    if ChatType = 1 then
    begin
      FDQuery1.SQL.Text :=
      'INSERT INTO chat(chatroomname, ChatType, chatpw) VALUES(:chatroomname, :ChatType, :chatpw)';
      FDQuery1.ParamByName('chatroomname').AsWideString := chatroomname;
      FDQuery1.ParamByName('chatpw').AsString := chatpw;
      FDQuery1.ParamByName('ChatType').AsInteger := ChatType;
      FDQuery1.ExecSQL;
      Form8.Close;

      FDQuery1.SQL.Text :=
        'SELECT ChatRoomID FROM chat WHERE chatroomname = :chatroomname';
      FDQuery1.ParamByName('chatroomname').AsWideString := chatroomname;
      FDQuery1.Open;

      ChatRoomID := FDQuery1.FieldByName('ChatRoomID').AsInteger;

      Form1.InitializeChat(ChatRoomID, 0, userno, CurrentUser.Name, chatroomname);
      ShowMessage('방 번호: ' + IntToStr(ChatRoomID) + #13#10 + '방 비밀번호: ' + chatpw);
      Exit;
    end
  else if ChatType = 2 then
  begin
    FDQuery1.SQL.Text :=
      'INSERT INTO chat(chatroomname, ChatType) VALUES(:chatroomname, :ChatType)';
    FDQuery1.ParamByName('chatroomname').AsWideString := chatroomname;
    FDQuery1.ParamByName('ChatType').AsInteger := ChatType;
    FDQuery1.ExecSQL;

    FDQuery1.SQL.Text :=
      'SELECT ChatRoomID FROM chat WHERE chatroomname = :chatroomname';
    FDQuery1.ParamByName('chatroomname').AsWideString := chatroomname;
    FDQuery1.Open;

    ChatRoomID := FDQuery1.FieldByName('ChatRoomID').AsInteger;

    Form1.InitializeChat(ChatRoomID, 0, userno, CurrentUser.Name, chatroomname);
    ShowMessage('방 번호: ' + IntToStr(ChatRoomID));
  end;

end;

end.

