unit Unit8;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TForm8 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    FDQueryMembers: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDConnection1: TFDConnection;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

uses
Unit7, unit2,unit1;

procedure TForm8.Button1Click(Sender: TObject);
type
  TLetters = array[0..25] of String;
const
  LETTERS: TLetters = (
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
    'q','r','s','t','u','v','w','x','y','z'
  );
var
num,chatroomname,chatpw,RandChar : String;
I,R, ChatType,ChatRoomID,userno: Integer;
begin

chatroomname := Trim(edit1.Text);
num := '1';
Randomize;
chatpw := '';
userno := CurrentUser.UserNo;

if RadioButton1.Checked then
begin
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
  FDQueryMembers.SQL.Text := ' insert into chat(chatroomname, num, ChatType,chatpw) values(:chatroomname, :num, :ChatType, :chatpw)';
    FDQueryMembers.ParamByName('chatroomname').AsWideString    := chatroomname;
    FDQueryMembers.ParamByName('num').AsString   := (num);
    FDQueryMembers.ParamByName('chatpw').AsString   := chatpw;
    FDQueryMembers.ParamByName('ChatType').AsInteger   := 1;
    FDQueryMembers.ExecSQL;
    Form8.Close;


    FDQueryMembers.SQL.Text := 'select ChatRoomID '+
    'from  chat '+
    'where chatroomname = :chatroomname ';

    FDQueryMembers.ParamByName('chatroomname').AsWideString := chatroomname;
    FDQueryMembers.Open;

    ChatRoomID := FDQueryMembers.FieldByName('ChatRoomID').AsInteger;

    Form1.InitializeChat(ChatRoomID, strtoint(num), userno, CurrentUser.Name, chatroomname);
    ShowMessage('방 번호: ' + inttostr(ChatRoomID) + #13#10 + '방 비밀번호: ' + chatpw);
    Form1.Show;
    Self.Hide;

    Edit1.Clear;
    Edit2.Clear;

    exit;
end
else
    FDqueryMembers.SQL.Text := ' insert into chat(chatroomname , num , ChatType) values(:chatroomname , :num ,:ChatType)';
    FDQueryMembers.ParamByName('chatroomname').AsWideString    := chatroomname;
    FDQueryMembers.ParamByName('num').AsString   := (num);
    FDQueryMembers.ParamByName('ChatType').AsInteger   := 2;

    FDQueryMembers.ExecSQL;

    FDQueryMembers.SQL.Text := 'select ChatRoomID '+
    'from  chat '+
    'where chatroomname = :chatroomname ';

    FDQueryMembers.ParamByName('chatroomname').AsWideString := chatroomname;
    FDQueryMembers.Open;

    ChatRoomID := FDQueryMembers.FieldByName('ChatRoomID').AsInteger;

    Form1.InitializeChat(ChatRoomID, strtoint(num), userno, CurrentUser.Name, chatroomname);
    ShowMessage('방 번호: ' + inttostr(ChatRoomID));

    Form1.Show;
    Self.Hide;

    Edit1.Clear;
    Edit2.Clear;

    Form8.Close;
end;


end.


